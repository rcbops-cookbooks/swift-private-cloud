name "spc-starter-controller"
description "controller node for starter configuration"
run_list(
         "recipe[osops-utils::packages]",
         "recipe[swift-private-cloud::git-server]",
         "recipe[swift-private-cloud::admin-server]",
         "recipe[swift-private-cloud::keystone]",
         "recipe[swift-lite::ntp-server]"
)
