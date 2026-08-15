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
          url = "http://loki.delightdavid.online:3100/loki/api/v1/push"
        }]
      }
    })
  ]
}

# OpenTelemetry Collector via Helm
resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = var.namespace

  values = [
    yamlencode({
      mode = "daemonset" # 
    }),

  ]

  set {
    name  = "image.repository"
    value = "otel/opentelemetry-collector"
  }

  set {
    name  = "image.tag"
    value = "0.102.0"
  }

  depends_on = [
    helm_release.promtail
  ]
}
