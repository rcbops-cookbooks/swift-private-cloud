#
# Cookbook Name:: swift-private-cloud
# Recipe:: logging
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

node["syslog-ng"]["platform"]["packages"].each do |pkg|
  package pkg
end

node["syslog-ng"]["platform"]["replaces"].each do |svc|
  service svc do
    action [:disable, :stop]
  end
end

service_name = node["syslog-ng"]["platform"]["service"]

service service_name do
  supports :restart => true, :status => true
  action [:enable, :start]
end

# drop fix for conf.d in older rhel epel syslog-ng (3.2)
# needs restart instead of reload for includes
directory "/etc/syslog-ng/conf.d" do
  mode "0755"
end

template "/etc/syslog-ng/syslog-ng.conf" do
  source "logging/etc/syslog-ng/syslog-ng.conf.erb"
  mode "0644"
  notifies :restart, "service[syslog-ng]", :delayed
  only_if { platform_family?("rhel") }
end

directory "/var/log/swift" do
  mode "0744"
end
