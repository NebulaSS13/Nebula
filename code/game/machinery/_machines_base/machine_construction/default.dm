// Used to be called default_deconstruction_screwdriver -> default_deconstruction_crowbar and default_part_replacement

/decl/machine_construction/default
	needs_board = "machine"
	var/up_state
	var/down_state

/decl/machine_construction/default/no_deconstruct/attackby(obj/item/I, mob/user, obj/machinery/machine)
	. = FALSE

/decl/machine_construction/default/panel_closed
	down_state = /decl/machine_construction/default/panel_open
	visible_components = FALSE
	locked = TRUE

/decl/machine_construction/default/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/default/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, down_state)

/decl/machine_construction/default/panel_closed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(IS_SCREWDRIVER(I))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return
	if(istype(I, /obj/item/part_replacer))
		var/obj/item/part_replacer/replacer = I
		if(replacer.remote_interaction)
			machine.part_replacement(user, replacer)
		machine.display_parts(user)
		return TRUE

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

/decl/machine_construction/default/panel_open/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(IS_CROWBAR(I))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		machine.visible_message(SPAN_NOTICE("\The [user] deconstructs \the [machine]."))
		machine.dismantle()
		return
	if(IS_SCREWDRIVER(I))
		TRANSFER_STATE(up_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = FALSE
		to_chat(user, SPAN_NOTICE("You close the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return

	if(istype(I, /obj/item/part_replacer))
		return machine.part_replacement(user, I)

	if(IS_WRENCH(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

/decl/machine_construction/default/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."

// Not implemented fully as the machine will qdel on transition to this. Path needed for checks.
/decl/machine_construction/default/deconstructed
