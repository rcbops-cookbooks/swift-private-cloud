name              "swift-private-cloud"
maintainer        "Rackspace US, Inc."
license           "Apache 2.0"
description       "Install and configure Openstack Swift for Private Cloud"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "4.1.4"
recipe            "swift-private-cloud::common", "Installs the swift servers common bits"
recipe            "swift-private-cloud::account-server", "Installs the swift account server"
recipe            "swift-private-cloud::object-server", "Installs the swift object server"
recipe            "swift-private-cloud::container-server", "Installs the swift container server"
recipe            "swift-private-cloud::storage-server", "Installs the swift account, object, container servers"
recipe            "swift-private-cloud::proxy-server", "Installs the swift proxy server, ntp, and sysctl"
recipe            "swift-private-cloud::admin-server", "Installs the swift admin server bits"
recipe            "swift-private-cloud::freeze", "Freeze/Hold packages, etc after deployment"
recipe            "swift-private-cloud::unfreeze", "Unfreeze/unhold packages, etc before an upgrade"

%w{ centos ubuntu }.each do |os|
  supports os
end

%w{ swift-lite osops-utils runit git mysql-openstack keystone cron }.each do |dep|
  depends dep
end
