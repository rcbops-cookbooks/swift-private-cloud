#
# Cookbook Name:: swift-private-cloud
# Recipe:: keystone
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe "swift-private-cloud::attr-remap"
include_recipe "osops-utils"

node.default["mysql"]["services"]["db"]["network"] = "swift-storage"
node.default["mysql"]["services"]["db"]["port"] = 3306
node.default["mysql"]["allow_remote_root"] = true
node.default["mysql"]["root_network_acl"] = "%"

swift_service = {
  "name" => "swift",
  "type" => "object-store",
  "description" => "Swift Object Storage",
  "endpoints" => {
    node["swift-private-cloud"]["keystone"]["region"] => {
      "admin_url" => node["swift-private-cloud"]["keystone"]["swift_admin_url"],
      "internal_url" => node["swift-private-cloud"]["keystone"]["swift_internal_url"],
      "public_url" => node["swift-private-cloud"]["keystone"]["swift_public_url"]
    }
  }
}

if not node["swift-private-cloud"]["keystone"]["admin_password"]
  raise "Must supply swift/keystone/admin_password"
end

auth_user = node["swift-private-cloud"]["keystone"]["auth_user"]
auth_tenant = node["swift-private-cloud"]["keystone"]["auth_tenant"]
admin_user = node["swift-private-cloud"]["keystone"]["admin_user"]
dis_user = node["swift-private-cloud"]["dispersion"]["dis_user"]
dis_tenant = node["swift-private-cloud"]["dispersion"]["dis_tenant"]

# these should be generated by secret if not specified.
admin_password = node["swift-private-cloud"]["keystone"]["admin_password"]
auth_password = node["swift-private-cloud"]["keystone"]["auth_password"]
dis_password = node["swift-private-cloud"]["dispersion"]["dis_key"]

node.default["keystone"]["published_services"] = [swift_service]

node.default["keystone"]["tenants"] = ["admin", auth_tenant, dis_tenant, "swiftops"].uniq
node.default["keystone"]["users"] = {
  dis_user => {
    "password" => dis_password,
    "default_tenant" => dis_tenant,
    "roles" => {
      "admin" => [dis_tenant]
    }
  },
  auth_user => {
    "password" => auth_password,
    "default_tenant" => auth_tenant,
    "roles" => {
      "admin" => [auth_tenant]
    }
  },
  admin_user => {
    "password" => admin_password,
    "default_tenant" => "admin",
    "roles" => {
      "admin" => ["admin"],
      "KeystoneAdmin" => ["admin"],
      "KeystoneServiceAdmin" => ["admin"]
    },
  },
  "monitoring" => {
    "password" => "",
    "default_tenant" => auth_tenant,
    "roles" => {
      "Member" => ["admin"]
    }
  },
  "swiftops" => {
    "password" => "swiftopsme",
    "default_tenant" => "swiftops",
    "roles" => {
       "admin" => ["swiftops"]
    }
  }  
}

node.default["osops_networks"]["nova"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["management"] = node["swift-private-cloud"]["network"]["management"]
node.default["osops_networks"]["public"] = node["swift-private-cloud"]["network"]["exnet"]

node.default["keystone"]["setup_role"] = "spc-starter-controller"
node.default["keystone"]["mysql_role"] = "spc-starter-controller"
node.default["keystone"]["api_role"] = "spc-starter-controller"

Chef::Log.error node["keystone"]["users"]


include_recipe "mysql-openstack::server"
include_recipe "keystone::setup"
include_recipe "keystone::keystone-api"
