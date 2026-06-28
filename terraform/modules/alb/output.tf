output "service_account_name" {
  value = kubernetes_service_account_v1.alb.metadata[0].name
}