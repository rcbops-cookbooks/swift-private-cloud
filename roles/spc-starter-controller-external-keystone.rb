name "spc-starter-controller-external-keystone"
description "controller node for starter configuration w/external keystone"
run_list(
  "recipe[swift-private-cloud::timezone]",
  "recipe[osops-utils::packages]",
  "recipe[swift-private-cloud::iptables]",
  "recipe[swift-private-cloud::git-server]",
  "recipe[swift-private-cloud::admin-server]",
  "recipe[swift-private-cloud::admin-server-object-expirer]"
)
