name "spc-starter-proxy"
description "proxy node for starter configuration"
run_list(
         "recipe[osops-utils::packages]",
         "recipe[swift-private-cloud::iptables]",
         "recipe[swift-private-cloud::proxy-server]"
)
