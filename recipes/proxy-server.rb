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

include_recipe "swift-private-cloud::base"
include_recipe "swift-private-cloud::ring-common"
include_recipe "swift-lite::proxy-server"
include_recipe "swift-private-cloud::keystoneclient-patch"
include_recipe "swift-private-cloud::swift-ratelimit-patch"

common = node["swift-private-cloud"]["swift_common"]

# fix memcache defaults (for debian)


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


overrides = { "DEFAULT" => node["swift-private-cloud"]["swift_common"].select { |k, _| k.start_with?("log_statsd_") }}

if node["swift-private-cloud"]["proxy"] and node["swift-private-cloud"]["proxy"]["config"]
  overrides = overrides.merge(node["swift-private-cloud"]["proxy"]["config"]) { |k, x, y| x.merge(y) }
end

resources("template[/etc/swift/proxy-server.conf]").instance_exec do
  mode "0644"
  variables(
    "config_options" => variables["config_options"].merge(overrides) { |k, x, y| x.merge(y) }
  )
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
