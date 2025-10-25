/decl/material/proc/get_presentation_name(var/obj/item/prop)
	if(islist(prop?.reagents?.reagent_data))
		. = LAZYACCESS(prop.reagents.reagent_data[src], DATA_MASK_NAME)
	. ||= glass_name || get_reagent_name(prop?.reagents)
	if(prop?.reagents?.total_volume)
		. = build_presentation_name_from_reagents(prop, .)

/decl/material/proc/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	. = supplied
	if(cocktail_ingredient)
		for(var/decl/cocktail/cocktail in SSmaterials.get_cocktails_by_primary_ingredient(type))
			if(cocktail.matches(prop))
				return cocktail.get_presentation_name(prop)
	if(prop.reagents.has_reagent(/decl/material/solid/ice))
		. = "iced [.]"

/decl/material/proc/get_presentation_desc(var/obj/item/prop)
	. = glass_desc
	if(prop?.reagents?.total_volume)
		. = build_presentation_desc_from_reagents(prop, .)

/decl/material/proc/build_presentation_desc_from_reagents(var/obj/item/prop, var/supplied)
	. = supplied

	if(cocktail_ingredient)
		for(var/decl/cocktail/cocktail in SSmaterials.get_cocktails_by_primary_ingredient(type))
			if(cocktail.matches(prop))
				return cocktail.get_presentation_desc(prop)

/decl/material/proc/get_reagent_name(datum/reagents/holder, phase = MAT_PHASE_LIQUID)

	if(istype(holder) && holder.reagent_data)
		var/list/rdata = holder.reagent_data[src]
		if(rdata)
			var/data_name = rdata[DATA_MASK_NAME]
			if(data_name)
				return data_name

	if(phase == MAT_PHASE_SOLID)
		return solid_name

	// Check if the material is in solution. This is a much simpler check than normal solubility.
	if(phase == MAT_PHASE_LIQUID)
		if(!istype(holder))
			return liquid_name
		var/atom/location = holder.get_reaction_loc()
		var/temperature = location?.temperature || T20C

		if(melting_point > temperature)
			return solution_name
		else
			return liquid_name

	return "something"

/decl/material/proc/get_reagent_color(datum/reagents/holder)
	if(istype(holder) && holder.reagent_data)
		var/list/rdata = holder.reagent_data[src]
		if(rdata)
			var/data_color = rdata[DATA_MASK_COLOR]
			if(data_color)
				return data_color
	return color

/decl/material/proc/get_reagent_overlay_color(datum/reagents/holder)
	var/list/rdata = REAGENT_DATA(holder, src)
	return LAZYACCESS(rdata, DATA_EXTRA_COLOR) || get_reagent_color(holder) + num2hex(opacity * 255)

// Dumb overlay to apply over wall sprite for cheap texture effect
/decl/material/proc/get_wall_texture()
	return