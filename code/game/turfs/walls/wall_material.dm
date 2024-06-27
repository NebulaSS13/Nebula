/turf/wall/get_default_material()
	. = GET_DECL(DEFAULT_WALL_MATERIAL)

/turf/wall/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force, decl/material/new_girder_material, skip_update)

	if(ispath(new_material))
		new_material = GET_DECL(new_material)

	if(material != new_material || !force)
		material = new_material
		if(!istype(material))
			PRINT_STACK_TRACE("Wall has been supplied non-material '[material]'.")
			material = get_default_material()
		. = TRUE

	if(ispath(new_reinf_material))
		new_reinf_material = GET_DECL(new_reinf_material)
	if(reinf_material != new_reinf_material || !force)
		reinf_material = new_reinf_material
		. = TRUE

	if(ispath(new_girder_material))
		new_girder_material = GET_DECL(new_girder_material)
	if(girder_material != new_girder_material || force)
		girder_material = new_girder_material
		. = TRUE

	if(. && !skip_update)
		update_material()
