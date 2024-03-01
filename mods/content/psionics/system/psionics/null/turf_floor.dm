/turf/simulated/floor/disrupts_psionics()
	var/decl/flooring/flooring = get_flooring()
	flooring?.is_psi_null() ? src : ..()

/turf/simulated/floor/tiled/nullglass
	name = "nullglass floor"
	icon_state = "nullglass"
	icon = 'mods/content/psionics/icons/plating.dmi'
	flooring_layers = /decl/flooring/tiling/nullglass
