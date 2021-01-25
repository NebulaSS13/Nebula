/obj/item/stock_parts/circuitboard/bioprinter
	name = "circuitboard (bioprinter)"
	build_path = /obj/machinery/fabricator/bioprinter
	board_type = "machine"
	origin_tech = "{'engineering':1,'biotech':3,'programming':3}"
	req_components = list(
		/obj/item/scanner/health = 1,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
