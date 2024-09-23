
/turf/floor/path
	name           = "path"
	gender         = NEUTER
	desc           = "A cobbled path made of loose stones."
	color          = COLOR_GRAY
	icon           = 'icons/turf/flooring/path.dmi'
	icon_state     = "cobble"
	_flooring      = /decl/flooring/path/cobblestone
	floor_material = /decl/material/solid/stone/sandstone
	_base_flooring = /decl/flooring/dirt

/turf/floor/path/Initialize(mapload, no_update_icon)
	. = ..()
	set_turf_materials(floor_material || get_strata_material_type() || /decl/material/solid/stone/sandstone, skip_update = no_update_icon)
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

/turf/floor/path/running_bond
	icon_state = "runningbond"
	_flooring = /decl/flooring/path/running_bond

/turf/floor/path/herringbone
	icon_state = "herringbone"
	_flooring = /decl/flooring/path/herringbone

// Material subtypes.
#define PATH_MATERIAL_SUBTYPES(material_name) \
/turf/floor/path/##material_name { \
	color             = /decl/material/solid/stone/##material_name::color; \
	floor_material    = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/path/herringbone/##material_name { \
	color             = /decl/material/solid/stone/##material_name::color; \
	floor_material    = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/path/running_bond/##material_name { \
	color             = /decl/material/solid/stone/##material_name::color; \
	floor_material    = /decl/material/solid/stone/##material_name; \
} \
/turf/floor/path/##material_name/water { \
	color             = COLOR_SKY_BLUE; \
	fill_reagent_type = /decl/material/liquid/water; \
	height            = -(FLUID_SHALLOW); \
} \
/turf/floor/path/##material_name/water/deep {\
	color             = COLOR_BLUE; \
	height            = -(FLUID_DEEP); \
} \
/turf/floor/path/herringbone/##material_name/water { \
	color             = COLOR_SKY_BLUE; \
	fill_reagent_type = /decl/material/liquid/water; \
	height            = -(FLUID_SHALLOW); \
} \
/turf/floor/path/herringbone/##material_name/water/deep { \
	color             = COLOR_BLUE; \
	height            = -(FLUID_DEEP); \
} \
/turf/floor/path/running_bond/##material_name/water { \
	color             = COLOR_SKY_BLUE; \
	fill_reagent_type = /decl/material/liquid/water; \
	height            = -(FLUID_SHALLOW); \
} \
/turf/floor/path/running_bond/##material_name/water/deep { \
	color             = COLOR_BLUE; \
	height            = -(FLUID_DEEP); \
}
PATH_MATERIAL_SUBTYPES(basalt)
PATH_MATERIAL_SUBTYPES(granite)
PATH_MATERIAL_SUBTYPES(marble)
PATH_MATERIAL_SUBTYPES(sandstone)
#undef PATH_MATERIAL_SUBTYPES