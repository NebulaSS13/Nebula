/obj/item/stock_parts/circuitboard/smes
	name = T_BOARD("superconductive magnetic energy storage")
	build_path = /obj/machinery/power/smes/buildable
	board_type = "machine"
	origin_tech = "{'" + TECH_POWER + "':6,'" + TECH_ENGINEERING + "':4}"
	req_components = list(/obj/item/stock_parts/smes_coil = 1, /obj/item/stack/cable_coil = 30)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/shielding/electric = 1
	)

/obj/item/stock_parts/circuitboard/batteryrack
	name = T_BOARD("battery rack PSU")
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = "machine"
	origin_tech = "{'" + TECH_POWER + "':3,'" + TECH_ENGINEERING + "':2}"
	req_components = list(/obj/item/stock_parts/capacitor/ = 3, /obj/item/stock_parts/matter_bin/ = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/recharger
	name = T_BOARD("recharger")
	build_path = /obj/machinery/recharger
	board_type = "machine"
	origin_tech = "{'" + TECH_POWER + "':2,'" + TECH_ENGINEERING + "':2}"
	req_components = list(
		/obj/item/stock_parts/capacitor = 1
	)

/obj/item/stock_parts/circuitboard/recharger/wall
	name = T_BOARD("wall recharger")
	build_path = /obj/machinery/recharger/wallcharger
	board_type = "wall"

/obj/item/stock_parts/circuitboard/cell_charger
	name = T_BOARD("cell charger")
	build_path = /obj/machinery/cell_charger
	board_type = "machine"
	origin_tech = "{'" + TECH_POWER + "':2,'" + TECH_ENGINEERING + "':2}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/power/battery/buildable/turbo = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/capacitor = 6
	) // The apc part is to supply upkeep power, so it charges the battery instead of draining it. Capacitors make things go faster.