/obj/get_single_monetary_worth()
	var/mult = 1
	if(length(matter))
		var/total_matter = 0
		for(var/mat in matter)
			total_matter += matter[mat]
		var/mat_value_mult = 0
		for(var/mat in matter)
			var/material/mat_datum = SSmaterials.get_material_datum(mat)
			mat_value_mult += mat_datum.value * (matter[mat] / total_matter)
		mult = mat_value_mult * (total_matter / SHEET_MATERIAL_AMOUNT)
	else
		mult = Clamp(w_class, ITEM_SIZE_MIN, ITEM_SIZE_MAX)
	. = round(..() * mult)
