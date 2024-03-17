/turf/exterior/rock
	name = "rock floor"
	icon = 'icons/turf/exterior/rock.dmi'
	icon_edge_layer = EXT_EDGE_VOLCANIC

/turf/exterior/rock/can_be_dug()
	return FALSE

/turf/exterior/rock/Initialize(mapload, no_update_icon)
	. = ..()
	set_turf_materials(material || SSmaterials.get_strata_material_type(src) || /decl/material/solid/stone/sandstone, skip_update = no_update_icon)

/turf/exterior/rock/volcanic
	name = "volcanic floor"
	strata_override = /decl/strata/igneous
