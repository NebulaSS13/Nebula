/turf/proc/get_material()
	RETURN_TYPE(/decl/material)

/turf/proc/get_material_type()
	return get_material()?.type

/turf/proc/get_default_material()
	return null

/turf/proc/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force)
	return

