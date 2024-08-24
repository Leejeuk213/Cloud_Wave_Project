variable "common_info" {
  description = "common_info"
  type        = any
}

variable "common_tags" {
  description = "common_tags"
  type        = any
}

variable "vpc_info" {
  description = "vpc_info"
  type = any
}

variable "eks_cluster_info" {
  description = "eks_cluster_info"
  type = any
  default = null
}

variable "vpc_id" {
  description = "vpc_id"
  type = any
}

variable "subnets_public_ids" {
  description = "subnets_public_ids"
  type = any
}