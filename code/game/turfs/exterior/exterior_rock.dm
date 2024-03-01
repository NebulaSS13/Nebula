/turf/exterior/rock
	name = "rock floor"
	icon = 'icons/turf/flooring/rock.dmi'
	icon_state = "rock"
	flooring_layers = /decl/flooring/rock

/turf/exterior/rock/volcanic
	name = "volcanic floor"
	strata_override = /decl/strata/igneous

/decl/flooring/rock
	name = "rock floor"
	icon_edge_layer = EXT_EDGE_VOLCANIC
	icon_base = "rock"
	icon = 'icons/turf/flooring/rock.dmi'

/decl/flooring/rock/apply_appearance_to(var/turf/target)
	..()
	var/turf/exterior/ext = target
	if(istype(ext))
		ext.dirt_color = get_apply_color(ext)
	var/decl/material/material = GET_DECL(SSmaterials.get_strata_material_type(target))
	if(material)
		target.SetName("[material.adjective_name] floor")

/decl/flooring/rock/get_apply_color(var/turf/target)
	var/decl/material/material = GET_DECL(SSmaterials.get_strata_material_type(target))
	return material?.color || color
