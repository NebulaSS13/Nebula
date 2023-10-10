// Similar to the wall frame setup, but does not require circuit boards.

/decl/machine_construction/wall_frame/panel_closed/simple
	needs_board = null
	active_state = /decl/machine_construction/wall_frame/panel_closed/simple
	open_state = /decl/machine_construction/wall_frame/panel_open/simple
	diconnected_state = /decl/machine_construction/wall_frame/no_wires/simple
	bottom_state = /decl/machine_construction/default/deconstructed
	newly_built_state = /decl/machine_construction/wall_frame/no_wires/simple

/decl/machine_construction/wall_frame/panel_closed/simple/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/wall_frame/panel_open/simple
	needs_board = null
	active_state = /decl/machine_construction/wall_frame/panel_closed/simple
	open_state = /decl/machine_construction/wall_frame/panel_open/simple
	diconnected_state = /decl/machine_construction/wall_frame/no_wires/simple
	bottom_state = /decl/machine_construction/default/deconstructed
	newly_built_state = /decl/machine_construction/wall_frame/no_wires/simple

/decl/machine_construction/wall_frame/panel_open/simple/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/wall_frame/panel_open/simple/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a parts replacer to upgrade some parts."
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."
	. += "Use a wirecutter to disconnect the wires and expose the frame."

/decl/machine_construction/wall_frame/no_wires/simple
	needs_board = null
	active_state = /decl/machine_construction/wall_frame/panel_closed/simple
	open_state = /decl/machine_construction/wall_frame/panel_open/simple
	diconnected_state = /decl/machine_construction/wall_frame/no_wires/simple
	bottom_state = /decl/machine_construction/default/deconstructed
	newly_built_state = /decl/machine_construction/wall_frame/no_wires/simple

/decl/machine_construction/wall_frame/no_wires/simple/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/wall_frame/no_wires/simple/mechanics_info()
	. = list()
	. += "Add wires to hook up the machine."
	. += "Use a parts replacer to upgrade some parts."
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."
	. += "Use a crowbar to pry the frame off the wall."

/decl/machine_construction/wall_frame/no_wires/simple/down_interaction(obj/item/I, mob/user, obj/machinery/machine)
	if(IS_CROWBAR(I))
		TRANSFER_STATE(bottom_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, "You pry \the [machine] off the wall!")
		machine.dismantle()