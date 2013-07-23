#
# Cookbook Name:: swift-private-cloud
# Recipe:: attr-remap
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

Chef::Log.warn(node["osops_networks"])


# swift-lite will set the /etc/swift/swift.conf
node.default["swift"]["hash_path_suffix"] = node["swift-private-cloud"]["swift_common"]["swfit_hash_suffix"]
node.default["swift"]["hash_path_prefix"] = node["swift-private-cloud"]["swift_common"]["swfit_hash_prefix"]

# make exnet and public map to the right underlying networks
node.default["osops_networks"] ||= {}
node.default["osops_networks"]["swift-storage"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["swift-replication"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["swift-management"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["swift-proxy"] = node["swift-private-cloud"]["network"]["management"]

# set up the right memcache bind
node.default["memcached"] ||= {}
node.default["memcached"]["services"] ||= {}
node.default["memcached"]["services"]["cache"] ||= {}
node.default["memcached"]["services"]["cache"]["network"] = "swift-storage"

Chef::Log.warn(node["osops_networks"])
