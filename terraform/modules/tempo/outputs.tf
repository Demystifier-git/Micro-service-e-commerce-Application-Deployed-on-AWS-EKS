output "tempo_namespace" {
  value = "monitoring"
}

output "tempo_service" {
  value = "tempo.${var.namespace}.svc.cluster.local:4317"
}