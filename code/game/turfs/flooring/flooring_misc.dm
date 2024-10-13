/decl/flooring/linoleum
	name               = "linoleum"
	desc               = "A stretch of inlaid sections of flexible linoleum."
	icon               = 'icons/turf/flooring/linoleum.dmi'
	icon_base          = "lino"
	can_paint          = 1
	build_type         = /obj/item/stack/tile/linoleum
	flooring_flags     = TURF_REMOVE_SCREWDRIVER
	footstep_type      = /decl/footsteps/tiles
	force_material     = /decl/material/solid/organic/plastic
	constructed        = TRUE

/decl/flooring/crystal
	name               = "crystal flooring"
	desc               = "A hard, reflective section of flooring made from crystal."
	icon               = 'icons/turf/flooring/crystal.dmi'
	icon_base          = "crystal"
	build_type         = null
	flooring_flags     = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	color              = "#00ffe1"
	force_material     = /decl/material/solid/gemstone/crystal
	constructed        = TRUE

/decl/flooring/glass
	name               = "glass flooring"
	desc               = "A window to the world outside. Or the world beneath your feet, rather."
	icon               = 'icons/turf/flooring/glass.dmi'
	icon_base          = "glass"
	build_type         = /obj/item/stack/material/pane
	build_material     = /decl/material/solid/glass
	build_cost         = 1
	build_time         = 30
	damage_temperature = T100C
	flooring_flags     = TURF_REMOVE_CROWBAR | TURF_ACID_IMMUNE
	can_engrave        = FALSE
	color              = GLASS_COLOR
	z_flags            = ZM_MIMIC_DEFAULTS
	footstep_type      = /decl/footsteps/plating
	force_material     = /decl/material/solid/glass
	constructed        = TRUE

/decl/flooring/glass/boro
	name               = "borosilicate glass flooring"
	build_material     = /decl/material/solid/glass/borosilicate
	color              = GLASS_COLOR_SILICATE
	damage_temperature = T0C + 4000
	force_material     = /decl/material/solid/glass/borosilicate

/decl/flooring/pool
	name               = "pool floor"
	desc               = "Sunken flooring designed to hold liquids."
	icon               = 'icons/turf/flooring/pool.dmi'
	icon_base          = "pool"
	build_type         = /obj/item/stack/tile/pool
	flooring_flags     = TURF_REMOVE_CROWBAR
	footstep_type      = /decl/footsteps/tiles
	render_trenches    = FALSE
	force_material     = /decl/material/solid/stone/ceramic
	constructed        = TRUE
	gender             = NEUTER

/decl/flooring/woven
	name               = "woven floor"
	desc               = "A rustic woven mat."
	icon               = 'icons/turf/flooring/woven.dmi'
	icon_base          = "woven"
	damage_temperature = T0C+80
	flooring_flags     = TURF_REMOVE_CROWBAR
	build_type         = /obj/item/stack/tile/woven
	can_engrave        = FALSE
	color              = COLOR_BEIGE
	force_material     = /decl/material/solid/organic/plantmatter/grass/dry
	constructed        = TRUE
	gender             = NEUTER

/decl/flooring/straw
	name               = "straw floor"
	desc               = "A thick layer of straw, suitable for livestock."
	icon               = 'icons/turf/flooring/wildgrass.dmi' // temporary, replace with better icon at some point
	icon_base          = "wildgrass"
	has_base_range     = null
	icon_edge_layer    = FLOOR_EDGE_GRASS_WILD
	damage_temperature = T0C+80
	flooring_flags     = TURF_REMOVE_CROWBAR
	can_engrave        = FALSE
	color              = COLOR_WHEAT
	force_material     = /decl/material/solid/organic/plantmatter/grass/dry
	constructed        = TRUE
	gender             = NEUTER
