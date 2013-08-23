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

resources("template[/etc/swift/account-server.conf]") do
  cookbook "swift-private-cloud"
  mode "0644"
  variables variables.merge("log_statsd_host" => common["log_statsd_host"],
                            "log_statsd_port" => common["log_statsd_port"],
                            "log_statsd_default_sample_rate" => common["log_statsd_default_sample_rate"],
                            "log_statsd_sample_rate_factor" => common["log_statsd_sample_rate_factor"],
                            "log_status_metric_prefix" => common["log_statsd_metric_prefix"])
end
