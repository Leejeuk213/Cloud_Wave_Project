resource "helm_release" "alb_controller" {
  namespace  = var.alb_chart.namespace
  repository = var.alb_chart.repository
  name    = var.alb_chart.name
  chart   = var.alb_chart.chart
  version = var.alb_chart.version
  
  set {
    name  = "clusterName"
    value = local.eks_cluster_info.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_controller.metadata.0.name
  }
  set {
    name  = "region"
    value = local.eks_cluster_info.region
  }
  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }
  depends_on = [kubernetes_service_account.alb_controller]
}