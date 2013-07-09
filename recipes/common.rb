#
# Cookbook Name:: swift-private-cloud
# Recipe:: common
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

include_recipe "swift-lite::ntp"
include_recipe "swift-lite::sysctl"

directory "/etc/syslog-ng/conf.d" do
  recursive true
end

template "/etc/syslog-ng/conf.d/swift-ng.conf" do
  source "syslog-ng/swift-ng.conf.erb"
  variables(
    :remote_syslog_ip => node["swift-private-cloud"]["syslog"]["ip"]
  )
end
