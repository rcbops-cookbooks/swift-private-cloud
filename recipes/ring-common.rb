#
# Cookbook Name:: swift-private-cloud
# Recipe:: ring-common
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

# cookbook_file "/usr/local/bin/ringminion_setup.sh" do
#   source "storage/usr/local/bin/ringminion_setup.sh"
#   user "root"
#   mode "0755"
# end

package "swift-ring-master-client" do
  action :install
end

service "swift-ring-minion" do
  action [ :disable, :stop ]
end

template "/etc/swift/ring-minion.conf" do
  owner "swift"
  group "swift"
  source "common/etc/swift/ring-minion.conf.erb"
  variables(
    :master_server => node["swift-private-cloud"]["ring"]["management_host"]
  )
end

cron_d "swift-ring-check" do
  user "swift"

  hour "*/1"
  minute "5"
  command "/usr/bin/swift-ring-minion-server start -f -o"
end
