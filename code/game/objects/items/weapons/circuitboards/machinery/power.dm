/obj/item/stock_parts/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = /obj/machinery/power/smes/buildable
	board_type = "machine"
	origin_tech = "{'powerstorage':6,'engineering':4}"
	req_components = list(/obj/item/stock_parts/smes_coil = 1, /obj/item/stack/cable_coil = 30)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/shielding/electric = 1
	)

/obj/item/stock_parts/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = "machine"
	origin_tech = "{'powerstorage':3,'engineering':2}"
	req_components = list(/obj/item/stock_parts/capacitor/ = 3, /obj/item/stock_parts/matter_bin/ = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/machinery/recharger
	board_type = "machine"
	origin_tech = "{'powerstorage':2,'engineering':2}"
	req_components = list(
		/obj/item/stock_parts/capacitor = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/recharger/wall
	name = T_BOARD("wall recharger")
	build_path = /obj/machinery/recharger/wallcharger
	board_type = "wall"

/obj/item/stock_parts/circuitboard/cell_charger
	name = T_BOARD("cell charger")
	build_path = /obj/machinery/cell_charger
	board_type = "machine"
	origin_tech = "{'powerstorage':2,'engineering':2}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/power/battery/buildable/turbo = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/capacitor = 6
	) // The apc part is to supply upkeep power, so it charges the battery instead of draining it. Capacitors make things go faster.

/obj/item/stock_parts/circuitboard/turbine
	name = T_BOARD("small turbine")
	build_path = /obj/machinery/atmospherics/pipeturbine
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2
	)
	additional_spawn_components = list()

/obj/item/stock_parts/circuitboard/turbine/motor
	name = T_BOARD("small turbine motor")
	build_path = /obj/machinery/power/turbinemotor
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 4
	)

/obj/item/stock_parts/circuitboard/big_turbine
	name = T_BOARD("large turbine compressor")
	build_path = /obj/machinery/compressor
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/matter_bin = 3
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1	
	)

/obj/item/stock_parts/circuitboard/big_turbine/center
	name = T_BOARD("large turbine motor")
	build_path = /obj/machinery/power/turbine
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 4
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/teg_turbine
	name = T_BOARD("thermoelectric generator turbine")
	build_path = /obj/machinery/atmospherics/binary/circulator
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/matter_bin = 3
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1		
	)

/obj/item/stock_parts/circuitboard/teg_turbine/motor
	name = T_BOARD("thermoelectric generator motor")
	build_path = /obj/machinery/power/generator
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 4
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/breaker
	name = T_BOARD("breaker box")
	build_path = /obj/machinery/power/breakerbox
	board_type = "machine"
	origin_tech = "{'powerstorage':4,'engineering':4}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)