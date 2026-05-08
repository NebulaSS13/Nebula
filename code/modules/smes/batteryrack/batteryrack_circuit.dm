/obj/item/stock_parts/circuitboard/batteryrack
	name = "circuitboard (battery rack PSU)"
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = "machine"
	origin_tech = @'{"powerstorage":3,"engineering":2}'
	req_components = list(/obj/item/stock_parts/capacitor = 3, /obj/item/stock_parts/matter_bin = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/datum/fabricator_recipe/imprinter/circuit/batteryrack
	path = /obj/item/stock_parts/circuitboard/batteryrack