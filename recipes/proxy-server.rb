#
# Cookbook Name:: swift-private-cloud
# Recipe:: proxy-server
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

include_recipe "swift-private-cloud::common"
include_recipe "swift-lite::proxy-server"

resources("template[/etc/swift/proxy-server.conf]").cookbook "swift-private-cloud"

# /etc/cron.d
service "swift-proxy-cron" do
  service_name "crond"
  action :nothing
end

template "/etc/cron.d/memcache-restart" do
  source "proxy/etc/cron.d/memcache-restart.erb"
  notifies :reload, "service[swift-proxy-cron]", :delayed
end

template "/etc/cron.d/swift-access-log-uploader" do
  source "proxy/etc/cron.d/swift-access-log-uploader.erb"
  notifies :reload, "service[swift-proxy-cron]", :delayed
end

# /etc/default
template "/etc/default/memcached" do
  source "proxy/etc/default/memcached.erb"
  only_if { platform_family?("debian") }
end

# /etc/init.d
template "/etc/init.d/memcached.swift" do
  source "proxy/etc/init.d/memcached.swift.erb"
end

# /etc/sysctl.d
template "/etc/sysctl.d/30-swift-proxy.conf" do
  source "proxy/etc/sysctl.d/30-swift-proxy.conf.erb"
end

# /etc/memcached.conf
template "/etc/memcached.conf" do
  source "proxy/etc/memcached.conf.erb"
  owner "root"
  group "root"
  mode 0064
  variables(
    :maxmem => node["swift-private-cloud"]["proxy"]["memcache_maxmem"],
    :simconn => node["swift-private-cloud"]["proxy"]["sim_connections"]
  )
  notifies :restart, "service[memcached]"
end

# /usr/local/bin
template "/usr/local/bin/check_memcache.py" do
  source "proxy/usr/local/bin/check_memcache.py.erb"
  user "root"
  mode "0500"
end

template "/usr/local/bin/check_memcache_wrapper.sh" do
  source "proxy/usr/local/bin/check_memcache_wrapper.sh.erb"
  user "root"
  mode "0500"
end

template "/usr/local/bin/memcache_info.py" do
  source "proxy/usr/local/bin/memcache_info.py.erb"
  user "root"
  mode "0500"
end

template "/usr/local/bin/set_irq_affinity.sh" do
  source "proxy/usr/local/bin/set_irq_affinity.sh.erb"
  user "root"
  mode "0500"
end
