var/global/list/prometheus_metric_names = list("counter", "gauge")

#define PROMETHEUS_METRIC_COUNTER 0
#define PROMETHEUS_METRIC_GAUGE 1

#define PROMETHEUS_METRIC_NAME(m) global.prometheus_metric_names[m + 1]
