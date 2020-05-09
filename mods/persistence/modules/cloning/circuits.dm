/obj/item/stock_parts/circuitboard/cloning_pod
	name = T_BOARD("cloning_pod")
	build_path = /obj/machinery/cloning_pod
	board_type = "machine"
	origin_tech = "{'programming':2}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)

/datum/fabricator_recipe/imprinter/circuit/cloning_pod
	path = /obj/item/stock_parts/circuitboard/cloning_pod
