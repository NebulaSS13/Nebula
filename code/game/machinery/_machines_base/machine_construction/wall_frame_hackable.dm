// Wall frame with an extra state accessible from the closed one via screwdriver, with custom interactions available for that state. Uses crowbar for the usual down state instead.

/decl/machine_construction/wall_frame/panel_closed/hackable
	active_state = /decl/machine_construction/wall_frame/panel_closed/hackable
	open_state = /decl/machine_construction/wall_frame/panel_open/hackable
	diconnected_state = /decl/machine_construction/wall_frame/no_wires/hackable
	bottom_state = /decl/machine_construction/wall_frame/no_circuit/hackable
	newly_built_state = /decl/machine_construction/wall_frame/no_circuit/hackable

/decl/machine_construction/wall_frame/panel_open/hackable
	active_state = /decl/machine_construction/wall_frame/panel_closed/hackable
	open_state = /decl/machine_construction/wall_frame/panel_open/hackable
	diconnected_state = /decl/machine_construction/wall_frame/no_wires/hackable
	bottom_state = /decl/machine_construction/wall_frame/no_circuit/hackable
	newly_built_state = /decl/machine_construction/wall_frame/no_circuit/hackable

/decl/machine_construction/wall_frame/no_wires/hackable
	active_state = /decl/machine_construction/wall_frame/panel_closed/hackable
	open_state = /decl/machine_construction/wall_frame/panel_open/hackable
	diconnected_state = /decl/machine_construction/wall_frame/no_wires/hackable
	bottom_state = /decl/machine_construction/wall_frame/no_circuit/hackable
	newly_built_state = /decl/machine_construction/wall_frame/no_circuit/hackable

/decl/machine_construction/wall_frame/no_circuit/hackable
	active_state = /decl/machine_construction/wall_frame/panel_closed/hackable
	open_state = /decl/machine_construction/wall_frame/panel_open/hackable
	diconnected_state = /decl/machine_construction/wall_frame/no_wires/hackable
	bottom_state = /decl/machine_construction/wall_frame/no_circuit/hackable
	newly_built_state = /decl/machine_construction/wall_frame/no_circuit/hackable

/decl/machine_construction/wall_frame/panel_closed/hackable/down_interaction(obj/item/I, mob/user, obj/machinery/machine)
	if(IS_SCREWDRIVER(I))
		TRANSFER_STATE(/decl/machine_construction/wall_frame/panel_closed/hackable/hacking)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You release some of the logic wiring on \the [machine]. The cover panel remains closed."))
		machine.queue_icon_update()
		return
	if(IS_CROWBAR(I))
		TRANSFER_STATE(open_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the main cover panel on \the [machine], exposing the internals."))
		machine.queue_icon_update()

/decl/machine_construction/wall_frame/panel_closed/hackable/mechanics_info()
	. = list()
	. += "Use a screwdriver to open a small hatch and expose some logic wires."
	. += "Use a crowbar to pry open the main cover."
	. += "Use a parts replacer to view installed parts."

/decl/machine_construction/wall_frame/panel_closed/hackable/hacking/down_interaction(obj/item/I, mob/user, obj/machinery/machine)
	if(IS_SCREWDRIVER(I))
		TRANSFER_STATE(active_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You tuck the exposed wiring back into \the [machine] and screw the hatch back into place."))
		machine.queue_icon_update()
		return
	if(IS_CROWBAR(I))
		to_chat(user, SPAN_NOTICE("The exposed wires block you from prying open the main hatch. Tuck them back in first."))
		return TRUE

/decl/machine_construction/wall_frame/panel_closed/hackable/hacking/mechanics_info()
	. = list()
	. += "Use a screwdriver close the hatch and tuck the exposed wires back in."
	. += "Use a parts replacer to view installed parts."

/decl/machine_construction/wall_frame/panel_open/hackable/up_interaction(obj/item/I, mob/user, obj/machinery/machine)
	if(IS_CROWBAR(I))
		TRANSFER_STATE(active_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		machine.panel_open = FALSE
		to_chat(user, SPAN_NOTICE("You push the main cover panel back into place on \the [machine]."))
		machine.queue_icon_update()

/decl/machine_construction/wall_frame/panel_open/hackable/mechanics_info()
	. = list()
	. += "Use a crowbar to close the main cover."
	. += "Use a parts replacer to upgrade some parts."
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."
	. += "Use a wirecutter to disconnect the wires and expose the circuit board."