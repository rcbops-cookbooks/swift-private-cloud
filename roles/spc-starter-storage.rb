name "spc-starter-storage"
description "storage node for starter configuration"
run_list(
  "recipe[swift-private-cloud::timezone]",
  "recipe[osops-utils::packages]",
  "recipe[swift-private-cloud::iptables]",
  "recipe[swift-private-cloud::account-server]",
  "recipe[swift-private-cloud::container-server]",
  "recipe[swift-private-cloud::object-server]"
)
