/turf/floor/rock
	name           = "rock floor"
	icon           = 'icons/turf/flooring/rock.dmi'
	icon_state     = "rock"
	_base_flooring = /decl/flooring/rock

/turf/floor/rock/Initialize(mapload, no_update_icon)
	// Take advantage of the set_turf_materials call in ..()
	material ||= get_strata_material_type() || /decl/material/solid/stone/sandstone
	. = ..()

/turf/floor/rock/volcanic
	name     = "volcanic floor"
	material = /decl/material/solid/stone/basalt
