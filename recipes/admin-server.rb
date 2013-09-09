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
include_recipe "swift-private-cloud::common"
include_recipe "swift-lite::management-server"
include_recipe "swift-lite::common"
include_recipe "swift-lite::ntp-server"
include_recipe "swift-private-cloud::logging"
include_recipe "swift-private-cloud::mail"

package "dsh" do
  action :install
  options node["swift-private-cloud"]["common"]["pkg_options"]
  only_if { platform_family?("debian") }
end

cron_d "os_drivecheck" do
  user "swiftops"
  command "bash /usr/local/bin/drive_check"
end

cron_d "swift_recon" do
  minute "50"
  hour "23"
  user "root"

  command "/usr/local/bin/swift_recon_wrapper.sh"
end

cron_d "swift_dispersion" do
  minute "50"
  hour "23"
  user "root"
  command "/usr/local/bin/swift_dispersion_report.sh"
end

# /etc/default
template "/etc/default/git-daemon" do
  source "admin/etc/default/git-daemon.erb"
  only_if { platform_family?("debian") }
end

# /etc/exim4

if not node["swift-private-cloud"]["mailing"]["relay_nets"]
  relay_nets = node["swift-private-cloud"]["network"].values.uniq << "127.0.0.0/8"
end

relay_hosts = relay_nets.join(platform_family?("debian") ? ";" :  " : ")

template "/etc/exim4/update-exim4.conf.conf" do
  source "admin/etc/exim4/update-exim4.conf.conf.relay.erb"
  variables(
    :relay_hosts => relay_hosts
  )
  notifies :run, "execute[update-exim-config]", :delayed
  only_if { platform_family?("debian") }
end

template "/etc/exim/exim.conf" do
  source "admin/etc/exim4/exim.conf.erb"
  variables(
    :relay_hosts => relay_hosts
  )
  notifies :restart, "service[#{node['exim']['platform']['service']}]", :delayed
  only_if { platform_family?("rhel") }
end

# /etc/nginx
directory "/etc/nginx/sites-available" do  # install nginx!
  recursive true
end

template "/etc/nginx/sites-available/default" do
  source "admin/etc/nginx/sites-available/default.erb"
end

if not node["swift-private-cloud"]["dispersion"]["dis_key"]
  raise "Must set swift-private-cloud/dispersion/dis_key"
end

# /etc/swift
template "/etc/swift/dispersion.conf" do
  source "admin/etc/swift/dispersion.conf.erb"
  owner "swift"
  group "swift"
  mode "0644"
  variables(
    :ks_auth_url => node["swift-private-cloud"]["keystone"]["keystone_public_url"],
    :ks_dis_tenant => node["swift-private-cloud"]["dispersion"]["dis_tenant"],
    :ks_dis_user => node["swift-private-cloud"]["dispersion"]["dis_user"],
    :ks_dis_key => node["swift-private-cloud"]["dispersion"]["dis_key"],
    :ks_dis_cov => node["swift-private-cloud"]["dispersion"]["dis_coverage"]
  )
end

template "/etc/swift/object-expirer.conf" do
  source "admin/etc/swift/object-expirer.conf.erb"
  owner "swift"
  group "swift"
  mode "0644"
end

# /etc/syslog-ng
# Leaving the old one for now (marcelo)
##template "/etc/syslog-ng/conf.d/swift-ng.conf" do
##  source "admin/etc/syslog-ng/conf.d/swift-ng.conf.erb"
##  notifies :reload, "service[syslog-ng]", :delayed
##end
template "/etc/syslog-ng/syslog-ng.conf" do
  source "admin/etc/syslog-ng/syslog-ng.conf.erb"
  notifies :reload, "service[syslog-ng]", :delayed
end

# git repo
git_basedir = node["swift-private-cloud"]["versioning"]["repository_base"]
ring_repo = node["swift-private-cloud"]["versioning"]["repository_name"]

directory git_basedir do
  mode "0755"
  owner "swiftops"
  group "swiftops"
end

bash "initialize repo" do
  user "root"
  cwd git_basedir
  umask 022
  code "git init --bare #{ring_repo}; chown -R swiftops: #{ring_repo}"
  only_if "test -e #{git_basedir} && test \! -e #{git_basedir}/#{ring_repo} && id swiftops"
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

contrib_files = [
  "drivescout_wrapper.sh", "setup_local_swiftops.sh",
  "setup_remote_swiftops.exp", "udev_drive_rules.sh",
  "ringmaster_setup.sh", "drivescout_setup.sh"]

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
