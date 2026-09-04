/obj/abstract/force_fluid_flow
	icon_state = "arrow"

/obj/abstract/force_fluid_flow/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/force_fluid_flow/north
	dir = NORTH

/obj/abstract/force_fluid_flow/south
	dir = SOUTH

/obj/abstract/force_fluid_flow/east
	dir = EAST

/obj/abstract/force_fluid_flow/west
	dir = WEST

/obj/abstract/force_fluid_flow/southeast
	dir = SOUTHEAST

/obj/abstract/force_fluid_flow/southwest
	dir = SOUTHWEST

/obj/abstract/force_fluid_flow/northeast
	dir = NORTHEAST

/obj/abstract/force_fluid_flow/northwest
	dir = NORTHWEST

/obj/abstract/force_fluid_flow/LateInitialize()
	. = ..()
	var/atom/movable/fluid_overlay/fluids = locate() in loc
	fluids.force_flow_direction = dir
	fluids.queue_icon_update()
	qdel(src)
