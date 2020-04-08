/obj/item/stock_parts/circuitboard/exonet
	board_type = "machine"
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/exonet_lock/buildable = 1
	)

/obj/item/stock_parts/circuitboard/exonet/router
	name = T_BOARD("exonet router")
	build_path = /obj/machinery/computer/exonet/broadcaster/router
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':4}"
	req_components = list(
		/obj/item/stack/cable_coil = 5
	)

/obj/item/stock_parts/circuitboard/exonet/uplink
	name = T_BOARD("exonet uplink")
	build_path = /obj/machinery/computer/exonet/uplink
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':4}"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/subspace/filter = 2
	)

/obj/item/stock_parts/circuitboard/exonet/access_directory
	name = T_BOARD("exonet directory controller")
	build_path = /obj/machinery/computer/exonet/access_directory
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':4}"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/computer/scanner = 1,
		/obj/item/stock_parts/computer/card_slot = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/exonet/mainframe
	name = T_BOARD("exonet mainframe")
	build_path = /obj/machinery/computer/exonet/mainframe
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':4}"
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/computer/hard_drive = 2
	)

/obj/item/stock_parts/circuitboard/exonet/relay
	name = T_BOARD("exonet relay")
	build_path = /obj/machinery/computer/exonet/broadcaster/relay
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':4}"
	req_components = list(
		/obj/item/stack/cable_coil = 5
	)

/datum/design/circuit/exonet/router
	name = "exonet router"
	build_path = /obj/item/stock_parts/circuitboard/exonet/router
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/uplink
	name = "exonet uplink"
	build_path = /obj/item/stock_parts/circuitboard/exonet/uplink
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/access_directory
	name = "exonet directory controller"
	build_path = /obj/item/stock_parts/circuitboard/exonet/access_directory
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/mainframe
	name = "exonet mainframe"
	build_path = /obj/item/stock_parts/circuitboard/exonet/mainframe
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/exonet/relay
	name = "exonet relay"
	build_path = /obj/item/stock_parts/circuitboard/exonet/relay
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)