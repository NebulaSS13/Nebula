/decl/config/enum
	abstract_type = /decl/config/enum
	default_value = 0
	config_flags = CONFIG_FLAG_ENUM | CONFIG_FLAG_HAS_VALUE

/decl/config/enum/proc/get_enum_map()
	return

/decl/config/enum/validate()
	. = ..()
	if(!length(get_enum_map()))
		. += "enum config has zero-length return to get_enum_map()"

/decl/config/enum/Initialize()
	. = ..()
	var/list/enum_map = get_enum_map()
	if(length(enum_map))
		if(desc)
			desc = "[desc] Valid values: [english_list(enum_map)]."
		else
			desc = english_list(enum_map)

/decl/config/enum/set_value(var/new_value)
	if(istext(new_value))
		var/list/enum_map = get_enum_map()
		new_value = trim(lowertext(new_value))
		if(new_value in enum_map)
			new_value = enum_map[new_value]
		else
			log_error("Invalid key '[new_value]' supplied to [type].")
			new_value = default_value
	return ..(new_value)
