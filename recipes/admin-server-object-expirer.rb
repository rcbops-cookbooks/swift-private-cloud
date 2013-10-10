#
# Cookbook Name:: swift-private-cloud
# Recipe:: admin-server-object-expirer.rb
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

# this recipe assumes that the admin server role is not running a
# proxy server or an object server, as that is our reference
# architecture.  It will actively delete configs to prevent those
# services from starting.

include_recipe "swift-private-cloud::base"
include_recipe "swift-lite::common"


if platform_family?("rhel") then
  object_expirer_bundled_svc = "openstack-swift-proxy"
  svc = "openstack-swift-object-expirer"
elsif node["platform"] == "ubuntu"
  object_expirer_bundled_svc = "swift-object"
  svc = "swift-object-expirer"
else
  Chef::Application.fatal!("Unsupported platform #{node['platform']}")
end

template "/etc/swift/object-expirer.conf" do
  source "admin/etc/swift/object-expirer.conf.erb"
  owner "swift"
  group "swift"
  mode "0644"
  notifies :restart, "service[swift-object-expirer-service]", :delayed
end

package "swift object expirer package (#{object_expirer_bundled_svc})" do
  package_name object_expirer_bundled_svc
  action :install
  options node["swift-private-cloud"]["common"]["pkg_options"]
end

service "swift-object-expirer unwanted service" do
  service_name object_expirer_bundled_svc
  action [:disable, :stop]
end

file "remove object expirer's unwanted service's conf file" do
  path "/etc/swift/#{object_expirer_bundled_svc.sub("openstack-","")}.conf"
  action :delete
end

# logged bug https://bugs.launchpad.net/ubuntu/+source/swift/+bug/1235495
# when packages include an upstart job, this should be removed.
cookbook_file "object-expirer upstart job" do
  path "/etc/init/swift-object-expirer.conf"
  source "admin/etc/init/swift-object-expirer.conf"
  owner "root"
  group "root"
  mode "0644"
  only_if { node['platform'] == "ubuntu" }
end

link "object expirer init script" do
  target_file "/etc/init.d/swift-object-expirer"
  to "/lib/init/upstart-job"
  owner "root"
  group "root"
  mode "755"
  only_if { node['platform'] == "ubuntu" }
end

service "swift-object-expirer-service" do
  service_name svc
  action [:enable, :start]
  only_if "[ -e /etc/swift/object.ring.gz ] && [ -e /etc/swift/object-expirer.conf ]"
end

