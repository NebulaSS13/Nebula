/obj/structure/shuttle
	name = "shuttle"
	abstract_type = /obj/structure/shuttle

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/structures/podwindows.dmi'
	icon_state = "1"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	atmos_canpass = CANPASS_DENSITY

/obj/structure/shuttle/engine
	name = "engine"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/shuttle_engine.dmi'
	abstract_type = /obj/structure/shuttle/engine

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = TRUE

/obj/structure/shuttle/engine/propulsion/left
	icon_state = "propulsion_l"

/obj/structure/shuttle/engine/propulsion/right
	icon_state = "propulsion_r"

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"
