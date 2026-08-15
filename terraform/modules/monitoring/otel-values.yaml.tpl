config:
  receivers:
    otlp:
      protocols:
        grpc:
        http:

  exporters:
    prometheus:
      endpoint: "0.0.0.0:8889"   # Collector exposes metrics here
    otlp:
      endpoint: "${tempo_dns}:4317"
      tls:
        insecure: true           # disable TLS if Tempo isn’t using it

  service:
    pipelines:
      metrics:
        receivers: [otlp]
        exporters: [prometheus]
      traces:
        receivers: [otlp]
        exporters: [otlp]

