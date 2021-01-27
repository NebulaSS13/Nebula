/obj/item/stock_parts/circuitboard/reagent_heater
	name = "circuitboard (chemical heater)"
	build_path = /obj/machinery/reagent_temperature
	board_type = "machine"
	origin_tech = "{'powerstorage':2,'engineering':1}"
	req_components = list(
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/reagent_heater/cooler
	name = "circuitboard (chemical cooler)"
	build_path = /obj/machinery/reagent_temperature/cooler
