/decl/topic_command/secure/prometheus_metrics
	name = "prometheus_metrics"
	uid = "topic_command_prometheus_metrics"

/decl/topic_command/secure/prometheus_metrics/use()
	var/static/decl/prometheus_metrics/prometheus_metrics = IMPLIED_DECL
	return prometheus_metrics.collect()