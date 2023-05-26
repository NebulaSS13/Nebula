/obj/item/stock_parts/circuitboard/message_server
	name = "circuitboard (message server)"
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/computer/network_card = 1
	)
	build_path = /obj/machinery/network/message_server
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 2,
		/obj/item/stock_parts/subspace/analyzer = 1
	)

/obj/item/stock_parts/circuitboard/telecomms_hub
	name = "circuitboard (telecommunications hub)"
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/computer/network_card = 1
	)
	build_path = /obj/machinery/network/telecomms_hub
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 1,
		/obj/item/stock_parts/subspace/analyzer = 1
	)

/obj/item/stock_parts/circuitboard/comms_maser
	name = "circuitboard (communications maser)"
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	build_path = /obj/machinery/shipcomms/broadcaster
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
		/obj/item/stack/cable_coil = 20,
		/obj/item/stock_parts/micro_laser/ultra = 5
	)

/obj/item/stock_parts/circuitboard/comms_antenna
	name = "circuitboard (communications antenna)"
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	build_path = /obj/machinery/shipcomms/receiver
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
		/obj/item/stack/cable_coil = 20,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 1,
		/obj/item/stock_parts/subspace/analyzer = 1
	)
