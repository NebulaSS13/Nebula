// Used to be called default_deconstruction_screwdriver -> default_deconstruction_crowbar and default_part_replacement

/decl/machine_construction/default
	needs_board = "machine"
	var/up_state
	var/down_state

/decl/machine_construction/default/no_deconstruct/attackby(obj/item/used_item, mob/user, obj/machinery/machine)
	. = FALSE

/decl/machine_construction/default/panel_closed
	down_state = /decl/machine_construction/default/panel_open
	visible_components = FALSE
	locked = TRUE

/decl/machine_construction/default/panel_closed/fail_unit_test(obj/machinery/machine)
	if((. = ..()))
		return
	var/static/mob/living/human/user = new
	return fail_test_state_transfer(machine, user)

/decl/machine_construction/default/panel_closed/proc/fail_test_state_transfer(obj/machinery/machine, mob/user)
	var/static/obj/item/screwdriver/screwdriver = new
	// Prevent access locks on machines interfering with our interactions.
	for(var/obj/item/stock_parts/access_lock/lock in machine.get_all_components_of_type(/obj/item/stock_parts/access_lock))
		lock.locked = FALSE
	if(!machine.attackby(screwdriver, user))
		return "Machine [log_info_line(machine)] did not respond to attackby with screwdriver."
	if(machine.construct_state.type != down_state)
		return "Machine [log_info_line(machine)] had a construct_state of type [machine.construct_state.type] after screwdriver interaction (expected [down_state])."

/decl/machine_construction/default/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/default/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, down_state)

/decl/machine_construction/default/panel_closed/attackby(obj/item/used_item, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(IS_SCREWDRIVER(used_item))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return TRUE
	if(istype(used_item, /obj/item/part_replacer))
		var/obj/item/part_replacer/replacer = used_item
		if(replacer.remote_interaction)
			machine.part_replacement(user, replacer)
		for(var/line in machine.get_part_info_strings(user))
			to_chat(user, line)
		return TRUE
	return FALSE

/decl/machine_construction/default/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, down_state)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/decl/machine_construction/default/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel."
	. += "Use a parts replacer to view installed parts."

/decl/machine_construction/default/panel_open
	up_state = /decl/machine_construction/default/panel_closed
	down_state = /decl/machine_construction/default/deconstructed

/decl/machine_construction/default/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/default/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, up_state)

/decl/machine_construction/default/panel_open/attackby(obj/item/used_item, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(IS_CROWBAR(used_item))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		machine.visible_message(SPAN_NOTICE("\The [user] deconstructs \the [machine]."))
		machine.dismantle()
		return
	if(IS_SCREWDRIVER(used_item))
		TRANSFER_STATE(up_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = FALSE
		to_chat(user, SPAN_NOTICE("You close the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return TRUE
	if(istype(used_item, /obj/item/part_replacer))
		return machine.part_replacement(user, used_item)
	if(IS_WRENCH(used_item))
		return machine.part_removal(user)
	if(istype(used_item))
		return machine.part_insertion(user, used_item)
	return FALSE

/decl/machine_construction/default/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."

// Not implemented fully as the machine will qdel on transition to this. Path needed for checks.
/decl/machine_construction/default/deconstructed
