name "spc-starter-controller"
description "controller node for starter configuration"
run_list(
         "role[swift-lite-ntp]",
         "recipe[swift-private-cloud::admin-server]"
)
