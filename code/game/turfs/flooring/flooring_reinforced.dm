/decl/flooring/reinforced
	name           = "reinforced floor"
	desc           = "Heavily reinforced with a latticework on top of regular plating."
	icon           = 'icons/turf/flooring/tiles.dmi'
	icon_base      = "reinforced"
	flooring_flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type     = /obj/item/stack/material/sheet
	build_material = /decl/material/solid/metal/steel
	build_cost     = 1
	build_time     = 3 SECONDS
	can_paint      = TRUE
	force_material = /decl/material/solid/metal/steel
	constructed    = TRUE
	gender         = NEUTER
	burned_states  = list(
		"burned0",
		"burned1"
	)
	broken_states  = list(
		"broken0",
		"broken1",
		"broken2",
		"broken3",
		"broken4"
	)
	uid            = "floor_reinf"
	deconstruct_sound = 'sound/items/Deconstruct.ogg'

/decl/flooring/reinforced/circuit
	name           = "processing strata"
	desc           = "A complex network of circuits beneath reinforced glass."
	icon           = 'icons/turf/flooring/circuit.dmi'
	icon_base      = "bcircuit"
	build_type     = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_REMOVE_WRENCH
	can_paint      = TRUE
	can_engrave    = FALSE
	turf_light_range = 2
	turf_light_power = 3
	turf_light_color = COLOR_BLUE
	uid            = "floor_reinf_circ"

/decl/flooring/reinforced/circuit/green
	icon_base        = "gcircuit"
	turf_light_color = COLOR_GREEN
	uid            = "floor_reinf_gcirc"

/decl/flooring/reinforced/circuit/red
	icon_base        = "rcircuit"
	flooring_flags   = TURF_ACID_IMMUNE
	can_paint        = FALSE
	turf_light_power = 2
	turf_light_color = COLOR_RED
	uid            = "floor_reinf_rcirc"

/decl/flooring/reinforced/shuttle
	name           = "floor"
	desc           = "A stretch of plastic shuttle flooring."
	icon           = 'icons/turf/flooring/shuttle.dmi'
	build_type     = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_REMOVE_CROWBAR
	can_paint      = TRUE
	can_engrave    = FALSE
	gender         = NEUTER
	uid            = "floor_reinf_shuttle"

/decl/flooring/reinforced/shuttle/blue
	icon_base      = "floor"
	uid            = "floor_reinf_shuttle_blue"

/decl/flooring/reinforced/shuttle/yellow
	icon_base      = "floor2"
	uid            = "floor_reinf_shuttle_yellow"

/decl/flooring/reinforced/shuttle/white
	icon_base      = "floor3"
	uid            = "floor_reinf_shuttle_white"

/decl/flooring/reinforced/shuttle/red
	icon_base      = "floor4"
	uid            = "floor_reinf_shuttle_red"

/decl/flooring/reinforced/shuttle/purple
	icon_base      = "floor5"
	uid            = "floor_reinf_shuttle_purple"

/decl/flooring/reinforced/shuttle/darkred
	icon_base      = "floor6"
	uid            = "floor_reinf_shuttle_darkred"

/decl/flooring/reinforced/shuttle/black
	icon_base      = "floor7"
	uid            = "floor_reinf_shuttle_black"
