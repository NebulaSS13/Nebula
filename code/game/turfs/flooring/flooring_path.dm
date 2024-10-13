/decl/flooring/path
	abstract_type  = /decl/flooring/path
	icon           = 'icons/turf/flooring/path.dmi'
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type     = null
	can_engrave    = TRUE
	neighbour_type = /decl/flooring/path
	color          = null
	constructed    = TRUE
	// If null, this is just skipped.
	var/paving_adjective = "cobbled"
	var/paver_adjective = "loose"
	// This one should never be null.
	var/paver_noun = "stones"

/decl/flooring/path/update_turf_strings(turf/floor/target)
	var/decl/material/material = target?.get_material()
	ASSERT(material?.adjective_name)
	ASSERT(paver_noun)
	target.SetName("[material.adjective_name] [name]")
	target.desc = "[jointext_no_nulls(list("A", paving_adjective, "path made of", paver_adjective, material.adjective_name, paver_noun), " ")]."

/decl/flooring/path/cobblestone
	name            = "cobblestones"
	desc            = "A rustic cobblestone path."
	icon_base       = "cobble"
	icon_edge_layer = FLOOR_EDGE_PATH
	flooring_flags  = TURF_REMOVE_CROWBAR

/decl/flooring/path/running_bond
	name           = "stone path"
	desc           = "A rustic stone path, laid out in a running bond pattern."
	icon_base      = "runningbond"
	gender         = NEUTER

/decl/flooring/path/herringbone
	name           = "stone path"
	desc           = "A rustic stone path, laid out in a herringbone pattern."
	icon_base      = "herringbone"
	gender         = NEUTER
