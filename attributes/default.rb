#
# Cookbook Name:: swift-private-cloud
# Attributes:: default
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

# common
default["swift-private-cloud"]["common"]["ssh_user"] = "swiftops"
default["swift-private-cloud"]["common"]["ssh_key"] = "/tmp/id_rsa_swiftops.priv"
default["swift-private-cloud"]["common"]["swift_generic"] = "swift python-swift python-swiftclient"
default["swift-private-cloud"]["common"]["swift_proxy"] = "swift-proxy python-keystone python-keystoneclient memcached python-memcache"
default["swift-private-cloud"]["common"]["swift_storage"] = "swift-account swift-container swift-object"
default["swift-private-cloud"]["common"]["swift_others"] = "python-suds"
default["swift-private-cloud"]["common"]["apt_options"] = "-y -qq --force-yes -o Dpkg::Options::=--force-confdef"

# swift_common
default["swift-private-cloud"]["swift_common"]["swift_hash"] = "supercrypthash"
default["swift-private-cloud"]["swift_common"]["admin_ip"] = "127.16.0.252"
default["swift-private-cloud"]["swift_common"]["syslog_ip"] = "172.16.0.252"

# proxy
default["swift-private-cloud"]["proxy"]["pipeline"] = "catch_errors healthcheck proxy-logging cache ratelimit authtoken keystoneauth proxy-logging proxy-server"
default["swift-private-cloud"]["proxy"]["memcache_maxmem"] = 512
default["swift-private-cloud"]["proxy"]["sim_connections"] = 1024
default["swift-private-cloud"]["proxy"]["memcache_server_list"] = "127.0.0.1:11211"
default["swift-private-cloud"]["proxy"]["authtoken_factory"] = "keystoneclient.middleware.auth_token:filter_factory"

# mailing
default["swift-private-cloud"]["mailing"]["email_addr"] = "me@mydomain.com"
default["swift-private-cloud"]["mailing"]["pager_addr"] = "mepager@mydomain.com"
default["swift-private-cloud"]["mailing"]["smarthost"] = "172.16.0.252"
default["swift-private-cloud"]["mailing"]["relay_net"] = "172.16.0.0/16"
default["swift-private-cloud"]["mailing"]["outgoing_domain"] = "swift.mydomain.com"

# versioning
default["swift-private-cloud"]["versioning"]["versioning_system"] = "git"
default["swift-private-cloud"]["versioning"]["repository_base"] = "/srv/git"
default["swift-private-cloud"]["versioning"]["repository_name"] = "swift-cluster-configs"

# keystone
default["swift-private-cloud"]["keystone"]["keystone_ip"] = "172.16.0.252"
default["swift-private-cloud"]["keystone"]["keystone_port"] = 35357
default["swift-private-cloud"]["keystone"]["keystone_auth_proto"] = "http"
default["swift-private-cloud"]["keystone"]["keystone_auth_port"] = "5000"
default["swift-private-cloud"]["keystone"]["keystone_admin_tenant"] = "services"
default["swift-private-cloud"]["keystone"]["keystone_admin_user"] = "tokenvalidator"
default["swift-private-cloud"]["keystone"]["keystone_admin_key"] = "noswifthere"

# dispersion
default["swift-private-cloud"]["dispersion"]["dis_tenant"] = "dispersion"
default["swift-private-cloud"]["dispersion"]["dis_user"] = "reporter"
default["swift-private-cloud"]["dispersion"]["dis_key"] = "blahblah"
default["swift-private-cloud"]["dispersion"]["dis_coverage"] = 1
