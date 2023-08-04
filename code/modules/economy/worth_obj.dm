/obj/worth()
	. = ..()
	if(length(matter))
		for(var/mat in matter)
			var/decl/material/mat_datum = GET_DECL(mat)
			. += mat_datum.value * matter[mat] * MATERIAL_WORTH_MULTIPLIER