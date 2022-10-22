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
		/obj/item/stock_parts/computer/hard_drive/cluster/fullhouse
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
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/computer/card_slot = 1
	)

/obj/item/stock_parts/circuitboard/router
	name = "circuitboard (router)"
	build_path = /obj/machinery/network/router
	board_type = "machine"
	origin_tech = "{'wormholes':2,'programming':2}"
	req_components = list(
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/computer/network_card = 1
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
	origin_tech = "{'wormholes':2,'programming':2}"
	req_components = list(
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/computer/network_card = 1
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
	origin_tech = "{'wormholes':3,'programming':4}"
	req_components = list(
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/crystal = 2,
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/computer/network_card = 1
	)