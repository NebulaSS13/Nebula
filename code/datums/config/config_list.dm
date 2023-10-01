/decl/config/lists
	abstract_type = /decl/config/lists
	default_value = list()
	config_flags = CONFIG_FLAG_LIST | CONFIG_FLAG_HAS_VALUE

/decl/config/lists/handle_value_deconversion(var/new_value)
	return json_encode(new_value)

/decl/config/lists/handle_value_conversion(var/new_value)
	return json_decode(new_value)

/decl/config/lists/compare_values(var/value_one, var/value_two)
	if(!islist(value_one) || !islist(value_two))
		return ..(value_one, value_two)
	if(length(value_one) != length(value_two))
		return FALSE
	for(var/i = 1 to length(value_one))
		if(!same_entries(value_one[i], value_two[i]) && value_one[i] != value_two[i])
			return FALSE
	return TRUE

/decl/config/lists/default_value_serialize_comparison_fails()
	var/list/new_value = handle_value_conversion(handle_value_deconversion(default_value))
	if(!compare_values(new_value, default_value))
		return "[json_encode(new_value)] != [json_encode(default_value)]"
