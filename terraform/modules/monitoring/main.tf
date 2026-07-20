resource "helm_release" "kube_prometheus_stack" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      grafana_admin_secret = "grafana-admin"
      grafana_smtp_secret  = "grafana-smtp"
      grafana_hostname     = var.grafana_hostname
      prometheus_hostname  = var.prometheus_hostname
      certificate_arn      = var.certificate_arn
    })
  ]
}

resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = var.namespace

  values = [
    file("${path.module}/otel-values.yaml")
  ]

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}