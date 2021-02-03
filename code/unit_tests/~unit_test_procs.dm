/proc/is_string_in_list(input, list/strings)
	for(var/string in strings)
		if(deep_string_equals(input, string))
			return TRUE
	return FALSE
