mode: deployment   # required, choose deployment/daemonset/etc.

config: |
  receivers:
    otlp:
      protocols:
        grpc: {}
        http: {}

  processors:
    batch: {}
    memory_limiter:
      check_interval: 1s
      limit_mib: 400
      spike_limit_mib: 100
    k8sattributes: {}
    resourcedetection:
      detectors: [env, system]
      timeout: 2s

  exporters:
    debug: {}
    otlp/tempo:
      endpoint: "tempo:4317"
      tls:
        insecure: true
      sending_queue:
        enabled: true
        num_consumers: 2
        queue_size: 5000
      retry_on_failure:
        enabled: true
        initial_interval: 5s
        max_interval: 30s
        max_elapsed_time: 300s
    prometheus:
      endpoint: "0.0.0.0:8889"

  service:
    pipelines:
      metrics:
        receivers: [otlp]
        processors: [memory_limiter, batch, k8sattributes, resourcedetection]
        exporters: [prometheus]
      traces:
        receivers: [otlp]
        processors: [memory_limiter, batch, k8sattributes, resourcedetection]
        exporters: [otlp/tempo]




