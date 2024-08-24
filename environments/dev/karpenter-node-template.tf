resource "kubectl_manifest" "karpenter_node_template" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: default
    spec:
      subnetSelector:
        karpenter.sh/discovery: ${local.eks_cluster_info.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${local.eks_cluster_info.cluster_name}
      tags:
        karpenter.sh/discovery: ${local.eks_cluster_info.cluster_name}
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}