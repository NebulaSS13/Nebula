// These need conversion to flooring decls but I am leaving it till after this PR.
/turf/floor/natural/path
	name = "path"
	gender = NEUTER
	desc = "A cobbled path made of loose stones."
	color = COLOR_GRAY
	base_color = COLOR_GRAY
	icon_edge_layer = EXT_EDGE_PATH
	icon = 'icons/turf/flooring/legacy/cobblestone.dmi'
	icon_state = "0"
	material = /decl/material/solid/stone/sandstone
	neighbour_type = /turf/floor/natural/path
//	initial_flooring = /decl/flooring/path/cobblestone
	// If null, this is just skipped.
	var/paving_adjective = "cobbled"
	var/paver_adjective = "loose"
	// This one should never be null.
	var/paver_noun = "stones"

/turf/floor/natural/path/Initialize(mapload, no_update_icon)
	. = ..()
	if(mapload && is_outside() && prob(20))
		var/image/moss = image('icons/effects/decals/plant_remains.dmi', "leafy_bits", DECAL_LAYER)
		moss.pixel_x = rand(-6, 6)
		moss.pixel_y = rand(-6, 6)
		if(prob(50))
			var/matrix/M = matrix()
			var/rot = pick(90, 270, 0, 0)
			if(rot)
				M.Turn(rot)
			else
				M.Scale(pick(-1, 1), pick(-1, 1))
			moss.transform = M
		LAZYADD(decals, moss)

/turf/floor/natural/path/update_from_material()
	SetName("[material.adjective_name] [initial(name)]")
	ASSERT(material?.adjective_name)
	ASSERT(paver_noun)
	desc = "[jointext_no_nulls(list("A", paving_adjective, "path made of", paver_adjective, material?.adjective_name, paver_noun), " ")]."

/turf/floor/natural/path/running_bond
	icon = 'icons/turf/flooring/legacy/running_bond.dmi'
	paving_adjective = null
	paver_adjective = "staggered"
	paver_noun = "bricks"
	icon_edge_layer = -1
//	initial_flooring = /decl/flooring/path/running_bond

/turf/floor/natural/path/herringbone
	icon = 'icons/turf/flooring/legacy/herringbone.dmi'
	paving_adjective = "herringbone"
	paver_adjective = null
	paver_noun = "bricks"
	icon_edge_layer = -1
//	initial_flooring = /decl/flooring/path/herringbone

// Material subtypes.
#define PATH_MATERIAL_SUBTYPES(material_name) \
/turf/floor/natural/path/##material_name { \
	color = /decl/material/solid/stone/##material_name::color; \
	base_color = /decl/material/solid/stone/##material_name::color; \
	material = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/natural/path/herringbone/##material_name { \
	color = /decl/material/solid/stone/##material_name::color; \
	base_color = /decl/material/solid/stone/##material_name::color; \
	material = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/natural/path/running_bond/##material_name { \
	color = /decl/material/solid/stone/##material_name::color; \
	base_color = /decl/material/solid/stone/##material_name::color; \
	material = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/natural/path/##material_name/water { \
	color = COLOR_SKY_BLUE; \
	reagent_type = /decl/material/liquid/water; \
	height = -(FLUID_SHALLOW); \
} \
/turf/floor/natural/path/##material_name/water/deep {\
	color = COLOR_BLUE; \
	height = -(FLUID_DEEP); \
} \
/turf/floor/natural/path/herringbone/##material_name/water { \
	color = COLOR_SKY_BLUE; \
	reagent_type = /decl/material/liquid/water; \
	height = -(FLUID_SHALLOW); \
} \
/turf/floor/natural/path/herringbone/##material_name/water/deep { \
	color = COLOR_BLUE; \
	height = -(FLUID_DEEP); \
} \
/turf/floor/natural/path/running_bond/##material_name/water { \
	color = COLOR_SKY_BLUE; \
	reagent_type = /decl/material/liquid/water; \
	height = -(FLUID_SHALLOW); \
} \
/turf/floor/natural/path/running_bond/##material_name/water/deep { \
	color = COLOR_BLUE; \
	height = -(FLUID_DEEP); \
}
PATH_MATERIAL_SUBTYPES(basalt)
PATH_MATERIAL_SUBTYPES(granite)
PATH_MATERIAL_SUBTYPES(marble)
PATH_MATERIAL_SUBTYPES(sandstone)
#undef PATH_MATERIAL_SUBTYPES