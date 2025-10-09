/obj/item/stock_parts/circuitboard/teg_turbine
	name = "circuitboard (thermoelectric generator turbine)"
	build_path = /obj/machinery/atmospherics/binary/circulator
	board_type = "machine"
	origin_tech = @'{"powerstorage":4,"engineering":4}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/matter_bin = 3
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/teg_turbine/motor
	name = "circuitboard (thermoelectric generator motor)"
	build_path = /obj/machinery/generator
	board_type = "machine"
	origin_tech = @'{"powerstorage":4,"engineering":4}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 4
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)