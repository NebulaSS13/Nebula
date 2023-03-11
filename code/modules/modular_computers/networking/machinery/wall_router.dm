/obj/machinery/network/router/wall_mounted
	name = "wall-mounted network router"
	icon = 'icons/obj/machines/wall_router.dmi'
	icon_state = "wall_router"
	frame_type = /obj/item/frame/wall_router
	construct_state = /decl/machine_construction/wall_frame/panel_closed
	density = FALSE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	base_type = /obj/machinery/network/router/wall_mounted
	directional_offset = @'{"NORTH":{"y":-21}, "SOUTH":{"y":21}, "EAST":{"x":-21}, "WEST":{"x":21}}'

/obj/machinery/network/router/wall_mounted/Initialize()
	. = ..()
	queue_icon_update()
