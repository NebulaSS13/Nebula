/turf/floor/disrupts_psionics()
	var/decl/flooring/flooring = get_topmost_flooring()
	return (flooring && flooring.is_psi_null()) ? src : ..()

/turf/floor/tiled/nullglass
	name = "nullglass floor"
	icon_state = "nullglass"
	_flooring = /decl/flooring/tiling/nullglass
