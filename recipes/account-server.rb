#
# Cookbook Name:: swift-private-cloud
# Recipe:: account-server
#
# Copyright 2013, Rackspace US, Inc.
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

include_recipe "swift-lite::account-server"

common = node["swift-private-cloud"]["swift_common"]

default_options = {
  "DEFAULT" => {
    "bind_ip" => "0.0.0.0",
    "bind_port" => 6002,
    "workers" => 6,
    "user" => "swift",
    "swift_dir" => "/etc/swift",
    "devices" => "/srv/node",
    "db_preallocation" => "off"
  },
  "pipeline:main" => {
    "pipeline" => "healthcheck recon account-server"
  },
  "app:account-server" => {
    "use" => "egg:swift#account",
    "log_facility" => "LOG_LOCAL1"
  },
  "filter:healthcheck" => {
    "use" => "egg:swift#healthcheck"
  },
  "filter:recon" => {
    "use" => "egg:swift#recon",
    "log_facility" => "LOG_LOCAL2",
    "recon_cache_path" => "/var/cache/swift",
    "recon_lock_path" => "/var/lock/swift"
  },
  "account-replicator" => {
    "log_facility" => "LOG_LOCAL2",
    "per_diff" => 10000,
    "concurrency" => 4,
  },
  "account-auditor" => {
    "log_facility" => "LOG_LOCAL2",
    "interval" => 1800
  },
  "account-reaper" => {
    "log_facility" => "LOG_LOCAL2",
    "concurrency" => 5,
    "delay_reaping" => 604800
  }
}



overrides = { "DEFAULT" => node["swift-private-cloud"]["swift_common"].select { |k, _| k.start_with?("log_statsd_") }}

if node["swift-private-cloud"]["account"] and node["swift-private-cloud"]["account"]["config"]
  overrides = overrides.merge(node["swift-private-cloud"]["account"]["config"]) { |k, x, y| x.merge(y) }
end

resources("template[/etc/swift/account-server.conf]").instance_exec do
  cookbook "swift-private-cloud"
  source "inifile.conf.erb"
  mode "0644"
  variables("config_options" => default_options.merge(overrides) { |k, x, y| x.merge(y) })
end
