# -*- mode: ruby -*-
# vi: set ft=ruby :
# encoding: utf-8

source "https://rubygems.org"

ruby "1.9.3"

gem "bundler"
gem "berkshelf", ">= 2.0.9"

group :test do
  gem "chef",              "~> 11.6.0"
  gem "foodcritic",        "~> 2.2.0"
  gem "tailor",            "~> 1.2.1"
  gem "thor-foodcritic",   "~> 0.2.0"
  gem "kitchen-vagrant",   "~> 0.9.0"
  gem "kitchen-rackspace", "~> 0.2.0"

  # Move to 1.0 version after release.
  gem "test-kitchen", :git => "git://github.com/opscode/test-kitchen.git", :branch => "master"
end
