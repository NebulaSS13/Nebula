/obj/machinery/bluespace_thruster
	name = "bluespace propulsion device"
	desc = "An advanced bluespace propulsion device, using energy and minutes amount of gas to generate thrust."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	power_channel = ENVIRON
	idle_power_usage = 100
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed

/obj/machinery/bluespace_thruster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/ship_engine/bluespace, "bluespace thruster")
	var/datum/extension/ship_engine/engine = get_extension(src, /datum/extension/ship_engine)
	engine.connect_to_ship()

/obj/item/stock_parts/circuitboard/engine/bluespace
	name = T_BOARD("bluespace propulsion device")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/bluespace_thruster
	origin_tech = "{'powerstorage':1,'engineering':2}"
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/capacitor = 2)
	material = MAT_GOLD
	matter = list(
		MAT_DIAMOND = MATTER_AMOUNT_REINFORCEMENT,
		MAT_URANIUM = MATTER_AMOUNT_TRACE,
		MAT_PLASTIC = MATTER_AMOUNT_TRACE,
		MAT_ALUMINIUM = MATTER_AMOUNT_TRACE
	)