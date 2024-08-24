resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: default
    spec:
      requirements:
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot"] #"spot"
        - key: "node.kubernetes.io/instance-type"
          operator: In
          values: ["t3.xlarge", "t3.medium", "t3.large"]
      limits:
        resources:
          cpu: 50
          memory: 192Gi
      providerRef:
        name: default
      ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}