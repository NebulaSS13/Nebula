/decl/flooring/carpet
	name               = "brown carpet"
	desc               = "A stretch of cut pile carpet. Comfy and fancy."
	icon               = 'icons/turf/flooring/carpet.dmi'
	icon_base          = "brown"
	icon_edge_layer    = FLOOR_EDGE_CARPET
	build_type         = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flooring_flags     = TURF_REMOVE_CROWBAR
	can_engrave        = FALSE
	footstep_type      = /decl/footsteps/carpet
	force_material     = /decl/material/solid/organic/cloth
	constructed        = TRUE
	uid                = "floor_carpet"
	burned_states      = list(
		"burned0",
		"burned1"
	)
	broken_states      = list(
		"broken0",
		"broken1",
		"broken2",
		"broken3",
		"broken4"
	)

/decl/flooring/carpet/blue
	name               = "blue carpet"
	icon_base          = "blue1"
	build_type         = /obj/item/stack/tile/carpet/blue
	uid                = "floor_carpet_blue"

/decl/flooring/carpet/blue2
	name               = "pale blue carpet"
	icon_base          = "blue2"
	build_type         = /obj/item/stack/tile/carpet/blue2
	uid                = "floor_carpet_blue2"

/decl/flooring/carpet/blue3
	name               = "sea blue carpet"
	icon_base          = "blue3"
	build_type         = /obj/item/stack/tile/carpet/blue3
	uid                = "floor_carpet_blue3"

/decl/flooring/carpet/magenta
	name               = "magenta carpet"
	icon_base          = "purple"
	build_type         = /obj/item/stack/tile/carpet/magenta
	uid                = "floor_carpet_magenta"

/decl/flooring/carpet/purple
	name               = "purple carpet"
	icon_base          = "purple"
	build_type         = /obj/item/stack/tile/carpet/purple
	uid                = "floor_carpet_purple"

/decl/flooring/carpet/orange
	name               = "orange carpet"
	icon_base          = "orange"
	build_type         = /obj/item/stack/tile/carpet/orange
	uid                = "floor_carpet_orange"

/decl/flooring/carpet/green
	name               = "green carpet"
	icon_base          = "green"
	build_type         = /obj/item/stack/tile/carpet/green
	uid                = "floor_carpet_green"

/decl/flooring/carpet/red
	name               = "red carpet"
	icon_base          = "red"
	build_type         = /obj/item/stack/tile/carpet/red
	uid                = "floor_carpet_red"

/decl/flooring/carpet/rustic
	name               = "rustic carpet"
	desc               = "A stretch of simple woven carpet. Cozy, but a little itchy."
	icon               = 'icons/turf/flooring/simple_carpet.dmi'
	icon_base          = "carpet"
	build_type         = /obj/item/stack/tile/carpet/rustic
	can_paint          = TRUE
	color              = null
	broken_states      = null
	burned_states      = null
	uid                = "floor_carpet_rustic"
