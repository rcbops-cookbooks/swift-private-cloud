name "spc-starter-controller"
description "controller node for starter configuration"
run_list(
         "recipe[swift-private-cloud::admin-server]",
         "role[swift-lite-ntp]"

)
