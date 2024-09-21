/decl/flooring/rock
	name            = "rock floor"
	desc            = "An expanse of bare rock."
	icon            = 'icons/turf/flooring/rock.dmi'
	icon_base       = "rock"
	has_base_range  = null
	color           = null
	icon_edge_layer = FLOOR_EDGE_VOLCANIC

/decl/flooring/rock/update_turf_strings(turf/floor/target)
	var/decl/material/material = target?.get_material()
	ASSERT(material?.adjective_name)
	target.SetName("[material.adjective_name] [name]")
	target.desc = "An expanse of bare [material.solid_name]."
