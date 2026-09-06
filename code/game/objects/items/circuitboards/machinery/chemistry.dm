/obj/item/stock_parts/circuitboard/reagent_heater
	name = "circuitboard (hotplate)"
	build_path = /obj/machinery/reagent_temperature
	board_type = "machine"
	origin_tech = @'{"powerstorage":2,"engineering":1}'
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

/obj/item/stock_parts/circuitboard/chem_master
	name = "circuitboard (ChemMaster 3000)"
	build_path = /obj/machinery/chem_master
	board_type = "machine"
	origin_tech = @'{"biotech":2,"engineering":1}'
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/scanning_module = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/chemical_dispenser
	name = "circuitboard (chemical dispenser)"
	build_path = /obj/machinery/chemical_dispenser
	board_type = "machine"
	origin_tech = @'{"biotech":2,"engineering":1}'
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	buildtype_select = TRUE

/obj/item/stock_parts/circuitboard/chemical_dispenser/get_buildable_types()
	. = list()
	for(var/path in typesof(/obj/machinery/chemical_dispenser))
		var/obj/machinery/chemical_dispenser/chem_dispenser = path
		if(initial(chem_dispenser.buildable))
			. |= path