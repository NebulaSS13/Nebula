/proc/is_string_in_list(input, list/strings)
	for(var/string in strings)
		if(deep_string_equals(input, string))
			return TRUE
	return FALSE

/datum/unit_test/proc/get_named_instance(var/instance_type, var/instance_loc, var/instance_name)
	check_cleanup = TRUE
	var/atom/movable/am = new instance_type(instance_loc)
	if(ismob(am))
		var/mob/M = am
		M.real_name = name
	am.SetName("[instance_name ? instance_name : name] ([name])")
	return am
