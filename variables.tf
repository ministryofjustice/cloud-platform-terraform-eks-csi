variable "eks_cluster" {
  type        = string
  description = "cluster name"
}

variable "tolerations" {
  type = list(map(string))
  default = [
    {
      key      = "monitoring-node",
      operator = "Equal",
      value    = "true",
      effect   = "NoSchedule"
    }
  ]
  description = "Tolerations to apply to deployment"
}