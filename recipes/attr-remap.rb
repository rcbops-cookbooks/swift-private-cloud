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


# pull the management host, for lookups later
nodelist = get_nodes_by_recipe("swift-private-cloud::admin-server")
admin_node = nil
if nodelist.length > 0
  admin_node = nodelist[0]
end


# swift-lite will set the /etc/swift/swift.conf
node.default["swift"]["swift_hash_suffix"] = node["swift-private-cloud"]["swift_common"]["swift_hash_suffix"]
node.default["swift"]["swift_hash_prefix"] = node["swift-private-cloud"]["swift_common"]["swift_hash_prefix"]

# make exnet and public map to the right underlying networks
node.default["osops_networks"]["swift-storage"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["swift-replication"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["swift-management"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["swift-proxy"] = node["swift-private-cloud"]["network"]["management"]

# pass through the proxy args
node.default["swift"]["proxy"]["pipeline"] = node["swift-private-cloud"]["proxy"]["pipeline"]

# set up the right memcache bind
node.default["memcached"]["services"]["cache"]["network"] = "swift-storage"
node.default["swift"]["memcache_role"] = "spc-starter-proxy"
node.default["swift"]["ntp"]["role"] = "spc-starter-controller"

# set the git repo location where the git cookbook expects it
node.default["git"]["server"]["base_path"] = node["swift-private-cloud"]["versioning"]["repository_base"]

# point remote syslog to admin machine if not overridden/specified
#
# FIXME: this is pretty questionable... we need to fix up the osops-utils
# stuff to work righter by recipe
#
if not node["swift-private-cloud"]["swift_common"]["syslog_ip"]
  if not admin_node
    raise "Must specify swift-private-cloud/swift_common/syslog_ip"
  end

  node.default["swift-private-cloud"]["swift_common"]["syslog_ip"] = get_ip_for_net("swift-management", admin_node)
end

# keystone setup.  This will only do anything interesting if the keystone
# recipe is applied.

node.default["keystone"]["pki"]["enabled"] = node["swift-private-cloud"]["keystone"]["pki"]

if not node["swift-private-cloud"]["keystone"]["keystone_admin_url"]
  if not admin_node
    raise "Must specify keystone endpoints"
  end

  my_keystone_ip = get_ip_for_net("swift-management", admin_node)

  node.default["swift-private-cloud"]["keystone"]["keystone_admin_url"] = "http://#{my_keystone_ip}:35357/v2.0"
  node.default["swift-private-cloud"]["keystone"]["keystone_internal_url"] = "http://#{my_keystone_ip}:5000/v2.0"
  node.default["swift-private-cloud"]["keystone"]["keystone_public_url"] = "http://#{my_keystone_ip}:5000/v2.0"
end

if not node["swift-private-cloud"]["keystone"]["auth_password"]
  raise "Must supply swift/keystone/auth_password"
end

node.default["swift"]["keystone_endpoint"] = node["swift-private-cloud"]["keystone"]["keystone_public_url"]

node.default["swift"]["service_user"] = node["swift-private-cloud"]["keystone"]["auth_user"]
node.default["swift"]["service_pass"] = node["swift-private-cloud"]["keystone"]["auth_password"]
node.default["swift"]["service_tenant_name"] = node["swift-private-cloud"]["keystone"]["auth_tenant"]

# set up the git host ip - pull the ip from the management box
if not node["swift-private-cloud"]["versioning"]["repository_host"]
  if not admin_node
    raise "Must specify swift-private-cloud/versioning/repository_host"
  end

  node.default["swift-private-cloud"]["versioning"]["repository_host"] = get_ip_for_net("swift-management", admin_node)
end
