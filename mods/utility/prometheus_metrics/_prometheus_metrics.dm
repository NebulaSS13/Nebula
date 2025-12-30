var/global/list/prometheus_metric_names = list("counter", "gauge")

#define PROMETHEUS_METRIC_COUNTER 0
#define PROMETHEUS_METRIC_GAUGE 1

#define PROMETHEUS_METRIC_NAME(m) global.prometheus_metric_names[m + 1]

/decl/modpack/prometheus_metrics
	name = "Prometheus Metrics"
	desc = "A system for providing gameserver metrics polling via world/Topic, with a JSON protobuf payload."