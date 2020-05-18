// /datum/controller/subsystem/atoms
// 	adjust_init_arguments = TRUE

/datum/controller/subsystem/atoms/GetArguments(atom/A, list/mapload_arg, created=TRUE)
	var/list/arguments = ..(A, mapload_arg, created)
	var/populate_parts = FALSE
	if(SSpersistence.in_loaded_world && istype(A, /obj/machinery))
		if(arguments.len >= 2)
			arguments[3] = populate_parts
		else
			arguments |= list(null, populate_parts)
	return arguments