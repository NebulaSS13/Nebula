/obj/item/stock_parts/circuitboard/internet_uplink
	name = "circuitboard (PLEXUS uplink)"
	board_type = "machine"
	build_path = /obj/machinery/internet_uplink
	origin_tech = @'{"magnets":4,"wormholes":3,"powerstorage":3,"engineering":3}'
	req_components = list(
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/smes_coil = 1
	)
	additional_spawn_components = null

/obj/item/stock_parts/circuitboard/internet_uplink_computer
	name = "circuitboard (PLEXUS uplink controller)"
	build_path = /obj/machinery/computer/internet_uplink
	origin_tech = @'{"programming":2,"engineering":2}'

/obj/item/stock_parts/circuitboard/internet_repeater
	name = "circuitboard (PLEXUS repeater)"
	build_path = /obj/machinery/internet_repeater
	board_type = "machine"
	origin_tech = @'{"magnets":3,"engineering":2,"programming":2}'
	req_components = list(
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/micro_laser = 1
	)
	additional_spawn_components = null

/datum/fabricator_recipe/imprinter/circuit/internet_uplink
	path = /obj/item/stock_parts/circuitboard/internet_uplink

/datum/fabricator_recipe/imprinter/circuit/internet_uplink_computer
	path = /obj/item/stock_parts/circuitboard/internet_uplink_computer

/datum/fabricator_recipe/imprinter/circuit/internet_repeater
	path = /obj/item/stock_parts/circuitboard/internet_repeater