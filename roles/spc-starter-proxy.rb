name "spc-starter-proxy"
description "proxy node for starter configuration"
run_list(
  "recipe[swift-private-cloud::proxy-server]"
)
