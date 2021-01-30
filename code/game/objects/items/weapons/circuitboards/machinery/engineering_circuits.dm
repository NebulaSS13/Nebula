/obj/item/stock_parts/circuitboard/floodlight
	name = "circuitboard (emergency floodlight)"
	build_path = /obj/machinery/floodlight
	board_type = "machine"
	origin_tech = "{'engineering':1}"
	req_components = list(
		/obj/item/stack/cable_coil = 10)
	additional_spawn_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/power/battery/buildable/crap = 1,
		/obj/item/cell/crap = 1)

/obj/item/stock_parts/circuitboard/pipedispensor
	name = "circuitboard (pipe dispenser)"
	build_path = /obj/machinery/fabricator/pipe
	board_type = "machine"
	origin_tech = "{'engineering':6,'materials':5}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/rcd_ammo/large = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1)

/obj/item/stock_parts/circuitboard/pipedispensor/disposal
	name = "circuitboard (disposal pipe dispenser)"
	build_path = /obj/machinery/fabricator/pipe/disposal

/obj/item/stock_parts/circuitboard/suit_cycler
	name = "circuitboard (suit cycler)"
	build_path = /obj/machinery/suit_cycler
	board_type = "machine"
	origin_tech = "{'engineering':4,'materials':4}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	buildtype_select = TRUE

/obj/item/stock_parts/circuitboard/suit_cycler/get_buildable_types()
	. = list()
	for(var/path in typesof(/obj/machinery/suit_cycler))
		var/obj/machinery/suit_cycler/suit = path
		if(initial(suit.buildable))
			. |= path