output "promtail_release_name" {
  description = "Name of the Promtail Helm release"
  value       = helm_release.promtail.name
}

output "promtail_namespace" {
  description = "Namespace where Promtail is deployed"
  value       = helm_release.promtail.namespace
}

output "otel_collector_release_name" {
  description = "Name of the OpenTelemetry Collector Helm release"
  value       = helm_release.otel_collector.name
}

output "otel_collector_namespace" {
  description = "Namespace where OpenTelemetry Collector is deployed"
  value       = helm_release.otel_collector.namespace
}
