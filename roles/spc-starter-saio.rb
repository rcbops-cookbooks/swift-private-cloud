name "spc-starter-saio"
description "All-in-One storage node for starter configuration"
run_list(
         "recipe[osops-utils::packages]",
         "recipe[swift-private-cloud::storage-server]"
         "recipe[swift-private-cloud::proxy-server]"
)
