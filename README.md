# Observability Setup

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Instrumenting the Application](#instrumenting-the-application)
   - [Installing OpenTelemetry SDK](#installing-opentelemetry-sdk)
   - [Configuring OpenTelemetry](#configuring-opentelemetry)
4. [Deploying OpenTelemetry Collector](#deploying-opentelemetry-collector)
   - [Kubernetes Manifest for Collector](#kubernetes-manifest-for-collector)
   - [ConfigMap for Collector Configuration](#configmap-for-collector-configuration)
5. [Configuring AKS Monitoring](#configuring-aks-monitoring)
   - [Enable Azure Monitor](#enable-azure-monitor)
6. [Viewing Metrics and Logs](#viewing-metrics-and-logs)
7. [Conclusion](#conclusion)

## Introduction
This document provides step-by-step instructions to set up observability for an AI application deployed on Azure Kubernetes Service (AKS) using OpenTelemetry. It includes capturing application traces, logs, and metrics and sending them to Azure Monitor and Application Insights.

## Prerequisites
- Azure Subscription
- AKS Cluster
- Application deployed on AKS
- Azure CLI installed

## Instrumenting the Application

### Installing OpenTelemetry SDK

#### For Python:
```bash
pip install opentelemetry-api
pip install opentelemetry-sdk
pip install opentelemetry-exporter-otlp

#### For Node.js:
```bash
npm install @opentelemetry/api
npm install @opentelemetry/sdk-node
npm install @opentelemetry/exporter-otlp-grpc
```

### Configuring OpenTelemetry

#### For Python:
```python
from opentelemetry import trace, metrics
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.resources import Resource
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.metrics_exporter import OTLPMetricsExporter
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader

resource = Resource(attributes={
    "service.name": "your-service",
    "service.instance.id": "instance-id",
})

trace.set_tracer_provider(TracerProvider(resource=resource))
metrics.set_meter_provider(MeterProvider(resource=resource))

span_processor = BatchSpanProcessor(OTLPSpanExporter(endpoint="your-collector-endpoint:4317"))
trace.get_tracer_provider().add_span_processor(span_processor)

metric_exporter = OTLPMetricsExporter(endpoint="your-collector-endpoint:4317")
metric_reader = PeriodicExportingMetricReader(metric_exporter)
metrics.get_meter_provider().add_metric_reader(metric_reader)
```

#### For Node.js:
```javascript
const { NodeTracerProvider } = require('@opentelemetry/sdk-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-otlp-grpc');
const { registerInstrumentations } = require('@opentelemetry/instrumentation');

const provider = new NodeTracerProvider({
  resource: new Resource({
    'service.name': 'your-service',
  }),
});

const exporter = new OTLPTraceExporter({
  url: 'grpc://your-collector-endpoint:4317',
});

provider.addSpanProcessor(new BatchSpanProcessor(exporter));
provider.register();

registerInstrumentations({
  tracerProvider: provider,
});
```

## Deploying OpenTelemetry Collector

### Kubernetes Manifest for Collector
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: otel-collector
spec:
  replicas: 1
  selector:
    matchLabels:
      app: otel-collector
  template:
    metadata:
      labels:
        app: otel-collector
    spec:
      containers:
      - name: otel-collector
        image: otel/opentelemetry-collector:latest
        ports:
        - containerPort: 4317
        - containerPort: 4318
        volumeMounts:
        - name: config
          mountPath: /etc/otel-collector-config
        args: ["--config=/etc/otel-collector-config/config.yaml"]
      volumes:
      - name: config
        configMap:
          name: otel-collector-config
```

### ConfigMap for Collector Configuration
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-collector-config
data:
  config.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: "0.0.0.0:4317"
          http:
            endpoint: "0.0.0.0:4318"
    processors:
      batch:
    exporters:
      azuremonitor:
        instrumentation_key: "<Your-Application-Insights-Instrumentation-Key>"
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [azuremonitor]
        metrics:
          receivers: [otlp]
          processors: [batch]
          exporters: [azuremonitor]
```

## Configuring AKS Monitoring

### Enable Azure Monitor
```bash
az aks enable-addons --resource-group your-resource-group --name your-aks-cluster --addons monitoring
```

## Viewing Metrics and Logs
1. Navigate to Azure Portal.
2. Go to your AKS cluster.
3. Check "Insights" under the "Monitoring" section to view metrics and logs.

## Conclusion
Following these steps will help you set up a robust observability solution for your AI application in AKS. If you have any questions or need further assistance, feel free to reach out.
```

This README file includes all the necessary instructions and code snippets to set up observability using OpenTelemetry in your AKS environment. You can adjust the configuration details to match your specific setup. If you need further customization or have additional questions, feel free to ask!
