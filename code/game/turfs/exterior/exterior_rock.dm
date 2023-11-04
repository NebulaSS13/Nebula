/turf/exterior/rock
	name = "rock floor"
	icon = 'icons/turf/exterior/rock.dmi'
	icon_edge_layer = EXT_EDGE_VOLCANIC

/turf/exterior/rock/Initialize(mapload, no_update_icon)
	. = ..()
	material = SSmaterials.get_strata_material_type(src)
	if(material)
		var/decl/material/M = GET_DECL(material)
		name = "[M.adjective_name] floor"
		dirt_color = M.color
		color = M.color

/turf/exterior/rock/volcanic
	name = "volcanic floor"
	strata_override = /decl/strata/igneous