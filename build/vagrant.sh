#!/usr/bin/env bash

echo "-----------------------------------------------------------------------------"
echo "Installing Vagrant Plugins"
echo "-----------------------------------------------------------------------------"
#if [[ $(vagrant plugin list) != *vagrant-berkshelf* ]]; then
  #vagrant plugin install vagrant-berkshelf || exit 1
#else
  #echo "Skipping: vagrant-berkshelf already installed"
#fi

if [[ $(vagrant plugin list) != *vagrant-omnibus* ]]; then
  vagrant plugin install vagrant-omnibus || exit 1
else
  echo "Skipping: vagrant-omnibus already installed"
fi
echo

echo "-----------------------------------------------------------------------------"
echo "Bringing up Chef Server Instance"
echo "-----------------------------------------------------------------------------"
if [[ $(vagrant status chef_server) != *running* ]]; then
  vagrant up chef_server --no-provision || exit 1
else
  echo "Skipping: Chef Server already running"
fi
echo

echo "-----------------------------------------------------------------------------"
echo "Installing Omnibus Chef Server"
echo "-----------------------------------------------------------------------------"
if [[ $(vagrant ssh chef_server -c "which chef-server-ctl") != *chef-server-ctl* ]]; then
  berks install -p ./cookbooks -o chef_server || exit 1
  vagrant provision chef_server --provision-with chef_solo || exit 1
else
  echo "Skipping: Chef Server already installed"
fi
echo

echo "-----------------------------------------------------------------------------"
echo "Copying Credentials to Share"
echo "-----------------------------------------------------------------------------"
vagrant ssh chef_server -c "sudo cp -v /etc/chef-server/chef-validator.pem /vagrant/.chef" || exit 1
echo

echo "-----------------------------------------------------------------------------"
echo "Uploading Environments"
echo "-----------------------------------------------------------------------------"
vagrant ssh chef_server -c "sudo knife environment from file /vagrant/environments/* -c /vagrant/.chef/knife.rb" || exit 1
echo

echo "-----------------------------------------------------------------------------"
echo "Updating Cookbooks"
echo "-----------------------------------------------------------------------------"
rm -rf ./cookbooks || exit 1
berks install -p ./cookbooks || exit 1
echo

echo "-----------------------------------------------------------------------------"
echo "Uploading Cookbooks"
echo "-----------------------------------------------------------------------------"
vagrant ssh chef_server -c "sudo knife cookbook upload --all -c /vagrant/.chef/knife.rb" || exit 1
echo

echo "-----------------------------------------------------------------------------"
echo "Uploading Roles"
echo "-----------------------------------------------------------------------------"
vagrant ssh chef_server -c "sudo knife role from file /vagrant/roles/* -c /vagrant/.chef/knife.rb" || exit 1
echo
