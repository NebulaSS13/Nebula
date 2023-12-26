/obj/item/stock_parts/circuitboard/mainframe
	name = "circuitboard (mainframe)"
	build_path = /obj/machinery/network/mainframe
	board_type = "machine"
	origin_tech = "{'programming':2}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/computer/hard_drive/cluster/empty = 1
	)

/obj/item/stock_parts/circuitboard/acl
	name = "circuitboard (access controller)"
	build_path = /obj/machinery/network/acl
	board_type = "machine"
	origin_tech = "{'programming':2}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)

/obj/item/stock_parts/circuitboard/router
	name = "circuitboard (router)"
	build_path = /obj/machinery/network/router
	board_type = "machine"
	origin_tech = "{'programming':2,'magnets':3}"
	req_components = list(
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/micro_laser = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)

/obj/item/stock_parts/circuitboard/router/wall_mounted
	name = "circuitboard (wall-mounted router)"
	board_type = "wall"
	build_path = /obj/machinery/network/router/wall_mounted

/obj/item/stock_parts/circuitboard/relay
	name = "circuitboard (relay)"
	build_path = /obj/machinery/network/relay
	board_type = "machine"
	origin_tech = "{'programming':2,'magnets':2}"
	req_components = list(
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/scanning_module = 1,
		)

	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)

/obj/item/stock_parts/circuitboard/modem
	name = "circuitboard (modem)"
	build_path = /obj/machinery/network/modem
	board_type = "machine"
	origin_tech = "{'programming':2,'magnets':2}"
	req_components = list(
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/scanning_module = 1
		)

	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)

/obj/item/stock_parts/circuitboard/relay/wall_mounted
	name = "circuitboard (wall-mounted relay)"
	board_type = "wall"
	build_path = /obj/machinery/network/relay/wall_mounted

/obj/item/stock_parts/circuitboard/relay/long_range
	name = "circuitboard (long-ranged relay)"
	build_path = /obj/machinery/network/relay/long_range
	origin_tech = "{'programming':4,'magnets':5,'wormholes':5}"
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/amplifier = 1,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/subspace/transmitter = 1,
		/obj/item/stock_parts/micro_laser/high = 1
		)