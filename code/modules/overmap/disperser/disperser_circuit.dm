/obj/item/stock_parts/circuitboard/disperser
	name = "circuitboard (obstruction field disperser control)"
	build_path = /obj/machinery/computer/ship/disperser
	origin_tech = "{'engineering':2,'combat':2,'wormholes':2}"

/obj/item/stock_parts/circuitboard/disperserfront
	name = "circuitboard (obstruction field disperser beam generator)"
	build_path = /obj/machinery/disperser/front
	board_type = "machine"
	origin_tech = "{'engineering':2,'combat':2,'wormholes':2}"
	req_components = list (
		/obj/item/stock_parts/manipulator/pico = 5
	)

/obj/item/stock_parts/circuitboard/dispersermiddle
	name = "circuitboard (obstruction field disperser fusor)"
	build_path = /obj/machinery/disperser/middle
	board_type = "machine"
	origin_tech = "{'engineering':2,'combat':2,'wormholes':2}"
	req_components = list (
		/obj/item/stock_parts/subspace/crystal = 10
	)

/obj/item/stock_parts/circuitboard/disperserback
	name = "circuitboard (obstruction field disperser material deconstructor)"
	build_path = /obj/machinery/disperser/back
	board_type = "machine"
	origin_tech = "{'engineering':2,'combat':2,'wormholes':2}"
	req_components = list (
		/obj/item/stock_parts/capacitor/super = 5
	)