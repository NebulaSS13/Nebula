/obj/item/stock_parts/circuitboard/telecomms
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/telecomms/receiver
	name = "circuitboard (subspace receiver)"
	build_path = /obj/machinery/telecomms/receiver
	origin_tech = "{'programming':4,'engineering':3,'wormholes':2}"
	req_components = list(
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/micro_laser = 1)

/obj/item/stock_parts/circuitboard/telecomms/hub
	name = "circuitboard (hub mainframe)"
	build_path = /obj/machinery/telecomms/hub
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 2)

/obj/item/stock_parts/circuitboard/telecomms/bus
	name = "circuitboard (bus mainframe)"
	build_path = /obj/machinery/telecomms/bus
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 1)

/obj/item/stock_parts/circuitboard/telecomms/processor
	name = "circuitboard (processor unit)"
	build_path = /obj/machinery/telecomms/processor
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
							/obj/item/stock_parts/manipulator = 3,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/treatment = 2,
							/obj/item/stock_parts/subspace/analyzer = 1,
							/obj/item/stock_parts/subspace/amplifier = 1)

/obj/item/stock_parts/circuitboard/telecomms/server
	name = "circuitboard (telecommunication server)"
	build_path = /obj/machinery/telecomms/server
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 1)

/obj/item/stock_parts/circuitboard/telecomms/broadcaster
	name = "circuitboard (subspace broadcaster)"
	build_path = /obj/machinery/telecomms/broadcaster
	origin_tech = "{'programming':4,'engineering':4,'wormholes':2}"
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/crystal = 1,
							/obj/item/stock_parts/micro_laser/high = 2)

/obj/item/stock_parts/circuitboard/telecomms/allinone
	name = "circuitboard (telecommunication mainframe)"
	build_path = /obj/machinery/telecomms/allinone
	origin_tech = "{'programming':3,'engineering':3}"
	req_components = list(
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/treatment = 2,
							/obj/item/stock_parts/subspace/analyzer = 1,
							/obj/item/stock_parts/subspace/amplifier = 1,
							/obj/item/stock_parts/subspace/crystal = 1)

/obj/item/stock_parts/circuitboard/telecomms/message_server
	name = "circuitboard (message server)"
	build_path = /obj/machinery/network/message_server
	origin_tech = "{'programming':4,'engineering':4}"
	req_components = list(
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/filter = 1,
							/obj/item/stock_parts/subspace/treatment = 2,
							/obj/item/stock_parts/subspace/analyzer = 1)