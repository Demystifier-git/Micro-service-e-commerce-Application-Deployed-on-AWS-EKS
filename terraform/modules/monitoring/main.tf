# Promtail DaemonSet via Helm
resource "helm_release" "promtail" {
  name             = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({

      config = {
        clients = [{
          # Use DNS name instead of IP
          url = "http://loki:3100/loki/api/v1/push"
        }]
      }
    })
  ]
}

resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = var.namespace

  values = [
    file("${path.module}/otel-values.yaml.tpl")
  ]

  set {
    name  = "image.repository"
    value = "otel/opentelemetry-collector"
  }

   set {
    name  = "mode"
    value = "deployment"
  }

  set {
    name  = "image.tag"
    value = "0.102.0"
  }

  depends_on = [
    helm_release.promtail
  ]
}

# Node Exporter via Helm
resource "helm_release" "node_exporter" {
  name             = "node-exporter"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus-node-exporter"
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      hostNetwork = true # bind directly to node's private IP
      hostPID     = true # recommended for node exporter
      service = {
        type = "ClusterIP" # internal service, not exposed publicly
      }
      prometheus = {
        monitor = {
          enabled = false # disable ServiceMonitor since Prometheus is external
        }
      }
    })
  ]

  depends_on = [
    helm_release.promtail,
    helm_release.otel_collector
  ]
}
