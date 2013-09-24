#
# Cookbook Name:: swift-private-cloud
# Recipe:: mail
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

if not node["swift-private-cloud"]["mailing"]["smarthost"]
  nodelist = get_nodes_by_recipe("swift-private-cloud::admin-server")
  if nodelist.length == 0
    raise "Must specify swift-private-cloud/mailing/smarthost"
  end

  network = "swift-management"
  my_ip = get_ip_for_net(network, node)
  smarthost_ip = get_ip_for_net(network, nodelist[0])

  if smarthost_ip != my_ip
    node.default["swift-private-cloud"]["mailing"]["smarthost"] = smarthost_ip
  end
end

node["exim"]["platform"]["packages"].each do |pkg|
  package pkg do
    options node["swift-private-cloud"]["common"]["pkg_options"]
  end
end

node["exim"]["platform"]["removes"].each do |svc|
  service svc do
    action [:disable, :stop]
  end

  package svc do
    action :remove
  end
end

service_name = node["exim"]["platform"]["service"]

service service_name do
  supports :restart => true, :status => true
  action [:enable, :start]
end

execute "configure-alternatives-mta" do
  command "alternatives --set mta /usr/sbin/sendmail.exim"
  only_if { platform_family?("rhel") }
end

execute "update-exim-config" do
  action :nothing
  command "update-exim4.conf"
  notifies :restart, "service[#{service_name}]", :delayed
  only_if { platform_family?("debian") }
end
