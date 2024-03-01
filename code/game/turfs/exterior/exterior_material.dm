/turf/exterior/set_material(decl/material/new_material, skip_icon_update)
	if(ispath(new_material, /decl/material))
		new_material = GET_DECL(new_material)
	material = new_material?.type
	if(new_material)
		dirt_color = new_material.color
		base_color = new_material.color
	update_icon()
