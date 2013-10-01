# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

metadata

cookbook "swift-lite", git: "git://github.com/rcbops-cookbooks/swift-lite", branch: "master"
cookbook "mysql-openstack", git: "git://github.com/rcbops-cookbooks/mysql-openstack", branch: "master"
cookbook "dsh", git: "git://github.com/rcbops-cookbooks/dsh", branch: "master"
cookbook "osops-utils", git: "git://github.com/rcbops-cookbooks/osops-utils", branch: "master"
cookbook "sysctl", git: "git://github.com/rcbops-cookbooks/sysctl", branch: "master"
cookbook "memcached-openstack", git: "git://github.com/rcbops-cookbooks/memcached-openstack", branch: "master"
cookbook "keystone", git: "git://github.com/rcbops-cookbooks/keystone", branch: "master"
cookbook "keepalived", git: "git://github.com/rcbops-cookbooks/keepalived", branch: "master"
cookbook "memcached", "1.4.0"
cookbook "ntp", git: "git://github.com/opscode-cookbooks/ntp", branch: "master"

group :chef_server do
  cookbook "chef-server"
  cookbook "chef-client"
  cookbook "iptables"
end
