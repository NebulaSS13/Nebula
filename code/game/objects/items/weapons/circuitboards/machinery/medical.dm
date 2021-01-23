/obj/item/stock_parts/circuitboard/optable
	name = "circuitboard (operating table)"
	build_path = /obj/machinery/optable
	board_type = "machine"
	origin_tech = "{'engineering':1,'biotech':3,'programming':3}"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor  = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/bodyscanner
	name = "circuitboard (body scanner)"
	build_path = /obj/machinery/bodyscanner
	board_type = "machine"
	origin_tech = "{'engineering':2,'biotech':4,'programming':4}"
	req_components = list(
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/console_screen = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/body_scanconsole
	name = "circuitboard (body scanner console)"
	build_path = /obj/machinery/body_scanconsole
	board_type = "machine"
	origin_tech = "{'engineering':2,'biotech':4,'programming':4}"
	req_components = list(
		/obj/item/stock_parts/console_screen = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/body_scanconsole/display
	name = "circuitboard (body scanner display)"
	build_path = /obj/machinery/body_scan_display
	origin_tech = "{'biotech':2,'programming':2}"

/obj/item/stock_parts/circuitboard/sleeper
	name = "circuitboard (sleeper)"
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = "{'engineering':3,'biotech':5,'programming':3}"
	req_components = list (
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/chems/syringe = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
