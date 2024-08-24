variable "common_info" {
  description = "common_info"
  type        = any
  default     = null
}

variable "common_tags" {
  description = "common_tags"
  type        = any
  default     = null
}

variable "vpc_info" {
  description = "vpc_info"
  type = any
  default = null
}

variable "eks_cluster_info" {
  description = "eks_cluster_info"
  type = any
  default = null
}

variable "alb_chart" {
  type        = map(string)
  description = "AWS Load Balancer Controller chart"
  default = {
    name       = "aws-load-balancer-controller"
    namespace  = "kube-system"
    repository = "https://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"
    version    = "1.5.5"
  }
}