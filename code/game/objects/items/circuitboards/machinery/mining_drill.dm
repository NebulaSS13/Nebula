/obj/item/stock_parts/circuitboard/miningdrill
	name = "circuitboard (mining drill head)"
	build_path = /obj/machinery/mining_drill
	board_type = "machine"
	origin_tech = @'{"programming":1,"engineering":1}'
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/scanning_module = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/battery/buildable/stock,
		/obj/item/cell = 1
	)
