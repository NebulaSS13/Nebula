/obj/item/stock_parts/circuitboard/turret
	name = T_BOARD("turret")
	build_path = /obj/machinery/turret
	board_type = "machine"
	origin_tech = "{'programming':6,'combat':5}"
	req_components = list(
		/obj/item/stock_parts/weapon_control_system
	)
	spawn_components = list(
		/obj/item/stock_parts/weapon_control_system/egun
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)

/obj/item/stock_parts/circuitboard/turret/remote
	name = T_BOARD("remote turret")
	build_path = /obj/machinery/turret/remote
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)
