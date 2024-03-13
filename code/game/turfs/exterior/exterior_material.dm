/turf/exterior/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force, decl/material/new_girder_material, skip_update)

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
		if(!skip_update)
			queue_icon_update()

/turf/exterior/get_material()
	return material
