#
# Cookbook Name:: swift-private-cloud
# Recipe:: timezone
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

package "tzdata"

timezone = "UTC"

services_to_restart = value_for_platform_family(
  "rhel" => ["crond"],
  "debian" => ["cron"],
  "default" => []
)

services_to_restart.each do |name|
  service "tzdata-#{name}-restart" do
    action :nothing
    service_name name
  end
end

execute "tzdata-update" do
  action :nothing
  command value_for_platform_family(
    "rhel" => "tzdata-update",
    "debian" => "dpkg-reconfigure -fnoninteractive tzdata"
  )

  services_to_restart.each do |name|
    notifies :restart, "service[tzdata-#{name}-restart]", :delayed
  end
end

if node.platform_family?("rhel")
  ruby_block "edit-sysconfig-zone" do
    block do
      file = Chef::Util::FileEdit.new("/etc/sysconfig/clock")
      file.search_file_replace_line(/\AZONE/, "ZONE=\"#{timezone}\"")
      file.write_file
    end

    not_if "grep \"#{timezone}\" /etc/sysconfig/clock"

    notifies :run, "execute[tzdata-update]", :immediately
  end
elsif node.platform_family?("debian")
  execute "edit-localtime" do
    command "ln -sf /usr/share/zoneinfo/#{timezone} /etc/localtime"
    not_if "grep \"#{timezone}\" /etc/localtime"

    notifies :run, "execute[tzdata-update]", :immediately
  end
end
