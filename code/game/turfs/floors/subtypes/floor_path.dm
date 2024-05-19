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
/* Uncomment when 515 is the required base version.
#define PATH_MATERIAL_SUBTYPES(material_name) \
/turf/floor/natural/path/##material_name { \
	color = TYPE_INITIAL(/decl/material/solid/stone/##material_name, color); \
	base_color = TYPE_INITIAL(/decl/material/solid/stone/##material_name, color); \
	material = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/natural/path/herringbone/##material_name { \
	color = TYPE_INITIAL(/decl/material/solid/stone/##material_name, color); \
	base_color = TYPE_INITIAL(/decl/material/solid/stone/##material_name, color); \
	material = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/natural/path/running_bond/##material_name { \
	color = TYPE_INITIAL(/decl/material/solid/stone/##material_name, color); \
	base_color = TYPE_INITIAL(/decl/material/solid/stone/##material_name, color); \
	material = /decl/material/solid/stone/##material_name; \
}
PATH_MATERIAL_SUBTYPES(basalt)
PATH_MATERIAL_SUBTYPES(granite)
PATH_MATERIAL_SUBTYPES(marble)
#undef PATH_MATERIAL_SUBTYPES
*/

/turf/floor/natural/path/basalt
	color      = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY
	material   = /decl/material/solid/stone/basalt

/turf/floor/natural/path/running_bond/basalt
	color      = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY
	material   = /decl/material/solid/stone/basalt

/turf/floor/natural/path/herringbone/basalt
	color      = COLOR_DARK_GRAY
	base_color = COLOR_DARK_GRAY
	material   = /decl/material/solid/stone/basalt

/turf/floor/natural/path/granite
	color      = "#615f5f"
	base_color = "#615f5f"
	material   = /decl/material/solid/stone/granite

/turf/floor/natural/path/running_bond/granite
	color      = "#615f5f"
	base_color = "#615f5f"
	material   = /decl/material/solid/stone/granite

/turf/floor/natural/path/herringbone/granite
	color      = "#615f5f"
	base_color = "#615f5f"
	material   = /decl/material/solid/stone/granite

/turf/floor/natural/path/marble
	color      = "#aaaaaa"
	base_color = "#aaaaaa"
	material   = /decl/material/solid/stone/marble

/turf/floor/natural/path/running_bond/marble
	color      = "#aaaaaa"
	base_color = "#aaaaaa"
	material   = /decl/material/solid/stone/marble

/turf/floor/natural/path/herringbone/marble
	color      = "#aaaaaa"
	base_color = "#aaaaaa"
	material   = /decl/material/solid/stone/marble
