#
# Cookbook Name:: swift-private-cloud
# Recipe:: proxy-server
#
# Copyright 2012, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "swift-private-cloud::attr-remap"
include_recipe "swift-private-cloud::common"
include_recipe "swift-lite::proxy-server"

common = node["swift-private-cloud"]["swift_common"]

# find memcache servers and keystone endpoint
memcache_endpoints = get_realserver_endpoints(node["swift"]["memcache_role"], "memcached", "cache")

memcache_servers = memcache_endpoints.collect do |endpoint|
  "#{endpoint["host"]}:#{endpoint["port"]}"
end.join(",")

# FIXME(rp)
# this could likely be obtained from the native swift-private-cloud stuff
swift_settings = node["swift"] unless get_settings_by_recipe("swift-lite::setup", "swift") != nil

if swift_settings.has_key?("keystone_endpoint")
  keystone_auth_uri = swift_settings["keystone_endpoint"]
else
  ks_admin = get_access_endpoint(node["keystone"]["api_role"], "keystone", "admin-api")
  keystone_auth_uri = ks_admin.uri
end

keystone_uri = URI(keystone_auth_uri)


default_options = {
  "DEFAULT" => {
    "bind_ip" => "0.0.0.0",
    "bind_port" => "8080",
    "backlog" => "4096",
    "workers" => 12
  },
  "pipeline:main" => {
    "pipeline" => "catch_errors proxy-logging healthcheck cache ratelimit authtoken keystoneauth proxy-server"
  },
  "app:proxy-server" => {
    "use" => "egg:swift#proxy",
    "log_facility" => "LOG_LOCAL0",
    "node_timeout" => "60",
    "client_timeout" => "60",
    "conn_timeout" => "3.5",
    "allow_account_management" => "false",
    "account_autocreate" => "true"
  },
  "filter:authtoken" => {
    "paste.filter_factory" => "keystoneclient.middleware.auth_token:filter_factory",
    "delay_auth_decision" => "1",
    "auth_host" => keystone_uri.host,
    "auth_port" => keystone_uri.port,
    "auth_protocol" => keystone_uri.scheme,
    "admin_tenant_name" => node["swift-private-cloud"]["keystone"]["auth_tenant"],
    "admin_user" => node["swift-private-cloud"]["keystone"]["auth_user"],
    "admin_password" => node["swift-private-cloud"]["keystone"]["auth_password"],
    "signing_dir" => "/var/cache/swift",
    "cache" => "swift.cache",
    "token_cache_time" => 86100
  },
  "filter:keystoneauth" => {
    "use" => "egg:swift#keystoneauth",
    "operator_roles" => "admin, swiftoperator"
  },
  "filter:healthcheck" => {
    "use" => "egg:swift#healthcheck"
  },
  "filter:cache" => {
    "use" => "egg:swift#memcache",
    "memcache_serialization_support" => "2",
    "memcache_servers" => memcache_servers
  },
  "filter:ratelimit" => {
    "use" => "egg:swift#ratelimit"
  },
  "filter:domain_remap" => {
    "use" => "egg:swift#domain_remap"
  },
  "filter:catch_errors" => {
    "use" => "egg:swift#catch_errors"
  },
  "filter:cname_lookup" => {
    "use" => "egg:swift#cname_lookup"
  },
  "filter:staticweb" => {
    "use" => "egg:swift#staticweb"
  },
  "filter:tempurl" => {
    "use" => "egg:swift#tempurl"
  },
  "filter:formpost" => {
    "use" => "egg:swift#tempurl"
  },
  "filter:name_check" => {
    "use" => "egg:swift#name_check"
  },
  "filter:list-endpoints" => {
    "use" => "egg:swift#list_endpoints"
  },
  "filter:proxy-logging" => {
    "use" => "egg:swift#proxy_logging"
  },
  "filter:bulk" => {
    "use" => "egg:swift#bulk"
  },
  "filter:container-quotas" => {
    "use" => "egg:swift#container_quotas"
  },
  "filter:slo" => {
    "use" => "egg:swift#slo"
  },
  "filter:account-quotas" => {
    "use" => "egg:swift#account_quotas"
  },
  "filter:informant" => {
    "use" => "egg:informant#informant"
  }
}

overrides = { "DEFAULT" => node["swift-private-cloud"]["swift_common"].select { |k, _| k.start_with?("log_statsd_") }}

if node["swift-private-cloud"]["proxy"] and node["swift-private-cloud"]["proxy"]["config"]
  overrides = overrides.merge(node["swift-private-cloud"]["proxy"]["config"]) { |k, x, y| x.merge(y) }
end

resources("template[/etc/swift/proxy-server.conf]").instance_exec do
  cookbook "swift-private-cloud"
  source "inifile.conf.erb"
  mode "0644"
  variables("config_options" => default_options.merge(overrides) { |k, x, y| x.merge(y) })
end

cron_d "memcache-restart" do
  mailto "swiftops"
  user "root"

  minute "*/2"
  command "/usr/local/bin/check_memcache_wrapper.sh"
end

# /etc/default
template "/etc/default/memcached" do
  source "proxy/etc/default/memcached.erb"
  only_if { platform_family?("debian") }
end

# /etc/memcached.conf
template "/etc/memcached.conf" do
  source "proxy/etc/memcached.conf.erb"
  owner "root"
  group "root"
  mode 0064
  variables(
    :maxmem => node["swift-private-cloud"]["proxy"]["memcache_maxmem"],
    :simconn => node["swift-private-cloud"]["proxy"]["sim_connections"]
  )
  notifies :restart, "service[memcached]"
end

# /usr/local/bin
template "/usr/local/bin/check_memcache.py" do
  source "proxy/usr/local/bin/check_memcache.py.erb"
  user "root"
  mode "0500"
end

template "/usr/local/bin/check_memcache_wrapper.sh" do
  source "proxy/usr/local/bin/check_memcache_wrapper.sh.erb"
  user "root"
  mode "0500"
end

template "/usr/local/bin/memcache_info.py" do
  source "proxy/usr/local/bin/memcache_info.py.erb"
  user "root"
  mode "0500"
end

cookbook_file "/usr/local/bin/ringminion_setup.sh" do
  source "storage/usr/local/bin/ringminion_setup.sh"
  user "root"
  mode "0755"
end
