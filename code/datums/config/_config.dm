#define CONFIG_FLAG_BOOL      BITFLAG(0)
#define CONFIG_FLAG_NUM       BITFLAG(1)
#define CONFIG_FLAG_ENUM      BITFLAG(2)
#define CONFIG_FLAG_TEXT      BITFLAG(3)
#define CONFIG_FLAG_LIST      BITFLAG(4)
#define CONFIG_FLAG_HAS_VALUE BITFLAG(5)

/proc/get_config_value(var/config_decl)
	var/decl/config/config_option = GET_DECL(config_decl)
	return config_option.value

/proc/set_config_value(var/config_decl, var/new_value, var/defer_config_refresh = FALSE)

	// Get our actual value (loading from text etc. may change data type)
	var/decl/config/config_option = GET_DECL(config_decl)
	if((config_option.config_flags & (CONFIG_FLAG_NUM|CONFIG_FLAG_BOOL)) && istext(new_value))
		new_value = text2num(new_value)
	else if((config_option.config_flags & (CONFIG_FLAG_ENUM|CONFIG_FLAG_TEXT)) && isnum(new_value))
		new_value = num2text(new_value)

	// Identical values, no point updating.
	if(config_option.value == new_value)
		return

	// Actually set the value.
	var/old_value = config_option.value
	config_option.set_value(new_value)
	if(config_option.value != old_value && !defer_config_refresh)
		config_option.update_post_value_set()

/proc/toggle_config_value(var/config_decl)
	var/decl/config/config_option = GET_DECL(config_decl)
	if(!(config_option.config_flags & CONFIG_FLAG_BOOL))
		CRASH("Attempted to toggle non-boolean config entry [config_decl].")
	set_config_value(config_decl, !config_option.value)
	return config_option.value

/decl/config
	abstract_type = /decl/config
	decl_flags = DECL_FLAG_MANDATORY_UID
	var/desc
	var/value
	var/default_value
	var/config_flags = CONFIG_FLAG_HAS_VALUE
	var/protected = FALSE

	var/static/list/protected_vars = list(
		"desc",
		"value",
		"default_value",
		"config_flags",
		"protected"
	)

/decl/config/Initialize()
	. = ..()
	// Config options without values are assumed false and set to true if present in the loaded data.
	// Otherwise we initialize to the default value.
	if(!(config_flags & CONFIG_FLAG_HAS_VALUE))
		default_value = FALSE
		if(desc)
			desc += " Uncomment to enable."
		else
			desc = "Uncomment to enable."
	value = default_value

/decl/config/VV_hidden()
	. = ..()
	if(protected)
		. |= protected_vars

/decl/config/validate()
	. = ..()
	if(isnull(desc))
		. += "no config description set"
	if(isnull(default_value))
		if(config_flags & CONFIG_FLAG_HAS_VALUE)
			. += "null default value"
	else
		if((config_flags & (CONFIG_FLAG_NUM|CONFIG_FLAG_ENUM)) && !isnum(default_value))
			. += "has numeric or enum flag but not numeric default_value"
		else if((config_flags & CONFIG_FLAG_BOOL) && default_value != TRUE && default_value != FALSE)
			. += "has bool flag but not TRUE (1) or FALSE (0) default_value"
		else if((config_flags & CONFIG_FLAG_TEXT) && !istext(default_value))
			. += "has text flag but not text default_value"
		else if((config_flags & CONFIG_FLAG_LIST) && !islist(default_value))
			. += "has list flag but not list default_value"
		set_value(handle_value_deconversion(default_value))
		if(!compare_values(value, default_value))
			. += "setting to default value via proc resulted in different value ([serialize_value(value)] != [serialize_value(default_value)])"
		var/comparison_fail = default_value_serialize_comparison_fails()
		if(comparison_fail)
			. += "conversion and deconversion of default value does not equal default value ([comparison_fail])"

/decl/config/proc/compare_values(var/value_one, var/value_two)
	return value_one == value_two

/decl/config/proc/default_value_serialize_comparison_fails()
	var/new_val = handle_value_conversion(handle_value_deconversion(default_value))
	if(!compare_values(new_val, default_value))
		return "[new_val] != [default_value]"

/decl/config/proc/sanitize_value()
	SHOULD_CALL_PARENT(TRUE)
	var/invalid_value = FALSE
	if((config_flags & CONFIG_FLAG_BOOL) && value != TRUE && value != FALSE)
		invalid_value = TRUE
	else if((config_flags & (CONFIG_FLAG_NUM|CONFIG_FLAG_ENUM)) && !isnum(value))
		invalid_value = TRUE
	else if((config_flags & CONFIG_FLAG_TEXT) && !istext(value))
		invalid_value = TRUE
	else if((config_flags & CONFIG_FLAG_LIST) && !islist(value))
		invalid_value = TRUE
	if(invalid_value)
		value = default_value

/decl/config/proc/update_post_value_set()
	SHOULD_CALL_PARENT(TRUE)
	return

/decl/config/proc/get_comment_desc_text()
	if(desc)
		if(islist(desc))
			for(var/config_line in desc)
				LAZYADD(., "## [config_line]")
		else
			LAZYADD(., "## [desc]")

/decl/config/proc/get_comment_value_text()
	if(config_flags & CONFIG_FLAG_HAS_VALUE)
		if(compare_values(value, default_value))
			. += "#[uppertext(uid)] [serialize_default_value()]"
		else
			. += "[uppertext(uid)] [serialize_value()]"
	else if(value)
		. += uppertext(uid)
	else
		. += "#[uppertext(uid)]"

/decl/config/proc/get_config_file_text()

	. = list()

	var/add_desc = get_comment_desc_text()
	if(!isnull(add_desc))
		. += add_desc

	var/add_value = get_comment_value_text()
	if(!isnull(add_value))
		. += add_value

	return jointext(., "\n")

/decl/config/proc/serialize_value()
	return "[handle_value_deconversion(value)]"

/decl/config/proc/serialize_default_value()
	return "[handle_value_deconversion(default_value)]"

/decl/config/proc/handle_value_conversion(var/new_value)
	return new_value

/decl/config/proc/handle_value_deconversion(var/new_value)
	return new_value

/decl/config/proc/set_value(var/new_value)
	value = handle_value_conversion(new_value)
	sanitize_value()
