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

<<<<<<<< HEAD:code/game/turfs/exterior/_exterior_material.dm
/turf/exterior/proc/update_from_material()
	return

/turf/exterior/get_material()
========
/turf/floor/natural/get_material()
>>>>>>>> 09a51deb017 (Repathing /turf/exterior to /turf/floor/natural.):code/game/turfs/floors/floor_natural_materials.dm
	return material
