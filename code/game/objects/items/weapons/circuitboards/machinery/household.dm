/obj/item/stock_parts/circuitboard/microwave
	name = T_BOARD("microwave")
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = "{'biotech':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/gibber
	name = T_BOARD("meat gibber")
	build_path = /obj/machinery/gibber
	board_type = "machine"
	origin_tech = "{'biotech':2,'materials':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/material/knife/kitchen/cleaver = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cooker
	name = T_BOARD("candy machine")
	build_path = /obj/machinery/cooker/candy
	board_type = "machine"
	origin_tech = "{'biotech':1,'materials':1}"
	buildtype_select = TRUE
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stack/cable_coil = 10)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cooker/get_buildable_types()
	return subtypesof(/obj/machinery/cooker)

/obj/item/stock_parts/circuitboard/honey
	name = T_BOARD("honey extractor")
	build_path = /obj/machinery/honey_extractor
	board_type = "machine"
	origin_tech = "{'biotech':2,'engineering':1}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)

/obj/item/stock_parts/circuitboard/honey/seed
	name = T_BOARD("seed extractor")
	build_path = /obj/machinery/seed_extractor
	board_type = "machine"

/obj/item/stock_parts/circuitboard/seed_storage
	name = T_BOARD("seed storage")
	build_path = /obj/machinery/seed_storage
	board_type = "machine"
	origin_tech = "{'biotech':2,'engineering':3}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/seed_storage/advanced
	name = T_BOARD("seed storage (scientific)")
	build_path = /obj/machinery/seed_storage/xenobotany/buildable
	origin_tech = "{'biotech':6,'engineering':3}"

/obj/item/stock_parts/circuitboard/washer
	name = T_BOARD("washing machine")
	build_path = /obj/machinery/washing_machine
	board_type = "machine"
	origin_tech = "{'engineering':1}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/pipe = 1)

/obj/item/stock_parts/circuitboard/vending
	name = T_BOARD("vending machine")
	build_path = /obj/machinery/vending/assist
	board_type = "machine"
	origin_tech = "{'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	buildtype_select = TRUE

/obj/item/stock_parts/circuitboard/vending/get_buildable_types()
	. = list()
	for(var/path in typesof(/obj/machinery/vending))
		var/obj/machinery/vending/vendor = path
		var/base_type = initial(vendor.base_type) || path
		. |= base_type

/obj/item/stock_parts/circuitboard/grinder
	name = T_BOARD("industrial grinder")
	build_path = /obj/machinery/reagentgrinder
	board_type = "machine"
	origin_tech = "{'magnets':2,'materials':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/juicer
	name = T_BOARD("blender")
	build_path = /obj/machinery/reagentgrinder/juicer
	board_type = "machine"
	origin_tech = "{'magnets':2,'materials':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/ice_cream
	name = T_BOARD("ice cream vat")
	build_path = /obj/machinery/icecream_vat
	board_type = "machine"
	origin_tech = "{'engineering':1}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/pipe = 1
	)

/obj/item/stock_parts/circuitboard/fridge
	name = T_BOARD("smartfridge")
	build_path = /obj/machinery/smartfridge
	board_type = "machine"
	origin_tech = "{'engineering':3}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	buildtype_select = TRUE

/obj/item/stock_parts/circuitboard/fridge/get_buildable_types()
	return typesof(/obj/machinery/smartfridge)

/obj/item/stock_parts/circuitboard/jukebox
	name = T_BOARD("jukebox")
	build_path = /obj/machinery/media/jukebox
	board_type = "machine"
	origin_tech = "{'programming':5}"
	req_components = list(
		/obj/item/stock_parts/subspace/amplifier = 2
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	buildtype_select = TRUE

/obj/item/stock_parts/circuitboard/jukebox/get_buildable_types()
	return typesof(/obj/machinery/media/jukebox)