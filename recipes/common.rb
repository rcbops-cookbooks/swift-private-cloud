#
# Cookbook Name:: swift-private-cloud
# Recipe:: common
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

include_recipe "swift-lite::ntp"
include_recipe "swift-lite::sysctl"

# /etc/cron.d
service "swift-storage-cron" do
  service_name "crond"
  action :nothing
end

# /etc/apt
template "/etc/apt/preferences" do
  source "common/etc/apt/preferences.erb"
  only_if { platform_family?("debian") }
end

template "/etc/apt/sources.list.d/linux.dell.com.sources.list" do
  source "common/etc/apt/sources.list.d/linux.dell.com.sources.list.erb"
  only_if { platform_family?("debian") }
end

template "/etc/apt/sources.list.d/megaraid.list" do
  source "common/etc/apt/sources.list.d/megaraid.list.erb"
  only_if { platform_family?("debian") }
end

template "/etc/apt/sources.list.d/openstack_swift.list" do
  source "common/etc/apt/sources.list.d/openstack_swift.list.erb"
  only_if { platform_family?("debian") }
end

# /etc/cron.d
service "swift-common-cron" do
  service_name "crond"
  action :nothing
end

template "/etc/cron.d/swift_ring_check" do
  source "common/etc/cron.d/swift_ring_check.erb"
  notifies :reload, "service[swift-common-cron]", :delayed
end

# /etc/default
template "/etc/default/irqbalance" do
  source "common/etc/default/irqbalance.erb"
  only_if { platform_family?("debian") }
end

template "/etc/default/megaclisas-statusd" do
  source "common/etc/default/megaclisas-statusd.erb"
  only_if { platform_family?("debian") }
end

# /etc/exim4
directory "/etc/exim4" # install exim!

template "/etc/exim4/update-exim4.conf.conf" do
  source "common/etc/exim4/update-exim4.conf.conf.erb"
  variables(
    :outdomain => node["swift-private-cloud"]["mailing"]["outgoing_domain"],
    :smarthost => node["swift-private-cloud"]["mailing"]["smarthost"]
  )
end

# /etc/logrotate.d
template "/etc/logrotate.d/swift" do
  source "common/etc/logrotate.d/swift.erb"
end

# /etc/snmp
directory "/etc/snmp" # install snmp!

template "/etc/snmp/snmp.conf" do
  source "common/etc/snmp/snmp.conf.erb"
end

template "/etc/snmp/snmpd.conf" do
  source "common/etc/snmp/snmpd.conf.erb"
end

# /etc/swift
template "/etc/swift/internal-proxy-server.conf" do
  source "common/etc/swift/internal-proxy-server.conf.erb"
  owner "swift"
  group "swift"
end

template "/etc/swift/log-processor.conf" do
  source "common/etc/swift/log-processor.conf.erb"
  owner "swift"
  group "swift"
  variables(
    :processing_account => "swift"
  )
end

template "/etc/swift/mime.types" do
  source "common/etc/swift/mime.types.erb"
  owner "swift"
  group "swift"
end

# /etc/syslog-ng
directory "/etc/syslog-ng/conf.d" do
  recursive true
end

template "/etc/syslog-ng/conf.d/swift-ng.conf" do
  source "common/etc/syslog-ng/conf.d/swift-ng.conf.erb"
  variables(
    :remote_syslog_ip => node["swift-private-cloud"]["swift_common"]["syslog_ip"]
  )
end

# /etc
template "/etc/aliases" do
  source "common/etc/aliases.erb"
  variables(
    :email_addr => node["swift-private-cloud"]["mailing"]["email_addr"],
    :pager_addr => node["swift-private-cloud"]["mailing"]["pager_addr"]
  )
end

resources("template[/etc/ntp.conf]") do
  cookbook "swift-private-cloud"
  source "common/etc/ntp.conf"
end

template "/etc/rc.local" do
  source "common/etc/rc.local.erb"
end

# /usr/local/bin
template "/usr/local/bin/retrievering.sh" do
  source "common/usr/local/bin/retrievering.sh.erb"
  user "root"
  mode "0500"
end

template "/usr/local/bin/ringverify.sh" do
  source "common/usr/local/bin/ringverify.sh.erb"
  user "root"
  mode "0500"
end
