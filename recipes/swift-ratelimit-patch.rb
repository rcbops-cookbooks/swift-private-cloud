#
# Cookbook Name:: swift-private-cloud
# Recipe:: swift-ratelimit-patch
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

node.default["osops"]["apply_patches"] = true

# See: https://wiki.rackspace.corp/OSPC/Swift_grizzly_patches
# Rate limit middleware is broken in 1.8
# This is fixed in v1.9+
template "/usr/lib/python2.6/site-packages/swift/common/middleware/ratelimit.py" do
  source "patches/swift/common/middleware/ratelimit.py.1.8.0-2.el6.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[swift-proxy]", :delayed
  only_if { ::Chef::Recipe::Patch.check_package_version("openstack-swift", "1.8.0-2.el6", node) }
end

template "/usr/share/pyshared/swift/common/middleware/ratelimit.py" do
  source "patches/swift/common/middleware/ratelimit.py.1.8.0-0ubuntu1.2~cloud0.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[swift-proxy]", :delayed
  only_if { ::Chef::Recipe::Patch.check_package_version("swift", "1.8.0-0ubuntu1.2~cloud0", node) }
end
