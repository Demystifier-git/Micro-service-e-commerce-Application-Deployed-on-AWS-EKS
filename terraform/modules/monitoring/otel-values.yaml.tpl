config:
  receivers:
    otlp:
      protocols:
        grpc: {}
        http: {}

  exporters:
    debug: {}
    otlp/tempo:
      endpoint: "10.0.2.226:4317"
      tls:
        insecure: true
    prometheus:
      endpoint: "0.0.0.0:8889"

  service:
    pipelines:
      metrics:
        receivers: [otlp]
        exporters: [prometheus]
      traces:
        receivers: [otlp]
        exporters: [otlp/tempo]




