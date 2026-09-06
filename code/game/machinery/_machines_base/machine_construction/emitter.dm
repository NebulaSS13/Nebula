// Emitters are not screwed apart like most machines; they are bolted down with a wrench and then welded in place.
// Some subtypes like gyrotrons also use panel_state to gain the usual maintenance hatch on top of that.
// Yes I hate this, yes it should be done differently, no I do not have it in me to do it any other way.
// Maybe we should just bite the bullet and make gyrotrons not emitters??
/decl/machine_construction/emitter
	visible_components = FALSE
	/// The state entered when the emitter is fastened down further, if any.
	var/down_state
	/// The state entered when the emitter is loosened, if any.
	var/up_state
	/// Whether the emitter is anchored to the floor in this state.
	var/anchored = FALSE
	// gyrotron stuff below
	/// The state entered when the maintenance hatch is toggled via screwdriver. Null if the emitter has no hatch.
	var/panel_state
	/// Whether the maintenance hatch is open in this state.
	var/panel_open = FALSE

/decl/machine_construction/emitter/state_is_valid(obj/machinery/machine)
	return (machine.anchored == anchored) && (machine.panel_open == panel_open)

/decl/machine_construction/emitter/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		if(machine.panel_open != panel_open)
			try_change_state(machine, panel_state)
		else
			try_change_state(machine, machine.anchored ? down_state : up_state)

// the panel starts open after construction, again taken from /decl/machine_construction/default/panel_closed
/decl/machine_construction/emitter/post_construct(obj/machinery/machine)
	if(!panel_state || panel_open)
		return
	try_change_state(machine, panel_state)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/// Handles a wrench applied to the emitter in this state. Return TRUE if the interaction was handled.
/decl/machine_construction/emitter/proc/wrench_interaction(obj/item/used_item, mob/user, obj/machinery/emitter/machine)
	return FALSE

/// Handles a welding tool applied to the emitter in this state. Return TRUE if the interaction was handled.
/decl/machine_construction/emitter/proc/welder_interaction(obj/item/weldingtool/welder, mob/user, obj/machinery/emitter/machine)
	return FALSE

/decl/machine_construction/emitter/attackby(obj/item/used_item, mob/user, obj/machinery/emitter/machine)
	if((. = ..()))
		return
	if(machine.active) // can't open/close/unweld/etc while operating
		to_chat(user, SPAN_WARNING("Turn \the [machine] off first."))
		return TRUE
	if(IS_WRENCH(used_item))
		return wrench_interaction(used_item, user, machine)
	else if(IS_WELDER(used_item))
		return welder_interaction(used_item, user, machine)
	// everything after this is for gyrotrons/etc
	if(!panel_state)
		return FALSE
	// handle this here because otherwise we'd have some nasty code duplication
	if(IS_SCREWDRIVER(used_item))
		TRANSFER_STATE(panel_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [machine.panel_open ? "open" : "close"] the maintenance hatch of \the [machine]."))
		machine.update_icon() // could be done in a machinery level /state_transition() override but whatever
		return TRUE
	// sigh. copied from /decl/machine_construction/default/panel_open and /decl/machine_construction/default/panel_closed
	// again done this way to avoid duplication because gyrotrons can have any combo of panel + emitter state
	if(!panel_open)
		// closed panel (taken from panel_closed)
		// maybe these should be on the part replacer or something...
		// there's so much code duplication between different panel open/closed states and i hate it.
		// maybe we just need to separate it out to a separate state machine and let construct state determine if panel state can change
		if(istype(used_item, /obj/item/part_replacer))
			var/obj/item/part_replacer/replacer = used_item
			if(replacer.remote_interaction)
				machine.part_replacement(user, replacer)
			for(var/line in machine.get_part_info_strings(user))
				to_chat(user, line)
			return TRUE
		return FALSE
	// open panel (taken from panel_open)
	if(IS_CROWBAR(used_item))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		machine.visible_message(SPAN_NOTICE("\The [user] deconstructs \the [machine]."))
		machine.dismantle()
		return
	if(istype(used_item, /obj/item/part_replacer))
		return machine.part_replacement(user, used_item)
	if(istype(used_item))
		return machine.part_insertion(user, used_item)
	return FALSE

/decl/machine_construction/emitter/mechanics_info()
	. = list()
	if(!panel_state)
		return
	if(panel_open)
		. += "Use a screwdriver to close the maintenance hatch."
		. += "Use a parts replacer to upgrade some parts."
		. += "Use a crowbar to remove the circuit and deconstruct the emitter."
		. += "Insert a new part to install it."
	else
		. += "Use a screwdriver to open the maintenance hatch."
		. += "Use a parts replacer to view installed parts."

/decl/machine_construction/emitter/unsecured
	down_state = /decl/machine_construction/emitter/anchored

/decl/machine_construction/emitter/unsecured/wrench_interaction(obj/item/used_item, mob/user, obj/machinery/emitter/machine)
	TRANSFER_STATE(down_state)
	playsound(machine.loc, 'sound/items/Ratchet.ogg', 75, 1)
	user.visible_message(
		"\The [user] secures \the [machine] to the floor.",
		"You secure the external reinforcing bolts to the floor.",
		"You hear a ratchet.")
	machine.anchored = TRUE
	return TRUE

/decl/machine_construction/emitter/unsecured/welder_interaction(obj/item/weldingtool/welder, mob/user, obj/machinery/emitter/machine)
	to_chat(user, SPAN_WARNING("\The [machine] needs to be wrenched to the floor."))
	return TRUE

/decl/machine_construction/emitter/unsecured/mechanics_info()
	. = ..()
	. += "Use a wrench to anchor the emitter to the floor."

/decl/machine_construction/emitter/anchored
	anchored = TRUE
	down_state = /decl/machine_construction/emitter/welded
	up_state = /decl/machine_construction/emitter/unsecured

/decl/machine_construction/emitter/anchored/wrench_interaction(obj/item/used_item, mob/user, obj/machinery/emitter/machine)
	TRANSFER_STATE(up_state)
	playsound(machine.loc, 'sound/items/Ratchet.ogg', 75, 1)
	user.visible_message(
		"\The [user] unsecures \the [machine]'s reinforcing bolts from the floor.",
		"You undo the external reinforcing bolts.",
		"You hear a ratchet.")
	machine.anchored = FALSE
	return TRUE

/decl/machine_construction/emitter/anchored/welder_interaction(obj/item/weldingtool/welder, mob/user, obj/machinery/emitter/machine)
	if(!welder.do_tool_interaction(TOOL_WELDER, user, machine, 2 SECONDS, \
		"welding", \
		"welding", \
		"You fail to weld \the [machine] to the floor.", \
		fuel_expenditure = 1) \
	)
		return TRUE // failed for whatever reason
	TRANSFER_STATE(down_state)
	return TRUE

/decl/machine_construction/emitter/anchored/mechanics_info()
	. = ..()
	. += "Use a wrench to undo the bolts anchoring the emitter to the floor."
	. += "Use a welding tool to weld the emitter to the floor, allowing it to fire."

/decl/machine_construction/emitter/welded
	anchored = TRUE
	up_state = /decl/machine_construction/emitter/anchored

/decl/machine_construction/emitter/welded/wrench_interaction(obj/item/used_item, mob/user, obj/machinery/emitter/machine)
	to_chat(user, SPAN_WARNING("\The [machine] needs to be unwelded from the floor."))
	return TRUE

/decl/machine_construction/emitter/welded/welder_interaction(obj/item/weldingtool/welder, mob/user, obj/machinery/emitter/machine)
	if(!welder.do_tool_interaction(TOOL_WELDER, user, machine, 2 SECONDS, \
		"cutting free", \
		"cutting free", \
		"You fail to cut \the [machine] free from the floor.", \
		fuel_expenditure = 1) \
	)
		return TRUE // failed for whatever reason
	TRANSFER_STATE(up_state)
	return TRUE

/decl/machine_construction/emitter/welded/mechanics_info()
	. = ..()
	. += "Use a welding tool to cut the emitter free from the floor."

// Emitters built from a circuitboard also have a maintenance hatch, giving one state per (bolting, hatch) pair.
/decl/machine_construction/emitter/unsecured/gyrotron
	needs_board = "machine"
	down_state = /decl/machine_construction/emitter/anchored/gyrotron
	panel_state = /decl/machine_construction/emitter/unsecured/gyrotron/panel_open

/decl/machine_construction/emitter/unsecured/gyrotron/panel_open
	panel_open = TRUE
	visible_components = TRUE
	down_state = /decl/machine_construction/emitter/anchored/gyrotron/panel_open
	panel_state = /decl/machine_construction/emitter/unsecured/gyrotron

/decl/machine_construction/emitter/anchored/gyrotron
	needs_board = "machine"
	down_state = /decl/machine_construction/emitter/welded/gyrotron
	up_state = /decl/machine_construction/emitter/unsecured/gyrotron
	panel_state = /decl/machine_construction/emitter/anchored/gyrotron/panel_open

/decl/machine_construction/emitter/anchored/gyrotron/panel_open
	panel_open = TRUE
	visible_components = TRUE
	down_state = /decl/machine_construction/emitter/welded/gyrotron/panel_open
	up_state = /decl/machine_construction/emitter/unsecured/gyrotron/panel_open
	panel_state = /decl/machine_construction/emitter/anchored/gyrotron

/decl/machine_construction/emitter/welded/gyrotron
	needs_board = "machine"
	up_state = /decl/machine_construction/emitter/anchored/gyrotron
	panel_state = /decl/machine_construction/emitter/welded/gyrotron/panel_open

/decl/machine_construction/emitter/welded/gyrotron/panel_open
	panel_open = TRUE
	visible_components = TRUE
	up_state = /decl/machine_construction/emitter/anchored/gyrotron/panel_open
	panel_state = /decl/machine_construction/emitter/welded/gyrotron
