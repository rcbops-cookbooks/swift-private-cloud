name "spc-starter-storage"
description "storage node for starter configuration"
run_list(
  "recipe[swift-private-cloud::storage-server]"
)
