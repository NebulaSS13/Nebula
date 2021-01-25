/obj/item/stock_parts/circuitboard/portable_scrubber
	name = "circuitboard (portable scrubber)"
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/scrubber
	origin_tech = "{'engineering':4,'powerstorage':4}"
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/pipe = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/cell = 1
	)

/obj/item/stock_parts/circuitboard/portable_scrubber/pump
	name = "circuitboard (portable pump)"
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/pump

/obj/item/stock_parts/circuitboard/portable_scrubber/huge
	name = "circuitboard (large portable scrubber)"
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/scrubber/huge
	origin_tech = "{'engineering':5,'powerstorage':5,'materials':5}"
	req_components = list(
							/obj/item/stock_parts/capacitor = 4,
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/pipe = 4)

/obj/item/stock_parts/circuitboard/portable_scrubber/huge/stationary
	name = "circuitboard (large stationary portable scrubber)"
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary

/obj/item/stock_parts/circuitboard/tray
	name = "circuitboard (hydroponics tray)"
	board_type = "machine"
	build_path = /obj/machinery/portable_atmospherics/hydroponics
	origin_tech = "{'biotech':3,'materials':2,'programming':1}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/chems/glass/beaker = 1,
		/obj/item/weedkiller = 1,
		/obj/item/pipe = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/dehumidifier
	name = "circuitboard (emergency dehumidifier)"
	board_type = "machine"
	build_path = /obj/machinery/dehumidifier
	origin_tech = "{'engineering':4,'powerstorage':4}"
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/pipe = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/cell = 1
	)

/obj/item/stock_parts/circuitboard/space_heater
	name = "circuitboard (space heater)"
	board_type = "machine"
	build_path = /obj/machinery/space_heater
	origin_tech = "{'engineering':4,'powerstorage':4}"
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/matter_bin = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/cell/high = 1
	)