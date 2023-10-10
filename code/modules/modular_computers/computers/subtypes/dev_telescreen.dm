//////////////////////////////////////////////////////////////////
// Telescreen Circuit
//////////////////////////////////////////////////////////////////

/obj/item/stock_parts/circuitboard/modular_computer/telescreen
	name = "circuitboard (modular telescreen)"
	board_type = "wall"
	build_path = /obj/machinery/computer/modular/telescreen
	req_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/computer/processor_unit = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/computer/network_card = 1,
		/obj/item/stock_parts/computer/hard_drive/super = 1
	)

//////////////////////////////////////////////////////////////////
// Telescreen Frame
//////////////////////////////////////////////////////////////////

/obj/item/frame/modular_telescreen
	name = "modular telescreen frame"
	desc = "Used for building wall-mounted modular telescreen computers."
	icon = 'icons/obj/modular_computers/modular_telescreen.dmi'
	icon_state = "frame"
	build_machine_type = /obj/machinery/computer/modular/telescreen

/obj/item/frame/modular_telescreen/kit
	fully_construct = TRUE
	name = "modular telescreen kit"
	desc = "An all-in-one wall-mounted modular telescreen computer kit, comes preassembled."
	icon_state = "frame_kit"

//////////////////////////////////////////////////////////////////
// Telescreen OS
//////////////////////////////////////////////////////////////////

/datum/extension/interactive/os/console/telescreen
	screen_icon_file = 'icons/obj/modular_computers/modular_telescreen.dmi'
	expected_type = /obj/machinery/computer/modular/telescreen

/datum/extension/interactive/os/console/telescreen/get_hardware_flag()
	return PROGRAM_TELESCREEN

//////////////////////////////////////////////////////////////////
// Telescreen Computer
//////////////////////////////////////////////////////////////////

/obj/machinery/computer/modular/telescreen
	name               = "telescreen"
	desc               = "A wall-mounted touchscreen computer."
	icon               = 'icons/obj/modular_computers/modular_telescreen.dmi'
	icon_state         = "telescreen"
	anchored           = TRUE
	density            = FALSE
	obj_flags          = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-20}, 'SOUTH':{'y':24}, 'EAST':{'x':-24}, 'WEST':{'x':24}}"
	idle_power_usage   = 75
	active_power_usage = 300
	max_hardware_size  = 2 //make sure we can only put smaller components in here
	construct_state    = /decl/machine_construction/wall_frame/panel_closed
	base_type          = /obj/machinery/computer/modular/telescreen
	frame_type         = /obj/item/frame/modular_telescreen
	//Behaves like a touchscreen
	stat_immune        = NOINPUT
	icon_keyboard      = null
	interact_sounds    = null
	clicksound         = null
	required_interaction_dexterity = DEXTERITY_TOUCHSCREENS
	os_type            = /datum/extension/interactive/os/console/telescreen

/obj/machinery/computer/modular/telescreen/update_directional_offset(force = FALSE)
	if(!force && (!length(directional_offset) || !is_wall_mounted()))
		return
	. = ..()

/obj/machinery/computer/modular/telescreen/on_update_icon()
	cut_overlays()
	icon_state = initial(icon_state)

	var/can_see_circuit = FALSE
	if(panel_open)
		add_overlay("panel_open")
		can_see_circuit = TRUE
	else if(reason_broken & MACHINE_BROKEN_GENERIC)
		add_overlay("inside_broken")
		can_see_circuit = TRUE

	if(can_see_circuit)
		var/obj/item/stock_parts/circuitboard/C = get_component_of_type(/obj/item/stock_parts/circuitboard)
		if(C)
			if(!C.is_functional())
				add_overlay("circuit_broken")
			else if(istype(construct_state, /decl/machine_construction/wall_frame/no_wires)) //only way to check if unwired
				add_overlay("circuit_unwired")
			else
				add_overlay("circuit")

	if(!panel_open && (reason_broken & MACHINE_BROKEN_GENERIC))
		add_overlay("panel_broken")

	if(inoperable())
		set_light(0)
		var/screen = get_component_of_type(/obj/item/stock_parts/console_screen)
		if(screen)
			if(reason_broken & MACHINE_BROKEN_GENERIC)
				add_overlay("comp_screen_broken")
			else
				add_overlay("comp_screen")
	else
		set_light(light_range_on, light_power_on, light_color)
		var/screen_overlay = get_screen_overlay()
		if(screen_overlay)
			add_overlay(screen_overlay)
