/obj/item/stock_parts/circuitboard/microwave
	name = "circuitboard (microwave)"
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = @'{"biotech":2,"engineering":2}'
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
	name = "circuitboard (meat gibber)"
	build_path = /obj/machinery/gibber
	board_type = "machine"
	origin_tech = @'{"biotech":2,"materials":2}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/knife/kitchen/cleaver = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cooker
	name = "circuitboard (candy machine)"
	build_path = /obj/machinery/cooker/candy
	board_type = "machine"
	origin_tech = @'{"biotech":1,"materials":1}'
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

/obj/item/stock_parts/circuitboard/seed_storage
	name = "circuitboard (seed storage)"
	build_path = /obj/machinery/seed_storage
	board_type = "machine"
	origin_tech = @'{"biotech":2,"engineering":3}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/seed_storage/advanced
	name = "circuitboard (seed storage (scientific))"
	build_path = /obj/machinery/seed_storage/xenobotany/buildable
	origin_tech = @'{"biotech":6,"engineering":3}'

/obj/item/stock_parts/circuitboard/washer
	name = "circuitboard (washing machine)"
	build_path = /obj/machinery/washing_machine
	board_type = "machine"
	origin_tech = @'{"engineering":1}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/pipe = 1)

/obj/item/stock_parts/circuitboard/autoclave
	name = "circuitboard (autoclave)"
	build_path = /obj/machinery/washing_machine/autoclave
	board_type = "machine"
	origin_tech = @'{"engineering":3, "biotech":2}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/pipe = 1)

/obj/item/stock_parts/circuitboard/vending
	name = "circuitboard (vending machine)"
	build_path = /obj/machinery/vending/assist
	board_type = "machine"
	origin_tech = @'{"engineering":2}'
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
	name = "circuitboard (industrial grinder)"
	build_path = /obj/machinery/reagentgrinder
	board_type = "machine"
	origin_tech = @'{"magnets":2,"materials":4,"engineering":4}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/juicer
	name = "circuitboard (blender)"
	build_path = /obj/machinery/reagentgrinder/juicer
	board_type = "machine"
	origin_tech = @'{"magnets":2,"materials":2,"engineering":2}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/matter_bin = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/ice_cream
	name = "circuitboard (ice cream vat)"
	build_path = /obj/machinery/icecream_vat
	board_type = "machine"
	origin_tech = @'{"engineering":1}'
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/pipe = 1
	)

/obj/item/stock_parts/circuitboard/fridge
	name = "circuitboard (smartfridge)"
	build_path = /obj/machinery/smartfridge
	board_type = "machine"
	origin_tech = @'{"engineering":3}'
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
	name = "circuitboard (jukebox)"
	build_path = /obj/machinery/media/jukebox
	board_type = "machine"
	origin_tech = @'{"programming":5}'
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

/obj/item/stock_parts/circuitboard/paper_shredder
	name = "circuitboard (paper shredder)"
	build_path = /obj/machinery/papershredder
	board_type = "machine"
	origin_tech = @'{"engineering":1}'
	req_components = list(/obj/item/stock_parts/manipulator = 1)
	additional_spawn_components = null