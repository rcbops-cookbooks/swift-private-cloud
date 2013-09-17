name "swift"
description "The swift environment"
override_attributes(
  "vips" => {
    # We currently do not set up a loadbalanced vip--it is assumed that the customer will configure this if he has multiple proxies.
    "swift-proxy" => "http://192.168.122.138:8080"
  },

  # this block is only necessary if you are using the cookbooks to install keystone (rather than using an existing keystone)
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  },

  # this block is only necessary if you are using the cookbooks to install keystone (rather than using an existing keystone)
  "nova" => {
  },

  "swift" => {
    # this should be changed to something relatively random and of about the same length
    "swift_hash" => "-74b-Wq802mNM_h-_5-tr8A-"
  },

  "swift-private-cloud" => {
    "keystone" => {
      # "ops_user" => "swiftops" (default)
      "ops_password"=> "secrete",
      "auth_password"=> "secrete",
      "swift_admin_url"=> "", # should be set to the endpoint you desire
      "swift_internal_url"=> "", # should be set to the endpoint you desire
      "swift_public_url"=> "" # should be set to the endpoint you desire

      # if using an existing keystone, define the following=>
      # "keystone_admin_url"=> "http://ip:port/v2.0"
      # "keystone_internal_url"=> "http://ip:port/v2.0"
      # "keystone_public_url"=> "http://ip:port/v2.0"
    },

    "dispersion"=> {
       # the dispersion user is not automatically created.  You'll need to do the keystone needful.
       # "dis_tenant"=> "dispersion" (default)
       # "dis_user"=> "reporter" (default)
      "dis_key"=> "notautomaticallycreated" # must be set
    },
    "network" => {
      # this should be set to the network that will be used to run swift services
      "management" => "192.168.122.0/24",
      # this should be the same as management for now
      "exnet" => "192.168.122.0/24"
    },
    "swift_common" => {
      "swift_hash_prefix" => "staticprefix", # this should be changed to something else
      "swift_hash_suffix" => "" # this should be defined as blank
    }
  }
)
