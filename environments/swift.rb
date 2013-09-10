name "swift"
description "The swift environment"
override_attributes(
  "vips" => {
    "swift-proxy" => "http://192.168.122.138:8080"
  },
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },
  "nova" => {
  },
  "swift" => {
    "swift_hash" => "-74b-Wq802mNM_h-_5-tr8A-"
  },
  "swift-private-cloud" => {
    "keystone" => {
      "ops_password"=> "secrete"
    },
    "network" => {
      "management" => "192.168.122.0/24"
    },
    "swift_common" => {
      "swift_hash_prefix" => "staticprefix",
      "swift_hash_suffix" => ""
    }
  },
  # this is for keystone and non swift tightly coupled cookbooks
  "osops_networks" => {
    "nova" => "192.168.122.0/24",
    "management" => "192.168.122.0/24",
    "public" => "192.168.122.0/24"
  }
)
