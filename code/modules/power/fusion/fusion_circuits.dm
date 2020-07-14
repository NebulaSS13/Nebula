/obj/item/stock_parts/circuitboard/fusion/core_control
	name = T_BOARD("fusion core controller")
	build_path = /obj/machinery/computer/fusion/core_control
	origin_tech = "{'programming':4,'engineering':4}"

/obj/item/stock_parts/circuitboard/kinetic_harvester
	name = T_BOARD("kinetic harvester")
	build_path = /obj/machinery/kinetic_harvester
	board_type = "machine"
	origin_tech = "{'programming':4,'engineering':4,'materials':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator/pico = 2,
		/obj/item/stock_parts/matter_bin/super = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
		)

/obj/item/stock_parts/circuitboard/fusion_fuel_compressor
	name = T_BOARD("fusion fuel compressor")
	build_path = /obj/machinery/fusion_fuel_compressor
	board_type = "machine"
	origin_tech = "{'powerstorage':3,'engineering':4,'materials':4}"
	req_components = list(
							/obj/item/stock_parts/manipulator/pico = 2,
							/obj/item/stock_parts/matter_bin/super = 2,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/fusion_fuel_control
	name = T_BOARD("fusion fuel controller")
	build_path = /obj/machinery/computer/fusion/fuel_control
	origin_tech = "{'programming':4,'engineering':4}"

/obj/item/stock_parts/circuitboard/gyrotron_control
	name = T_BOARD("gyrotron controller")
	build_path = /obj/machinery/computer/fusion/gyrotron
	origin_tech = "{'programming':4,'engineering':4}"

/obj/item/stock_parts/circuitboard/fusion_core
	name = T_BOARD("fusion core")
	build_path = /obj/machinery/power/fusion_core
	board_type = "machine"
	origin_tech = "{'wormholes':2,'magnets':4,'powerstorage':4}"
	req_components = list(
							/obj/item/stock_parts/manipulator/pico = 2,
							/obj/item/stock_parts/micro_laser/ultra = 1,
							/obj/item/stock_parts/subspace/crystal = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/fusion_injector
	name = T_BOARD("fusion fuel injector")
	build_path = /obj/machinery/fusion_fuel_injector
	board_type = "machine"
	origin_tech = "{'powerstorage':3,'engineering':4,'materials':4}"
	req_components = list(
							/obj/item/stock_parts/manipulator/pico = 2,
							/obj/item/stock_parts/scanning_module/phasic = 1,
							/obj/item/stock_parts/matter_bin/super = 1,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/gyrotron
	name = T_BOARD("gyrotron")
	build_path = /obj/machinery/power/emitter/gyrotron
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
							/obj/item/stack/cable_coil = 20,
							/obj/item/stock_parts/micro_laser/ultra = 2
							)
