/obj/get_value_multiplier()
	var/list/matter = get_matter_list()
	if(length(matter))
		var/total_matter = 0
		for(var/mat in matter)
			if(!ispath(mat, /decl/material))
				PRINT_STACK_TRACE("Non-path mat in matter list: [mat]")
			total_matter += matter[mat]
		var/mat_value_mult = 0
		for(var/mat in matter)
			if(!ispath(mat, /decl/material))
				PRINT_STACK_TRACE("Non-path mat in matter list: [mat]")
			var/decl/material/mat_datum = GET_DECL(mat)
			mat_value_mult += mat_datum.value * (matter[mat] / total_matter)
		. = mat_value_mult * MATERIAL_WORTH_MULTIPLIER
	else
		. = ..()

/obj/get_base_value()
	if(holographic)
		return 0
	var/list/matter = get_matter_list()
	if(length(matter))
		. = 0
		for(var/mat in matter)
			. += matter[mat]
		. = Floor(. * REAGENT_UNITS_PER_MATERIAL_UNIT)
	else
		. = Clamp(w_class, ITEM_SIZE_MIN, ITEM_SIZE_MAX)
	. = max(1, round(.))