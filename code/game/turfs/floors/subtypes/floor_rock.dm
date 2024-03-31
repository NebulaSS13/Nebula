/turf/floor/rock
	name = "rock floor"
	icon = 'icons/turf/flooring/rock.dmi'
	icon_state = "rock"
	base_flooring = /decl/flooring/rock

/turf/floor/rock/Initialize(mapload, no_update_icon)
	. = ..()
	set_turf_materials(material || get_strata_material_type() || /decl/material/solid/stone/sandstone, skip_update = no_update_icon)

/turf/floor/rock/volcanic
	name = "volcanic floor"
	material = /decl/material/solid/stone/basalt

/turf/floor/rock/basalt
	color = COLOR_DARK_GRAY
	material = /decl/material/solid/stone/basalt
