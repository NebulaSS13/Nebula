/obj/item/stock_parts/circuitboard/docking_beacon
	name = "circuitboard (magnetic docking beacon)"
	board_type = "machine"
	build_path = /obj/machinery/docking_beacon
	origin_tech = "{'magnets':3}"
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
