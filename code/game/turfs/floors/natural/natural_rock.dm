/turf/floor/natural/rock
	name = "rock floor"
	icon = 'icons/turf/flooring/rock.dmi'
	icon_edge_layer = EXT_EDGE_VOLCANIC
	is_fundament_turf = TRUE

/turf/floor/natural/rock/Initialize(mapload, no_update_icon)
	material = material || SSmaterials.get_strata_material_type(src) || /decl/material/solid/stone/sandstone
	. = ..()

/turf/exterior/rock/update_from_material()
	if(istype(material))
		name       = "[material.adjective_name] [initial(name)]"
		base_color = material.color
	else
		name       = initial(name)
		base_color = initial(base_color)
	dirt_color = base_color
	color = base_color

/turf/exterior/rock/volcanic
	name = "volcanic floor"
	strata_override = /decl/strata/igneous
	material = /decl/material/solid/stone/basalt
