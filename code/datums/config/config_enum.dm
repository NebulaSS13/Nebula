/decl/config/enum
	abstract_type = /decl/config/enum
	default_value = 0
	config_flags = CONFIG_FLAG_ENUM | CONFIG_FLAG_HAS_VALUE
	var/list/enum_map

/decl/config/enum/validate()
	. = ..()
	if(!length(enum_map))
		. += "enum config has zero-length enum_map"

/decl/config/enum/serialize_value()
	var/enum_val
	for(var/val in enum_map)
		if(value == enum_map[val])
			enum_val = val
			break
	if(isnull(enum_val))
		enum_val = handle_value_deconversion(value)
	return "[enum_val]"

/decl/config/enum/serialize_default_value()
	var/enum_val
	for(var/val in enum_map)
		if(default_value == enum_map[val])
			enum_val = val
			break
	if(isnull(enum_val))
		enum_val = handle_value_deconversion(default_value)
	return "[enum_val]"

/decl/config/enum/Initialize()
	. = ..()
	if(islist(enum_map) && length(enum_map))
		if(islist(desc))
			desc += "[desc] Valid values: [english_list(enum_map)]."
		else if(desc)
			desc = "[desc] Valid values: [english_list(enum_map)]."
		else
			desc = "Valid values: [english_list(enum_map)]."

/decl/config/enum/set_value(var/new_value)
	if(istext(new_value))
		new_value = trim(lowertext(new_value))
		if(new_value in enum_map)
			new_value = enum_map[new_value]
		else
			log_error("Invalid key '[new_value]' supplied to [type]. [json_encode(enum_map)]")
			new_value = default_value
	return ..(new_value)
