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

span_processor = BatchSpanProcessor(OTLPSpanExporter(endpoint="your-collector-endpoint"))
trace.get_tracer_provider().add_span_processor(span_processor)

metric_exporter = OTLPMetricsExporter(endpoint="your-collector-endpoint")
metric_reader = PeriodicExportingMetricReader(metric_exporter)
metrics.get_meter_provider().add_metric_reader(metric_reader)
