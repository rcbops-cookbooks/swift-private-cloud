name "spc-starter-storage"
description "storage node for starter configuration"
run_list(
  "recipe[swift-private-cloud::timezone]",
  "recipe[osops-utils::packages]",
  "recipe[swift-private-cloud::iptables]",
  "recipe[swift-private-cloud::storage-server]"
)
