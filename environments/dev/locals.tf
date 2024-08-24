locals {
  common_info = yamldecode(file("../../_variables_/dev/common_info.yaml"))
  common_tags = yamldecode(file("../../_variables_/dev/common_tags.yaml"))
  vpc_info = yamldecode(file("../../_variables_/dev/vpc_info.yaml"))
  eks_cluster_info = yamldecode(file("../../_variables_/dev/eks_cluster_info.yaml"))
  alb_info = yamldecode(file("../../_variables_/dev/alb_info.yaml"))
}
