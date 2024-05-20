/turf/floor/natural/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force, decl/material/new_girder_material, skip_update)

	if(ispath(new_material))
		new_material = GET_DECL(new_material)

	if(material != new_material || force)
		material = new_material
		if(!istype(material))
			PRINT_STACK_TRACE("Exterior turf has been supplied non-material '[material]'.")
			material = get_default_material()
		. = TRUE

	if(.)
		update_from_material()
		if(!skip_update)
			queue_icon_update()

/turf/floor/natural/proc/update_from_material()
	return

/turf/floor/natural/get_material()
	return material

/turf/floor/natural/get_strata_material_type()
	//Turf strata overrides level strata
	if(ispath(strata_override, /decl/strata))
		var/decl/strata/S = GET_DECL(strata_override)
		if(length(S.base_materials))
			return pick(S.base_materials)
	//Otherwise, just use level strata
	return ..()