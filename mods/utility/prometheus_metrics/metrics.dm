// prometheus_metrics holds a list of metric_family datums and uses them to
// create a json protobuf.
/decl/prometheus_metrics/proc/collect()
	var/list/out = list()

	for(var/decl/metric_family/metric_family in decls_repository.get_decls_of_type_unassociated(/decl/metric_family))
		var/proto = metric_family._to_proto()
		if(proto != null)
			// out += proto will try to merge the lists, we have to insert it at the end instead
			out[++out.len] = proto

	return json_encode(out)
