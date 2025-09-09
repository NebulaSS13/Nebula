/decl/machine_construction/default/panel_closed/door
	needs_board = "door"
	down_state = /decl/machine_construction/default/panel_open/door
	var/hacking_state = /decl/machine_construction/default/panel_closed/door/hacking

/decl/machine_construction/default/panel_closed/door/fail_test_state_transfer(obj/machinery/machine, mob/user)
	var/static/obj/item/screwdriver/screwdriver = new
	// Prevent access locks on doors from interfering with our interactions.
	for(var/obj/item/stock_parts/access_lock/lock in machine.get_all_components_of_type(/obj/item/stock_parts/access_lock))
		lock.locked = FALSE
	// And ensure the door's closed
	var/obj/machinery/door/the_door = machine
	if(istype(the_door)) // just in case
		the_door.operating = FALSE // A lot of doors refuse to change states if operating.
	// Test hacking state
	if(!machine.attackby(screwdriver, user))
		return "Machine [log_info_line(machine)] did not respond to attackby with screwdriver."
	if(machine.construct_state.type != hacking_state)
		return "Machine [log_info_line(machine)] had a construct_state of type [machine.construct_state.type] after screwdriver interaction (expected [hacking_state])."
	// Do it again to reverse that state change.
	if(!machine.attackby(screwdriver, user))
		return "Machine [log_info_line(machine)] did not respond to attackby with screwdriver on a second try."
	if(machine.construct_state != src)
		return "Machine [log_info_line(machine)] had a construct_state of type [machine.construct_state.type] after screwdriver interaction (expected [type])."
	// Now test the down state
	var/static/obj/item/wrench/wrench = new
	if(!machine.attackby(wrench, user))
		return "Machine [log_info_line(machine)] did not respond to attackby with wrench."
	if(machine.construct_state.type != down_state)
		return "Machine [log_info_line(machine)] had a construct_state of type [machine.construct_state.type] after screwdriver interaction (expected [down_state])."

/decl/machine_construction/default/panel_closed/door/attackby(obj/item/used_item, mob/user, obj/machinery/machine)
	if(IS_SCREWDRIVER(used_item))
		TRANSFER_STATE(hacking_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You release some of the logic wiring on \the [machine]. The cover panel remains closed."))
		machine.update_icon()
		return TRUE
	if(IS_WRENCH(used_item))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the main cover panel on \the [machine], exposing the internals."))
		machine.queue_icon_update()
		return TRUE
	if(istype(used_item, /obj/item/part_replacer))
		var/obj/item/part_replacer/replacer = used_item
		if(replacer.remote_interaction)
			machine.part_replacement(user, replacer)
		for(var/line in machine.get_part_info_strings(user))
			to_chat(user, line)
		return TRUE
	return FALSE

/decl/machine_construction/default/panel_closed/door/mechanics_info()
	. = list()
	. += "Use a screwdriver to open a small hatch and expose some logic wires."
	. += "Use a wrench to open the main cover."
	. += "Use a parts replacer to view installed parts."

/decl/machine_construction/default/panel_closed/door/hacking
	up_state = /decl/machine_construction/default/panel_closed/door

/decl/machine_construction/default/panel_closed/door/hacking/attackby(obj/item/used_item, mob/user, obj/machinery/machine)
	if(IS_SCREWDRIVER(used_item))
		TRANSFER_STATE(up_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You tuck the exposed wiring back into \the [machine] and screw the hatch back into place."))
		machine.queue_icon_update()
		return TRUE
	return FALSE

/decl/machine_construction/default/panel_closed/door/hacking/mechanics_info()
	. = list()
	. += "Use a screwdriver close the hatch and tuck the exposed wires back in."

/decl/machine_construction/default/panel_open/door
	needs_board = "door"
	up_state = /decl/machine_construction/default/panel_closed/door