/obj/get_value_multiplier()
	if(length(matter))
		var/total_matter = 0
		for(var/mat in matter)
			total_matter += matter[mat]
		var/mat_value_mult = 0
		for(var/mat in matter)
			var/material/mat_datum = SSmaterials.get_material_datum(mat)
			mat_value_mult += mat_datum.value * (matter[mat] / total_matter)
		. = mat_value_mult * (total_matter / SHEET_MATERIAL_AMOUNT)
	else
		. = ..()

/obj/item/get_value_multiplier()
	. = length(matter) ? ..() : (material?.value || 1)

/obj/structure/get_value_multiplier()
	. = length(matter) ? ..() : (material?.value || 1)

/obj/get_base_value()
	if(holographic)
		return 0
	if(length(matter))
		. = 0
		for(var/mat in matter)
			. += matter[mat]
		. = Floor(. / SHEET_MATERIAL_AMOUNT)
	else
		. = Clamp(w_class, ITEM_SIZE_MIN, ITEM_SIZE_MAX)
	. = max(1, round(.))