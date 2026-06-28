# =========================================================
# ARGOCD DEV SETUP - SIMPLE + FAST (EKS + ALB)
# =========================================================

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    helm = {
      source  = "hashicorp/helm"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# ---------------------------------------------------------
# Namespace
# ---------------------------------------------------------
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# ---------------------------------------------------------
# ArgoCD Helm Release (DEV)
# ---------------------------------------------------------
resource "helm_release" "argocd" {

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false

  wait            = true
  atomic          = true
  timeout         = 600
  cleanup_on_fail = true

  values = [
    yamlencode({

      # ===================================================
      # CORE (SINGLE REPLICA - DEV ONLY)
      # ===================================================
      controller = {
        replicas = 1
      }

      repoServer = {
        replicas = 1
      }

      server = {
        replicas = 1

        service = {
          type = "ClusterIP"
        }

        # ===================================================
        # ALB INGRESS (HTTP ONLY - DEV)
        # ===================================================
        ingress = {
          enabled = true

          ingressClassName = "alb"

          annotations = {
            "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
            "alb.ingress.kubernetes.io/target-type"  = "ip"
            "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80}]"
          }

          
        }
      }

      # ===================================================
      # SECURITY (DEV MODE ONLY)
      # ===================================================
      configs = {
        params = {
          "server.insecure" = true
        }

        cm = {
          "users.anonymous.enabled" = "true"
        }
      }

      # ===================================================
      # DEFAULT COMPONENTS
      # ===================================================
      redis = {
        enabled = true
      }

      dex = {
        enabled = false
      }

      notifications = {
        enabled = false
      }

      # ===================================================
      # LIGHTWEIGHT RESOURCES
      # ===================================================
      controller = {
        resources = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }

      repoServer = {
        resources = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }

      server = {
        resources = {
          requests = {
            cpu    = "100m"
            memory = "128Mi"
          }
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.argocd
  ]
}

# ---------------------------------------------------------
# OUTPUT: ALB URL (manual lookup friendly)
# ---------------------------------------------------------
output "argocd_note" {
  value = "Run: kubectl get ingress -n argocd to get ALB URL"
}
