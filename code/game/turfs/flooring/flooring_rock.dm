/decl/flooring/rock
	name            = "rock floor"
	desc            = "An expanse of bare rock."
	icon            = 'icons/turf/flooring/rock.dmi'
	icon_base       = "rock"
	has_base_range  = null
	color           = null
	icon_edge_layer = FLOOR_EDGE_VOLCANIC
	gender          = NEUTER
	uid             = "floor_reinf_shuttle_rock"

/decl/flooring/rock/update_turf_strings(turf/floor/target)
	var/decl/material/turf_material = target?.get_material()
	ASSERT(turf_material?.adjective_name)
	target.SetName("[turf_material.adjective_name] [name]")
	target.desc = "An expanse of bare [turf_material.solid_name]."
