# Cookbook Name:: swift-private-cloud
# Recipe:: sysctl
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


directory "/etc/sysctl.d"

# sysctl_multi 'swift-proxy-server' do
#   instructions node["swift-private-cloud"]["proxy"]["sysctl"]
#   only_if { node.run_list.include?("swift-private-cloud::proxy-server") }
# end

if node.recipe?("swift-lite::proxy-server")
  options = node["swift-private-cloud"]["proxy"]["sysctl"]

  sysctl_multi 'swift-proxy-server' do
    instructions options
  end
end

if node.recipe?("swift-private-cloud::storage-server")
  options = node["swift-private-cloud"]["storage"]["sysctl"]

  sysctl_multi 'swift-storage-server' do
    instructions options
  end
end
