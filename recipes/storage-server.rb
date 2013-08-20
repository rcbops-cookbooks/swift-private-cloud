#
# Cookbook Name:: swift-private-cloud
# Recipe:: storage-server
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
include_recipe "swift-private-cloud::account-server"
include_recipe "swift-private-cloud::container-server"
include_recipe "swift-private-cloud::object-server"

# /etc/rsync.conf
resources("template[/etc/rsyncd.conf]").cookbook "swift-private-cloud"
resources("template[/etc/rsyncd.conf]").source "storage/etc/rsyncd.conf.erb"

%w(xfsprogs parted).each do |pkg|
  package pkg
end

template "/etc/cron.d/storage_drivecheck" do
  source "storage/etc/cron.d/storage_drivecheck.erb"
  notifies :reload, "service[swift-storage-cron]", :delayed
end

template "/etc/cron.d/swift-device-audit" do
  source "storage/etc/cron.d/swift-device-audit.erb"
  notifies :reload, "service[swift-storage-cron]", :delayed
end

template "/etc/cron.d/swift-recon-cron" do
  source "storage/etc/cron.d/swift-recon-cron.erb"
  notifies :reload, "service[swift-storage-cron]", :delayed
end

# python slogging no longer used
#template "/etc/cron.d/swift-slogging" do
#  source "storage/etc/cron.d/swift-slogging.erb"
#  notifies :reload, "service[swift-storage-cron]", :delayed
#end

template "/etc/cron.d/xfs-corruption-check" do
  source "storage/etc/cron.d/xfs-corruption-check.erb"
  notifies :reload, "service[swift-storage-cron]", :delayed
end

# /etc/default
template "/etc/default/memcached" do
  source "storage/etc/default/memcached.erb"
  only_if { platform_family?("debian") }
end

template "/etc/default/rsync" do
  source "storage/etc/default/rsync.erb"
  only_if { platform_family?("debian") }
end

# /etc/logrotate.d
template "/etc/logrotate.d/rsync" do
  source "storage/etc/logrotate.d/rsync.erb"
end

# /etc/sysctl.d
# template "/etc/sysctl.d/31-swift-storage.conf" do
#   source "storage/etc/sysctl.d/31-swift-storage.conf.erb"
# end

# /etc/udev/rules.d
template "/etc/udev/rules.d/10_swift.rules" do
  source "storage/etc/udev/rules.d/10_swift.rules.erb"
  mode "0644"
  owner "root"
  group "root"
end

# /usr/local/bin
template "/usr/local/bin/drive_mount_check.py" do
  source "storage/usr/local/bin/drive_mount_check.py.erb"
  user node["swift"]["dsh"]["admin_user"]["name"]
  mode "0500"
  variables(
    :email_addr => node["swift-private-cloud"]["mailing"]["email_addr"],
    :outdomain => node["swift-private-cloud"]["mailing"]["outgoing_domain"]
  )
end

template "/usr/local/bin/set_irq_affinity.sh" do
  source "storage/usr/local/bin/set_irq_affinity.sh.erb"
  user "root"
  mode "0500"
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

cookbook_file "/usr/local/bin/ringminion_setup.sh" do
  source "storage/usr/local/bin/ringminion_setup.sh"
  user "root"
  mode "0755"
end

cookbook_file "/usr/local/bin/swift-format.sh" do
  source "storage/usr/local/bin/swift-format.sh"
  user "root"
  mode "0755"
end

cookbook_file "/usr/local/bin/swift-mount.sh" do
  source "storage/usr/local/bin/swift-mount.sh"
  user "root"
  mode "0755"
end

cookbook_file "/usr/local/bin/swift-partition.sh" do
  source "storage/usr/local/bin/swift-partition.sh"
  user "root"
  mode "0755"
end

cookbook_file "/usr/local/bin/swift-udev-mount.sh" do
  source "storage/usr/local/bin/swift-udev-mount.sh"
  user "root"
  mode "0755"
end

template "/usr/local/bin/xfs_corruption_check.sh" do
  source "storage/usr/local/bin/xfs_corruption_check.sh.erb"
  user "root"
  mode "0500"
end
