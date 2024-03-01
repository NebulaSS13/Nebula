/turf/exterior/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force)

	if(ispath(new_material))
		new_material = GET_DECL(new_material)

	if(material != new_material || force)
		material = new_material
		if(!istype(material))
			PRINT_STACK_TRACE("Exterior turf has been supplied non-material '[material]'.")
			material = get_default_material()
		. = TRUE

	if(.)
		if(material)
			name       = "[material.adjective_name] [initial(name)]"
			base_color = material.color
		else
			name       = initial(name)
			base_color = initial(base_color)
		dirt_color = base_color
		color = base_color
		update_icon()

/turf/exterior/get_material()
	return material

/turf/exterior/wall/get_default_material()
	. = GET_DECL(SSmaterials.get_strata_material_type(src) || /decl/material/solid/stone/sandstone)

/turf/exterior/wall/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force)
	. = ..()
	if(ispath(new_reinf_material))
		new_reinf_material = GET_DECL(new_reinf_material)
	if(reinf_material != new_reinf_material || !force)
		reinf_material = new_reinf_material
		. = TRUE
	if(.)
		update_material()
