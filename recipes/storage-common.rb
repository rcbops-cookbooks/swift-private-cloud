#
# Cookbook Name:: swift-private-cloud
# Recipe:: storage-common
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

include_recipe "swift-lite::storage-common"

# /etc/rsync.conf
resources("template[/etc/rsyncd.conf]").instance_exec do
  cookbook "swift-private-cloud"
  source "storage/etc/rsyncd.conf.erb"
  variables(
    :account_connections =>
      node["swift-private-cloud"]["rsync"]["config"]["account"]["max connections"],
    :container_connections =>
      node["swift-private-cloud"]["rsync"]["config"]["container"]["max connections"],
    :object_connections =>
      node["swift-private-cloud"]["rsync"]["config"]["object"]["max connections"]
  )
end

# /etc/swift/drive-audit.conf
resources("template[/etc/swift/drive-audit.conf]").cookbook "swift-private-cloud"
resources("template[/etc/swift/drive-audit.conf]").variables(
  "minutes" => node["swift-private-cloud"]["drive_audit"]["minutes"],
  "log_file_pattern" => node["swift-private-cloud"]["drive_audit"]["log_file_pattern"],
  "regex_patterns" => node["swift-private-cloud"]["drive_audit"]["regex_patterns"]
)


%w(xfsprogs parted).each do |pkg|
  package pkg
end

cron_d "storage-drivecheck" do
  user "swift"
  minute "1"
  hour "*/2"
  command "/usr/local/bin/drive_mount_check.py"
end

cron_d "swift-device-audit" do
  user "root"
  command "/usr/local/bin/swift-drive-audit-nextgen /etc/swift/drive-audit.conf 2>&1 | logger"
end

cron_d "swift-recon-cron" do
  user "swift"
  minute "*/10"
  command "/usr/bin/swift-recon-cron /etc/swift/object-server.conf"
end

cron_d "xfs-corruption-check" do
  user "root"
  minute "*/5"
  command "/usr/local/bin/xfs_corruption_check.sh"
end

# /etc/default
template "/etc/default/rsync" do
  source "storage/etc/default/rsync.erb"
  only_if { platform_family?("debian") }
end

# /etc/logrotate.d
template "/etc/logrotate.d/rsync" do
  source "storage/etc/logrotate.d/rsync.erb"
  variables(
    :postrotate_command => platform_family?("debian") ?
      "/usr/sbin/invoke-rc.d rsync reload > /dev/null" :
      "/sbin/service rsyncd restart > /dev/null")
end

# /usr/local/bin
template "/usr/local/bin/drive_mount_check.py" do
  source "storage/usr/local/bin/drive_mount_check.py.erb"
  user "root"
  mode "0755"
  variables(
    :email_addr => node["swift-private-cloud"]["mailing"]["email_addr"],
    :outdomain => node["swift-private-cloud"]["mailing"]["outgoing_domain"]
  )
end

template "/usr/local/bin/swift-drive-audit-nextgen" do
  source "storage/usr/local/bin/swift-drive-audit-nextgen.erb"
  user "root"
  mode "0500"
end

cookbook_file "/usr/local/bin/uname26" do
  source "storage/usr/local/bin/uname26"
  user "root"
  mode "0500"
end

cookbook_file "/usr/local/bin/setup_drives.sh" do
  source "storage/usr/local/bin/setup_drives.sh"
  user "root"
  mode "0755"
end

cookbook_file "/usr/local/bin/swift-format.sh" do
  source "storage/usr/local/bin/swift-format.sh"
  user "root"
  mode "0755"
end

cookbook_file "/usr/local/bin/swift-partition.sh" do
  source "storage/usr/local/bin/swift-partition.sh"
  user "root"
  mode "0755"
end

template "/usr/local/bin/xfs_corruption_check.sh" do
  source "storage/usr/local/bin/xfs_corruption_check.sh.erb"
  user "root"
  mode "0500"
end
