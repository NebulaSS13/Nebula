/obj/item/stock_parts/circuitboard/unary_atmos/engine
	name = T_BOARD("gas thruster")
	icon = 'icons/obj/modules/module_controller.dmi'
	build_path = /obj/machinery/atmospherics/unary/engine
	origin_tech = "{'powerstorage':1,'engineering':2}"
	req_components = list(
		/obj/item/stack/cable_coil = 30,
		/obj/item/pipe = 2
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/power/apc/buildable = 1
		)

/obj/item/stock_parts/circuitboard/unary_atmos/fusion_engine
	name = T_BOARD("fusion thruster")
	icon = 'icons/obj/modules/module_controller.dmi'
	build_path = /obj/machinery/atmospherics/unary/engine/fusion
	origin_tech = "{'powerstorage':1,'engineering':2}"
	req_components = list(
		/obj/item/stack/cable_coil = 30,
		/obj/item/pipe = 2
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/power/apc/buildable = 1,
		)