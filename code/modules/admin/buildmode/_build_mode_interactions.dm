/decl/build_mode_interaction
	abstract_type = /decl/build_mode_interaction
	var/name
	var/description
	var/dummy_interaction = FALSE
	var/strict_parameter_check = TRUE
	var/list/trigger_params
	var/static/list/all_parameters = list(
		"left"   = "Left Click",
		"right"  = "Right Click",
		"middle" = "Middle Click",
		"ctrl"   = "Ctrl",
		"alt"    = "Alt"
	)

/decl/build_mode_interaction/Initialize()
	. = ..()
	if(isnull(name))
		var/list/param_strings = list()
		for(var/param in trigger_params)
			param_strings += all_parameters[param] || capitalize(param)
		name = jointext(param_strings, " + ")

/decl/build_mode_interaction/validate()
	. = ..()
	if(!dummy_interaction)
		if(length(trigger_params))
			for(var/param in trigger_params)
				if(!(param in all_parameters))
					. += "invalid parameter: [param]"
		else
			. += "null or empty parameter list"

	if(!istext(name))
		. += "null or invalid name: [name || "NULL"]"

	if(!istext(description))
		. += "null or invalid description: [description || "NULL"]"

/decl/build_mode_interaction/proc/CanInvoke(datum/build_mode/build_mode, atom/A, list/parameters)

	if(dummy_interaction)
		return FALSE

	// Simple check for missing parameters.
	for(var/parameter in trigger_params)
		if(!parameters[parameter])
			return FALSE

	// More involved check for overlapping parameter sets.
	if(strict_parameter_check)
		for(var/parameter in parameters)
			if((parameter in all_parameters) && !(parameter in trigger_params))
				return FALSE

	// Success!
	return TRUE

/decl/build_mode_interaction/proc/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	return FALSE
