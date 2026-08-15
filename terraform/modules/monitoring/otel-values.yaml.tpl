config:
  receivers:
    otlp:
      protocols:
        grpc: {}
        http: {}

  exporters:
    debug: {}   # just logs traces/metrics locally

  service:
    pipelines:
      metrics:
        receivers: [otlp]
        exporters: [debug]
      traces:
        receivers: [otlp]
        exporters: [debug]




