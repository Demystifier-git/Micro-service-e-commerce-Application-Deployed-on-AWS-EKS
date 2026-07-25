output "argocd_server_service" {
  value = "kubectl get svc -n argocd"
}

output "argocd_note" {
  value = "Run: kubectl get ingress -n argocd to get ALB URL"
}