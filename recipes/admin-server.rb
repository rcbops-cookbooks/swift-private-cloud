#
# Cookbook Name:: swift-private-cloud
# Recipe:: admin-server
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

include_recipe "swift-private-cloud::attr-remap"
include_recipe "swift-private-cloud::packages"
include_recipe "swift-lite::management-server"
include_recipe "swift-lite::ntp-server"
include_recipe "swift-private-cloud::logging"
include_recipe "git::server"

# /etc/cron.d
service "swift-admin-cron" do
  service_name "crond"
  action :nothing
end

template "/etc/cron.d/os_drivechece" do
  source "admin/etc/cron.d/os_drivecheck.erb"
  notifies :reload, "service[swift-admin-cron]", :delayed
end

template "/etc/cron.d/swift_reports" do
  source "admin/etc/cron.d/swift_reports.erb"
  notifies :reload, "service[swift-admin-cron]", :delayed
end

# /etc/default
template "/etc/default/git-daemon" do
  source "admin/etc/default/git-daemon.erb"
  only_if { platform_family?("debian") }
end

# /etc/exim4
directory "/etc/exim4" # install exim!

template "/etc/exim4/update-exim4.conf.relay" do
  source "admin/etc/exim4/update-exim4.conf.conf.relay.erb"
end

# /etc/nginx
directory "/etc/nginx/sites-available" do  # install nginx!
  recursive true
end

template "/etc/nginx/sites-available/default" do
  source "admin/etc/nginx/sites-available/default.erb"
end


# /etc/swift
template "/etc/swift/dispersion.conf" do
  source "admin/etc/swift/dispersion.conf.erb"
  owner "swift"
  group "swift"
end

template "/etc/swift/object-expirer.conf" do
  source "admin/etc/swift/object-expirer.conf.erb"
  owner "swift"
  group "swift"
end

# /etc/syslog-ng
template "/etc/syslog-ng/conf.d/swift-ng.conf" do
  source "admin/etc/syslog-ng/conf.d/swift-ng.conf.erb"
  notifies :reload, "service[syslog-ng]", :delayed
end

# /etc/udev/rules.d
template "/etc/udev/rules.d/10_swift.rules" do
  source "storage/etc/udev/rules.d/10_swift.rules.erb"
  only_if { platform_family?("debian") }
end

# /srv/ring/scripts
directory "srv/ring/scripts" do
  recursive true
end

template "/srv/ring/scripts/README" do
  source "admin/srv/ring/scripts/README"
end

template "/srv/ring/scripts/rebalance_ring.sh" do
  source "admin/srv/ring/scripts/rebalance_ring.sh.erb"
  mode "0500"
end

template "/srv/ring/scripts/retrievering.sh" do
  source "admin/srv/ring/scripts/retrievering.sh.erb"
  mode "0500"
end

template "/srv/ring/scripts/ring_add.sh" do
  source "admin/srv/ring/scripts/ring_add.sh.erb"
  mode "0500"
end

template "/srv/ring/scripts/updatemd5.sh" do
  source "admin/srv/ring/scripts/updatemd5.sh.erb"
  mode "0500"
end

template "/srv/ring/scripts/vm_ring_add.sh" do
  source "admin/srv/ring/scripts/vm_ring_add.sh.erb"
  mode "0500"
end

# /usr/local/bin
template "/usr/local/bin/swift_dispersion_report.sh" do
  source "admin/usr/local/bin/swift_dispersion_report.sh.erb"
  user "root"
  mode "0500"
end

template "/usr/local/bin/swift_recon_wrapper.sh" do
  source "admin/usr/local/bin/swift_recon_wrapper.sh.erb"
  user "root"
  mode "0500"
end

contrib_files = ["drivescout_wrapper.sh", "setup_drives.sh",
                 "setup_local_swiftops.sh", "setup_remote_swiftops.exp",
                 "udev_drive_rules.sh"]

contrib_files.each do |file|
  cookbook_file "/usr/local/bin/#{file}" do
    source "admin/usr/local/bin/#{file}"
    user "root"
    mode "0755"
  end
end

# /var/www/nginx-default
directory "/var/www/nginx-default/deploy/bonnie" do
  recursive true
end

template "/var/www/nginx-default/deploy/bonnie/bonnietest.sh" do
  source "admin/var/www/nginx-default/deploy/bonnie/bonnietest.sh.erb"
  mode "0500"
end

directory "/var/www/nginx-default/deploy/swift" do
  recursive true
end

template "/var/www/nginx-default/deploy/swift/set_swift_hold.sh" do
  source "admin/var/www/nginx-default/deploy/swift/set_swift_hold.sh.erb"
  mode "0500"
end

template "/var/www/nginx-default/deploy/swift/set_swift_to_install.sh" do
  source "admin/var/www/nginx-default/deploy/swift/set_swift_to_install.sh.erb"
  mode "0500"
end

directory "/var/www/nginx-default/swift_info" do
  recursive true
end

template "/var/www/nginx-default/swift_info/placholder.txt" do
  source "admin/var/www/nginx-default/swift_info/placholder.txt.erb"
end
