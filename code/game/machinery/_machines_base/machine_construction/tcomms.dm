// Telecomms have lots of states.

/decl/machine_construction/tcomms
	needs_board = "machine"

/decl/machine_construction/tcomms/panel_closed
	visible_components = FALSE
	locked = TRUE

/decl/machine_construction/tcomms/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/tcomms/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/tcomms/panel_open)

/decl/machine_construction/tcomms/panel_closed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isScrewdriver(I))
		if(I.do_tool_interaction(TOOL_SCREWDRIVER, user, machine, 0, "unfastening the bolts", "unfastening the bolts"))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open)
			machine.panel_open = TRUE

/decl/machine_construction/tcomms/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, /decl/machine_construction/tcomms/panel_open/no_cable)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/decl/machine_construction/tcomms/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel."

/decl/machine_construction/tcomms/panel_closed/cannot_print
	cannot_print = TRUE

/decl/machine_construction/tcomms/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/tcomms/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/tcomms/panel_closed)

/decl/machine_construction/tcomms/panel_open/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	return state_interactions(I, user, machine)

/decl/machine_construction/tcomms/panel_open/proc/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isScrewdriver(I))
		if(I.do_tool_interaction(TOOL_SCREWDRIVER, user, machine, 0, "fastening the bolts of the", "fastening the bolts of the"))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_closed)
			machine.panel_open = FALSE
		return
	if(isWrench(I))
		if(I.do_tool_interaction(TOOL_WRENCH, user, machine, 0, "dislodging the external plating of the", "dislodging the external plating of the"))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/unwrenched)

/decl/machine_construction/tcomms/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a wrench to remove the external plating."

/decl/machine_construction/tcomms/panel_open/unwrenched/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		if(I.do_tool_interaction(TOOL_WRENCH, user, machine, 0, "securing the external plating of the", "securing the external plating of the"))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open)
			playsound(machine.loc, 'sound/items/Ratchet.ogg', 75, 1)
			return
	if(isWirecutter(I))
		if(I.do_tool_interaction(TOOL_WIRECUTTERS, user, machine, 0, "removing the cables from the", "removing the cables from the"))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/no_cable)
			var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( user.loc )
			A.amount = 5
			machine.set_broken(TRUE, MACHINE_BROKEN_CONSTRUCT) // the machine's been borked!

/decl/machine_construction/tcomms/panel_open/unwrenched/mechanics_info()
	. = list()
	. += "Use a wrench to secure the external plating."
	. += "Use wirecutters to remove the cabling."

/decl/machine_construction/tcomms/panel_open/no_cable/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isCoil(I))
		var/obj/item/stack/cable_coil/A = I
		if (A.can_use(5))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/unwrenched)
			A.use(5)
			to_chat(user, SPAN_NOTICE("You insert the cables."))
			machine.set_broken(FALSE, MACHINE_BROKEN_CONSTRUCT) // the machine's not borked anymore!
			return
		else
			to_chat(user, SPAN_WARNING("You need five coils of wire for this."))
			return TRUE
	if(isCrowbar(I))
		if(I.do_tool_interaction(TOOL_CROWBAR, user, machine, 0, "deconstructing", "deconstructing"))
			TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
			machine.dismantle()
			return

	if(istype(I, /obj/item/storage/part_replacer))
		return machine.part_replacement(I, user)

	if(isWrench(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

/decl/machine_construction/tcomms/panel_open/no_cable/mechanics_info()
	. = list()
	. += "Attach cables to make the machine functional."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."