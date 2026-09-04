/obj/item/stock_parts/circuitboard/turbine
	name = "circuitboard (small turbine)"
	build_path = /obj/machinery/atmospherics/pipeturbine
	board_type = "machine"
	origin_tech = @'{"powerstorage":4,"engineering":4}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/matter_bin = 2
	)
	additional_spawn_components = list()

/obj/item/stock_parts/circuitboard/turbine/motor
	name = "circuitboard (small turbine motor)"
	build_path = /obj/machinery/turbinemotor
	board_type = "machine"
	origin_tech = @'{"powerstorage":4,"engineering":4}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 4
	)

/obj/item/stock_parts/circuitboard/big_turbine
	name = "circuitboard (large turbine compressor)"
	build_path = /obj/machinery/compressor
	board_type = "machine"
	origin_tech = @'{"powerstorage":4,"engineering":4}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/matter_bin = 3
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/big_turbine/center
	name = "circuitboard (large turbine motor)"
	build_path = /obj/machinery/turbine
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