/obj/item/stock_parts/circuitboard/fission_core_control
	name = "circuit board (fission core controller)"
	build_path = /obj/machinery/computer/fission
	origin_tech = @'{"programming":2,"engineering":3}'

/obj/item/stock_parts/circuitboard/unary_atmos/fission_core
	name = "circuit board (fission core)"
	build_path = /obj/machinery/atmospherics/unary/fission_core
	board_type = "machine"
	origin_tech = @'{"engineering":2,"materials":2}'
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
		)
	req_components = list(
		/obj/item/stack/cable_coil = 20,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 1
		)