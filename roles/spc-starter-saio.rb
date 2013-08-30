name "spc-starter-saio"
description "All-in-One storage node for starter configuration"
run_list(
  "recipe[swift-private-cloud::timezone]",
  "recipe[osops-utils::packages]",
  "recipe[swift-private-cloud::iptables]",
  "recipe[swift-private-cloud::storage-server]",
  "recipe[swift-private-cloud::proxy-server]"
)
