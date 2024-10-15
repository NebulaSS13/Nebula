/decl/flooring/reinforced
	name           = "reinforced floor"
	desc           = "Heavily reinforced with a latticework on top of regular plating."
	icon           = 'icons/turf/flooring/tiles.dmi'
	icon_base      = "reinforced"
	flooring_flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type     = /obj/item/stack/material/sheet
	build_material = /decl/material/solid/metal/steel
	build_cost     = 1
	build_time     = 30
	can_paint      = 1
	footstep_type  = /decl/footsteps/plating
	force_material = /decl/material/solid/metal/steel
	constructed    = TRUE
	gender         = NEUTER

/decl/flooring/reinforced/circuit
	name           = "processing strata"
	desc           = "A complex network of circuits beneath reinforced glass."
	icon           = 'icons/turf/flooring/circuit.dmi'
	icon_base      = "bcircuit"
	build_type     = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint      = 1
	can_engrave    = FALSE

/decl/flooring/reinforced/circuit/green
	icon_base      = "gcircuit"

/decl/flooring/reinforced/circuit/red
	icon_base      = "rcircuit"
	flooring_flags = TURF_ACID_IMMUNE
	can_paint      = 0

/decl/flooring/reinforced/shuttle
	name           = "floor"
	desc           = "A stretch of plastic shuttle flooring."
	icon           = 'icons/turf/flooring/shuttle.dmi'
	build_type     = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint      = 1
	can_engrave    = FALSE
	gender         = NEUTER

/decl/flooring/reinforced/shuttle/blue
	icon_base      = "floor"

/decl/flooring/reinforced/shuttle/yellow
	icon_base      = "floor2"

/decl/flooring/reinforced/shuttle/white
	icon_base      = "floor3"

/decl/flooring/reinforced/shuttle/red
	icon_base      = "floor4"

/decl/flooring/reinforced/shuttle/purple
	icon_base      = "floor5"

/decl/flooring/reinforced/shuttle/darkred
	icon_base      = "floor6"

/decl/flooring/reinforced/shuttle/black
	icon_base      = "floor7"
