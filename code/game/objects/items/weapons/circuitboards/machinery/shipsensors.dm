/obj/item/stock_parts/circuitboard/shipsensors
	name = "circuitboard (ship sensors)"
	build_path = /obj/machinery/shipsensors
	board_type = "machine"
	origin_tech = "{'wormholes':2,'programming':2}"
	req_components = list(
							/obj/item/stack/cable_coil = 30,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/subspace/ansible = 1,
							/obj/item/stock_parts/subspace/transmitter = 1
						  )
	additional_spawn_components = list(
		/obj/item/stock_parts/shielding/heat = 1
	)