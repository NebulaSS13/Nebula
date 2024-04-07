/decl/flooring/fake_grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/fakegrass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass
	can_engrave = FALSE
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	decal_layer = ABOVE_WIRE_LAYER

/decl/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2090's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flags = TURF_REMOVE_SCREWDRIVER
	footstep_type = /decl/footsteps/tiles

/decl/flooring/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	icon_base  = "crystal"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	color = "#00ffe1"

/decl/flooring/glass
	name = "glass flooring"
	desc = "A window to the world outside. Or the world beneath your feet, rather."
	icon = 'icons/turf/flooring/glass.dmi'
	icon_base = "glass"
	build_type = /obj/item/stack/material/pane
	build_material = /decl/material/solid/glass
	build_cost = 1
	build_time = 30
	damage_temperature = T100C
	flags = TURF_REMOVE_CROWBAR | TURF_ACID_IMMUNE
	can_engrave = FALSE
	color = GLASS_COLOR
	z_flags = ZM_MIMIC_DEFAULTS
	footstep_type = /decl/footsteps/plating

/decl/flooring/glass/boro
	name = "borosilicate glass flooring"
	build_material = /decl/material/solid/glass/borosilicate
	color = GLASS_COLOR_SILICATE
	damage_temperature = T0C + 4000

/decl/flooring/pool
	name = "pool floor"
	desc = "Sunken flooring designed to hold liquids."
	icon = 'icons/turf/flooring/pool.dmi'
	icon_base = "pool"
	build_type = /obj/item/stack/tile/pool
	flags = TURF_REMOVE_CROWBAR
	footstep_type = /decl/footsteps/tiles
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	height = -(FLUID_OVER_MOB_HEAD) - 50
	render_trenches = FALSE

/decl/flooring/pool/deep
	height = -FLUID_DEEP - 50

/decl/flooring/woven
	name = "woven floor"
	desc = "A rustic woven mat."
	icon = 'icons/turf/flooring/woven.dmi'
	icon_base = "woven"
	damage_temperature = T0C+80
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/woven
	can_engrave = FALSE
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	decal_layer = ABOVE_WIRE_LAYER
	color = COLOR_BEIGE
