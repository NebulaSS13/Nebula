/obj/item/stock_parts/circuitboard/nuclear_cylinder_storage
	name = "circuitboard (nuclear cylinder storage)"
	build_path = /obj/machinery/nuclear_cylinder_storage/buildable
	board_type = "machine"
	origin_tech = "{'combat':2,'engineering':2}"

	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stock_parts/manipulator = 2
	)

	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)
