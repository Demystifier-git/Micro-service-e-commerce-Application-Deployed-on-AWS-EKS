config:
  receivers:
    otlp:
      protocols:
        grpc:
        http:
  exporters:
    prometheus:
      endpoint: "http://${prometheus_dns}:9090"
    otlp:
      endpoint: "http://${tempo_dns}:4317"
  service:
    pipelines:
      metrics:
        receivers: [otlp]
        exporters: [prometheus]
      traces:
        receivers: [otlp]
        exporters: [otlp]
