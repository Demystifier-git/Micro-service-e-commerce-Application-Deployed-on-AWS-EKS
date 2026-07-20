prometheus:
  prometheusSpec:
    retention: 7d
    externalUrl: https://${prometheus_hostname}

  ingress:
    enabled: true
    ingressClassName: alb
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/certificate-arn: ${certificate_arn}
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
      alb.ingress.kubernetes.io/ssl-redirect: "443"
      alb.ingress.kubernetes.io/target-type: ip

    hosts:
      - ${prometheus_hostname}

    paths:
      - /

    pathType: Prefix

grafana:
  enabled: true

  admin:
    existingSecret: grafana-admin
    userKey: admin-user
    passwordKey: admin-password

  envFromSecret: grafana-smtp

  grafana.ini:
    server:
      root_url: https://${grafana_hostname}

    smtp:
      enabled: true
      host: $__env{GF_SMTP_HOST}
      user: $__env{GF_SMTP_USER}
      password: $__env{GF_SMTP_PASSWORD}
      from_address: $__env{GF_SMTP_FROM}

  ingress:
    enabled: true
    ingressClassName: alb

    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/certificate-arn: ${certificate_arn}
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
      alb.ingress.kubernetes.io/ssl-redirect: "443"
      alb.ingress.kubernetes.io/target-type: ip

    hosts:
      - ${grafana_hostname}

    paths:
      - /

    pathType: Prefix

alertmanager:
  enabled: true