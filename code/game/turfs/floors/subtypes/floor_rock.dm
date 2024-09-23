/turf/floor/rock
	name           = "rock floor"
	icon           = 'icons/turf/flooring/rock.dmi'
	icon_state     = "rock"
	_base_flooring = /decl/flooring/rock

/turf/floor/rock/Initialize(mapload, no_update_icon)
	. = ..()
	set_turf_materials(floor_material || get_strata_material_type() || /decl/material/solid/stone/sandstone, skip_update = no_update_icon)

/turf/floor/rock/volcanic
	name           = "volcanic floor"
	floor_material = /decl/material/solid/stone/basalt

/turf/floor/rock/basalt
	color          = /decl/material/solid/stone/basalt::color
	floor_material = /decl/material/solid/stone/basalt
