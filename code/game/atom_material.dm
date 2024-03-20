//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/atom/proc/get_material()
	RETURN_TYPE(/decl/material)
	return

//mostly for convenience
/atom/proc/get_material_type()
	. = get_material()?.type
