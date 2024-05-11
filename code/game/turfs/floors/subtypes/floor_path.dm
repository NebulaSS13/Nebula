// These need conversion to flooring decls but I am leaving it till after this PR.
/turf/floor/natural/path
	name = "path"
	gender = NEUTER
	desc = "A cobbled path made of loose stones."
	color = COLOR_GRAY
	base_color = COLOR_GRAY
	icon = 'icons/turf/flooring/legacy/cobblestone.dmi'
	icon_state = "0"
	material = /decl/material/solid/stone/sandstone
//	initial_flooring = /decl/flooring/path/cobblestone
	// If null, this is just skipped.
	var/paving_adjective = "cobbled"
	var/paver_adjective = "loose"
	// This one should never be null.
	var/paver_noun = "stones"

/turf/floor/natural/path/update_from_material()
	SetName("[material.adjective_name] [initial(name)]")
	ASSERT(material?.adjective_name)
	ASSERT(paver_noun)
	desc = "[jointext_no_nulls(list("A", paving_adjective, "path made of", paver_adjective, material?.adjective_name, paver_noun), " ")]."

/turf/floor/natural/path/running_bond
	icon = 'icons/turf/flooring/legacy/running_bond.dmi'
	icon_edge_layer = -1
	paving_adjective = null
	paver_adjective = "staggered"
	paver_noun = "bricks"
//	initial_flooring = /decl/flooring/path/running_bond

/turf/floor/natural/path/herringbone
	icon = 'icons/turf/flooring/legacy/herringbone.dmi'
	icon_edge_layer = -1
	paving_adjective = "herringbone"
	paver_adjective = null
	paver_noun = "bricks"
//	initial_flooring = /decl/flooring/path/herringbone

// Material subtypes.
/turf/floor/natural/path/basalt
	color = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY
	material = /decl/material/solid/stone/basalt

/turf/floor/natural/path/herringbone/basalt
	color = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY
	material = /decl/material/solid/stone/basalt

/turf/floor/natural/path/running_bond/basalt
	color = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY
	material = /decl/material/solid/stone/basalt
