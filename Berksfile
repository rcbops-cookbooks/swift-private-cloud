# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

metadata

cookbook "swift-lite", git: "git://github.com/rcbops-cookbooks/swift-lite", branch: "v4.1.3rc"
cookbook "mysql-openstack", git: "git://github.com/rcbops-cookbooks/mysql-openstack", branch: "v4.1.3rc"
cookbook "dsh", git: "git://github.com/rcbops-cookbooks/dsh", branch: "v4.1.3rc"
cookbook "osops-utils", git: "git://github.com/rcbops-cookbooks/osops-utils", branch: "v4.1.3rc"
cookbook "sysctl", git: "git://github.com/rcbops-cookbooks/sysctl", branch: "v4.1.3rc"
cookbook "memcached-openstack", git: "git://github.com/rcbops-cookbooks/memcached-openstack", branch: "v4.1.3rc"
cookbook "keystone", git: "git://github.com/rcbops-cookbooks/keystone", branch: "v4.1.3rc"
cookbook "keepalived", git: "git://github.com/rcbops-cookbooks/keepalived", branch: "v4.1.3rc"
cookbook "memcached", "1.4.0"
cookbook "mysql", git: "git://github.com/opscode-cookbooks/mysql", branch: "6ec4bda007c8d82e698dfa8112a2343ce333801e"
cookbook "ntp", git: "git://github.com/opscode-cookbooks/ntp", branch: "master"

# Lock down intermediate deps
cookbook "runit", "1.2.0"
cookbook "build-essential", "1.4.2"
cookbook "yum", "2.3.4"
cookbook "git", "2.6.0"
cookbook "dmg", "2.0.0"
cookbook "windows", "1.10.0"
cookbook "chef_handler", "1.1.4"
cookbook "cron", "1.2.6"
cookbook "openssl", "1.1.0"
cookbook "database", "1.4.0"
cookbook "postgresql", "3.1.0"
cookbook "apt", "2.1.1"
cookbook "aws", "0.101.4"
cookbook "xfs", "1.1.0"
cookbook "apache2", "1.7.0"

group :chef_server do
  cookbook "chef-server", "2.0.0"
  cookbook "chef-client", "3.0.4"
  cookbook "iptables", "0.12.0"
end
