name              "swift-private-cloud"
maintainer        "Rackspace US, Inc."
license           "Apache 2.0"
description       "Install and configure Openstack Swift for Private Cloud"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"
recipe            "swift-private-cloud::common", "Installs the swift servers common bits"
recipe            "swift-private-cloud::account-server", "Installs the swift account server"
recipe            "swift-private-cloud::object-server", "Installs the swift object server"
recipe            "swift-private-cloud::container-server", "Installs the swift container server"
recipe            "swift-private-cloud::storage-server", "Installs the swift account, object, container servers, ntp, and sysctl"
recipe            "swift-private-cloud::proxy-server", "Installs the swift proxy server, ntp, and sysctl"

%w{ centos ubuntu }.each do |os|
  supports os
end

%w{ swift-lite }.each do |dep|
  depends dep
end
