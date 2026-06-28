# NAMESPACE
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}


# INSTALL EXTERNAL SECRETS OPERATOR (WITH CRDs)


resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  namespace        = kubernetes_namespace.external_secrets.metadata[0].name
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  wait    = true
  atomic  = true
  timeout = 600
}

#########################################################
# CLUSTER SECRET STORE (AWS SECRETS MANAGER)
#########################################################

resource "kubectl_manifest" "cluster_secret_store" {

  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1"
    kind       = "ClusterSecretStore"

    metadata = {
      name = "aws-secret-store"
    }

    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.region

          auth = {
            jwt = {
              serviceAccountRef = {
                name      = "external-secrets"
                namespace = "external-secrets"
              }
            }
          }
        }
      }
    }
  })

  depends_on = [
    helm_release.external_secrets
  ]
}

#########################################################
# GRAFANA EXTERNAL SECRET (DEV)
#########################################################

resource "kubectl_manifest" "grafana_external_secret" {

  yaml_body = yamlencode({
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"

    metadata = {
      name      = "grafana-admin"
      namespace = "monitoring"
    }

    spec = {
      refreshInterval = "1h"

      secretStoreRef = {
        name = "aws-secret-store"
        kind = "ClusterSecretStore"
      }

      target = {
        name           = "grafana-admin-secret"
        creationPolicy = "Owner"
      }

      data = [
        {
          secretKey = "admin-password"

          remoteRef = {
            key = "${var.env}/grafana/admin-password"
          }
        }
      ]
    }
  })

  depends_on = [
    kubectl_manifest.cluster_secret_store
  ]
}