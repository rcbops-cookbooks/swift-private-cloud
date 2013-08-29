#
# Cookbook Name:: swift-private-cloud
# Attributes:: default
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

free_memory = node["memory"]["free"].to_i

# common
default["swift-private-cloud"]["common"]["ssh_user"] = "swiftops"
default["swift-private-cloud"]["common"]["ssh_key"] = "/tmp/id_rsa_swiftops.priv"
default["swift-private-cloud"]["common"]["swift_generic"] = "swift python-swift python-swiftclient"
default["swift-private-cloud"]["common"]["swift_proxy"] =
  "swift-proxy python-keystone python-keystoneclient memcached python-memcache"
default["swift-private-cloud"]["common"]["swift_storage"] = "swift-account swift-container swift-object"
default["swift-private-cloud"]["common"]["swift_others"] = "python-suds"

if platform_family?("debian")
  default["swift-private-cloud"]["common"]["pkg_options"] =
    "-y -qq --force-yes -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold"
else
  default["swift-private-cloud"]["common"]["pkg_options"] = ""
end

# network
#default["swift-private-cloud"]["network"]["management"] = "cidr"
#default["swift-private-cloud"]["network"]["exnet"] = "cidr"

# swift_common
default["swift-private-cloud"]["swift_common"]["swift_hash_prefix"] = nil
default["swift-private-cloud"]["swift_common"]["swift_hash_suffix"] = nil
default["swift-private-cloud"]["swift_common"]["admin_ip"] = nil
default["swift-private-cloud"]["swift_common"]["syslog_ip"] = nil

# common statsd config -- these will be merged into configs unless overridden in the specific
# object/container/etc tunings
default["swift-private-cloud"]["swift_common"]["log_statsd_host"] = nil
default["swift-private-cloud"]["swift_common"]["log_statsd_port"] = 8125
default["swift-private-cloud"]["swift_common"]["log_statsd_default_sample_rate"] = 1.0
default["swift-private-cloud"]["swift_common"]["log_statsd_sample_rate_factor"] = 1.0
default["swift-private-cloud"]["swift_common"]["log_statsd_metric_prefix"] = nil

# object server tuning

# Note that any object-server config can be represented here, but these are the
# knobs most frequently frobbed.
default["swift-private-cloud"]["object"]["config"]["DEFAULT"]["workers"] = 8
default["swift-private-cloud"]["object"]["config"]["DEFAULT"]["backlog"] = 4096
default["swift-private-cloud"]["object"]["config"]["DEFAULT"]["disable_fallocate"] = false
default["swift-private-cloud"]["object"]["config"]["DEFAULT"]["fallocate_reserve"] = 0

default["swift-private-cloud"]["object"]["config"]["app:object-server"]["node_timeout"] = 3
default["swift-private-cloud"]["object"]["config"]["app:object-server"]["conn_timeout"] = 0.5

default["swift-private-cloud"]["object"]["config"]["object-replicator"]["run_pause"] = 30
default["swift-private-cloud"]["object"]["config"]["object-replicator"]["concurrency"] = 6
default["swift-private-cloud"]["object"]["config"]["object-replicator"]["rsync_timeout"] = 900
default["swift-private-cloud"]["object"]["config"]["object-replicator"]["rsync_io_timeout"] = 30
default["swift-private-cloud"]["object"]["config"]["object-replicator"]["http_timeout"] = 60
default["swift-private-cloud"]["object"]["config"]["object-replicator"]["lockup_timeout"] = 1800

default["swift-private-cloud"]["object"]["config"]["object-updater"]["concurrency"] = 3
default["swift-private-cloud"]["object"]["config"]["object-updater"]["node_timeout"] = 60
default["swift-private-cloud"]["object"]["config"]["object-updater"]["conn_timeout"] = 5
default["swift-private-cloud"]["object"]["config"]["object-updater"]["slowdown"] = 0.01

# Note that any proxy-server config can be represented here, but these are the
# knobs most frequently frobbed.
default["swift-private-cloud"]["proxy"]["config"]["DEFAULT"]["backlog"] = 4096
default["swift-private-cloud"]["proxy"]["config"]["DEFAULT"]["workers"] = 12

default["swift-private-cloud"]["proxy"]["config"]["pipline:main"]["pipeline"] = "catch_errors proxy-logging healthcheck cache ratelimit authtoken keystoneauth proxy-server"

default["swift-private-cloud"]["proxy"]["config"]["app:proxy-server"]["node_timeout"] = 60
default["swift-private-cloud"]["proxy"]["config"]["app:proxy-server"]["client_timeout"] = 60
default["swift-private-cloud"]["proxy"]["config"]["app:proxy-server"]["conn_timeout"] = 3.5
default["swift-private-cloud"]["proxy"]["config"]["app:proxy-server"]["error_suppression_interval"] = 60
default["swift-private-cloud"]["proxy"]["config"]["app:proxy-server"]["error_suppression_limit"] = 10
default["swift-private-cloud"]["proxy"]["config"]["app:proxy-server"]["object_post_as_copy"] = true

# drive_audit
regex_patterns = [
  "\\berror\\b.*\\b(sd[a-z]{1,2}\\d?)\\b",
  "\\b(sd[a-z]{1,2}\d?)\\b.*\\berror\\b"]

default["swift-private-cloud"]["drive_audit"]["minutes"] = 5
default["swift-private-cloud"]["drive_audit"]["log_file_pattern"] = "/var/log/kern*"
default["swift-private-cloud"]["drive_audit"]["regex_patterns"] = regex_patterns

# proxy
default["swift-private-cloud"]["proxy"]["memcache_maxmem"] = 512
default["swift-private-cloud"]["proxy"]["sim_connections"] = 1024
default["swift-private-cloud"]["proxy"]["memcache_server_list"] = "127.0.0.1:11211"
default["swift-private-cloud"]["proxy"]["authtoken_factory"] = "keystoneclient.middleware.auth_token:filter_factory"
default["swift-private-cloud"]["proxy"]["sysctl"] = {
  "net.ipv4.tcp_tw_recycle" => "1",
  "net.ipv4.tcp_tw_reuse" => "1",
  "net.ipv4.ip_local_port_range" => "1024 61000",
  "net.ipv4.tcp_syncookies" => 0
}

# storage
default["swift-private-cloud"]["storage"]["sysctl"] = {
  "net.ipv4.tcp_tw_recycle" => "1",
  "net.ipv4.tcp_tw_reuse" => "1",
  "net.ipv4.ip_local_port_range" => "1024 61000",
  "net.ipv4.tcp_syncookies" => "0",
  "vm.min_free_kbytes" => (free_memory/2 > 1048576) ? 1048576 : (free_memory/2).to_i
}

# mailing
default["swift-private-cloud"]["mailing"]["email_addr"] = "me@mydomain.com"
default["swift-private-cloud"]["mailing"]["pager_addr"] = "mepager@mydomain.com"
default["swift-private-cloud"]["mailing"]["smarthost"] = nil
default["swift-private-cloud"]["mailing"]["relay_nets"] = nil  # array of cidr for relays
default["swift-private-cloud"]["mailing"]["outgoing_domain"] = "swift.mydomain.com"

# versioning
default["swift-private-cloud"]["versioning"]["versioning_system"] = "git"
default["swift-private-cloud"]["versioning"]["repository_base"] = "/srv/git"
default["swift-private-cloud"]["versioning"]["repository_name"] = "rings"
#default["swift-private-cloud"]["versioning"]["repository_host"] = "ip/hostname"

# keystone
default["swift-private-cloud"]["keystone"]["region"] = "RegionOne"
#default["swift-private-cloud"]["keystone"]["swift_admin_url"] = http://ip:port/v1/AUTH_%(tenant_id)s"
#default["swift-private-cloud"]["keystone"]["swift_internal_url"] = ...
#default["swift-private-cloud"]["keystone"]["swift_public_url"] = ...
#default["swift-private-cloud"]["keystone"]["keystone_admin_url"] = http://ip:port/v2.0
#default["swift-private-cloud"]["keystone"]["keystone_internal_url"] = ...
#default["swift-private-cloud"]["keystone"]["keystone_public_url"] = ...

default["swift-private-cloud"]["keystone"]["auth_user"] = "swift"
default["swift-private-cloud"]["keystone"]["auth_tenant"] = "service"
#default["swift-private-cloud"]["keystone"]["auth_password"] = "secrete"
default["swift-private-cloud"]["keystone"]["admin_user"] = "admin"
#default["swift-private-cloud"]["keystone"]["admin_password"] = "secrete"
default["swift-private-cloud"]["keystone"]["pki"] = false

# default["swift-private-cloud"]["keystone"]["auth_uri"] = "http://172.16.0.252:5000/v2.0"
# default["swift-private-cloud"]["keystone"]["keystone_admin_tenant"] = "service"
# default["swift-private-cloud"]["keystone"]["keystone_admin_user"] = "tokenvalidator"
# default["swift-private-cloud"]["keystone"]["keystone_admin_password"] = "noswifthere"

# dispersion
default["swift-private-cloud"]["dispersion"]["dis_tenant"] = "dispersion"
default["swift-private-cloud"]["dispersion"]["dis_user"] = "reporter"
#default["swift-private-cloud"]["dispersion"]["dis_key"] = "j4MJBJrsB19bM"
default["swift-private-cloud"]["dispersion"]["dis_coverage"] = "1"

# exim
if platform_family?("rhel")
  default["exim"]["platform"] = {
    "packages" => ["exim"],
    "service" => "exim",
    "removes" => ["postfix"]
  }
elsif platform_family?("debian")
  default["exim"]["platform"] = {
    "packages" => ["exim4"],
    "service" => "exim4",
    "removes" => ["postfix"]
  }
end

# snmp
if platform_family?("rhel")
  default["snmp"]["platform"] = {
    "packages" => ["net-snmp", "net-snmp-utils"],
    "service" => "snmpd"
  }
elsif platform_family?("debian")
  default["snmp"]["platform"] = {
    "packages" => ["snmp", "snmpd"],
    "service" => "snmpd"
  }
end

# syslog-ng
if platform_family?("rhel")
  default["syslog-ng"]["platform"] = {
    "packages" => ["syslog-ng", "syslog-ng-libdbi"],
    "service" => "syslog-ng",
    "replaces" => ["rsyslog", "syslog"]
  }
elsif platform_family?("debian")
  default["syslog-ng"]["platform"] = {
    "packages" => ["syslog-ng"],
    "service" => "syslog-ng",
    "replaces" => ["rsyslog"]
  }
end
