locals {
  node_pools_overrides = merge(
    { DEFAULT_OVERRIDES = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : node_pool]
    ),
    var.node_pools_overrides
  )
}

variable "node_pools_overrides" {
  type = map(map(any))

  default = {}
}
