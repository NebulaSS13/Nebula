/turf/floor/disrupts_psionics()
	var/decl/flooring/flooring = GET_TOPMOST_OR_BASE_FLOORING(src)
	return (flooring && flooring.is_psi_null()) ? src : ..()

/turf/floor/tiled/nullglass
	name       = "nullglass floor"
	icon_state = "nullglass"
	_flooring  = /decl/flooring/tiling/nullglass
