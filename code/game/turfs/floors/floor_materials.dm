/turf/floor/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force, decl/material/new_girder_material, skip_update)

	if(ispath(new_material))
		new_material = GET_DECL(new_material)

	if(material != new_material || force)
		material = new_material
		if(!istype(material))
			if(material)
				PRINT_STACK_TRACE("Floor turf has been supplied non-material '[istype(material, /datum) ? material.type : (material || "NULL")]'.")
			material = get_default_material()
		. = TRUE

	if(. && !skip_update)
		queue_icon_update()

/turf/floor/get_material()
	var/decl/flooring/flooring = get_topmost_flooring()
	if(istype(flooring) && istype(flooring.force_material))
		return flooring.force_material
	return material
