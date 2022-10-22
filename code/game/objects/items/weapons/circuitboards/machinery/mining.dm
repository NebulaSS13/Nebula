/obj/item/stock_parts/circuitboard/mining_processor
	name = "circuitboard (electric smelter)"
	build_path = /obj/machinery/material_processing/smeltery
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 2
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mining_compressor
	name = "circuitboard (material compressor)"
	build_path = /obj/machinery/material_processing/compressor
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 2
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mining_unloader
	name = "circuitboard (ore unloading machine)"
	build_path = /obj/machinery/material_processing/unloader
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mining_stacker
	name = "circuitboard (material stacking machine)"
	build_path = /obj/machinery/material_processing/stacker
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mining_extractor
	name = "circuitboard (gas extractor)"
	build_path = /obj/machinery/atmospherics/unary/material/extractor
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1,
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)