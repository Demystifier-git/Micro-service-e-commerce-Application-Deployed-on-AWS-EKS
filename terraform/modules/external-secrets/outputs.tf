output "namespace" {
  value = "external-secrets"
}

output "release_name" {
  value = helm_release.external_secrets.name
}

