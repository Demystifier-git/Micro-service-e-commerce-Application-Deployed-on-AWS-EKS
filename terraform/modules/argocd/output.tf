output "argocd_server_service" {
  value = "kubectl get svc -n argocd"
}