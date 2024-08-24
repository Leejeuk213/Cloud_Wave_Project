resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = var.alb_chart.name
    namespace = var.alb_chart.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = module.alb_controller_irsa.iam_role_arn
    }
  }
}