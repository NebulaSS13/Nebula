/obj/item/stock_parts/access_lock
	name = "access lock"
	desc = "An id-based access lock preventing tampering with a machine's hardware."
	icon_state = "scan_module"
	part_flags = PART_FLAG_QDEL | PART_FLAG_NODAMAGE
	req_access = list(access_engine_equip) // set req_access on this to impose access requirements.
	var/locked = FALSE
	var/emagged = FALSE

/obj/machinery/cannot_transition_to(state_path, mob/user)
	var/decl/machine_construction/state = decls_repository.get_decl(state_path)
	if(state && !state.locked && construct_state && construct_state.locked) // we're locked, we're becoming unlocked
		for(var/obj/item/stock_parts/access_lock/lock in get_all_components_of_type(/obj/item/stock_parts/access_lock))
			if(lock.locked && !lock.check_access(user))
				return SPAN_WARNING("\The [lock] flashes red! You lack the access to unlock this.")
	return ..()

/obj/item/stock_parts/access_lock/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(length(req_access) && locked && istype(loc, /obj/machinery)) // Don't emag it outside; you can just cut access without it anyway.
		locked = FALSE
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You slide the card into \the [src]. It flashes purple briefly, then disengages."))
		. = max(., 1)

/obj/item/stock_parts/access_lock/on_install(obj/machinery/machine)
	. = ..()
	if(!emagged)
		locked = TRUE

/obj/item/stock_parts/access_lock/on_uninstall(obj/machinery/machine)
	. = ..()
	locked = FALSE

/obj/item/stock_parts/access_lock/on_fail(obj/machinery/machine, damtype)
	. = ..()
	locked = FALSE

/obj/item/stock_parts/access_lock/examine(mob/user)
	. = ..()
	if(locked)
		to_chat(user, "The lock is engaged.")
	if(emagged && user.skill_check_multiple(list(SKILL_FORENSICS = SKILL_EXPERT, SKILL_COMPUTER = SKILL_EXPERT)))
		to_chat(user, SPAN_WARNING("On close inspection, there is something odd about the interface. You suspect it may have been tampered with."))

/obj/item/stock_parts/access_lock/attackby(obj/item/W, mob/user)
	var/obj/machinery/machine = loc
	if(!emagged && istype(machine))
		if(check_access(W))
			locked = !locked
			visible_message(SPAN_NOTICE("\The [src] beeps and flashes green twice: it is now [locked ? "" : "un"]locked."))
			return TRUE
		return

	if(isMultitool(W)) // This is a non-machine interaction only; doing this within a machine will likely lead to interaction clashes.
		var/list/accesses = user.GetAccess()
		var/list/choices = list()
		for(var/key in accesses)
			choices[get_access_desc(key)] = key
		choices["No Access"] = "No Access"
		var/default = length(req_access) ? req_access[1] : null
		var/selected_desc = input(user, "Select the access you would like \the [src] to use:", "Access Modification", default) as null|anything in choices
		. = TRUE
		if(!CanPhysicallyInteract(user))
			return
		if(!selected_desc)
			return
		if(selected_desc == "No Access")
			req_access.Cut()
			return
		if(!(choices[selected_desc] in user.GetAccess()))
			return
		req_access = list(choices[selected_desc])
		return

	return ..()

/obj/item/stock_parts/access_lock/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	material = MAT_STEEL
	matter = list(MAT_GLASS = MATTER_AMOUNT_REINFORCEMENT)

/decl/stock_part_preset/access_lock
	expected_part_type = /obj/item/stock_parts/access_lock
	var/list/req_access = list()

/decl/stock_part_preset/access_lock/do_apply(obj/machinery/machine, obj/item/stock_parts/access_lock/part)
	part.req_access = req_access.Copy()