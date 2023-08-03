/obj/get_single_monetary_worth()
	. = ..()
	if(length(matter))
		var/mat_value = 0
		for(var/mat in matter)
			var/decl/material/mat_datum = GET_DECL(mat)
			mat_value += mat_datum.value * matter[mat] * MATERIAL_WORTH_MULTIPLIER
		. += mat_value