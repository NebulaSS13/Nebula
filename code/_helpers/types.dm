/proc/get_non_abstract_types(list/input_types)
	. = list()
	if(!input_types)
		return
	if(!islist(input_types))
		input_types = list(input_types)
	for(var/input_type in input_types)
		for(var/input_subtype in typesof(input_type))
			var/datum/input_atom = input_subtype
			if(!TYPE_IS_ABSTRACT(input_atom)) 
				. |= input_subtype
