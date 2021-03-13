/obj/item/stock_parts/access_lock
	name = "access lock"
	desc = "An id-based access lock preventing tampering with a machine's hardware."
	icon_state = "lock"
	part_flags = PART_FLAG_QDEL | PART_FLAG_NODAMAGE
	req_access = list(access_engine_equip) // set req_access on this to impose access requirements.
	var/locked = FALSE
	var/emagged = FALSE
	var/autoset = FALSE  // Whether the machine should inherit access from surrounding areas
	var/list/conf_access
	var/one_access = FALSE //if set, door would receive OR instead of AND on the access restrictions.

/obj/machinery/cannot_transition_to(state_path, mob/user)
	var/decl/machine_construction/state = GET_DECL(state_path)
	if(state && !state.locked && construct_state && construct_state.locked) // we're locked, we're becoming unlocked
		for(var/obj/item/stock_parts/access_lock/lock in get_all_components_of_type(/obj/item/stock_parts/access_lock))
			if(lock.locked && !lock.check_access(user))
				return SPAN_WARNING("\The [lock] flashes red! You lack the access to unlock this.")
	return ..()

/obj/item/stock_parts/access_lock/get_req_access()
	if(istype(loc, /obj/machinery)) // so you can set up accesses you don't have
		return ..()
	return null

/obj/item/stock_parts/access_lock/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(length(req_access) && locked && istype(loc, /obj/machinery)) // Don't emag it outside; you can just cut access without it anyway.
		locked = FALSE
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You slide the card into \the [src]. It flashes purple briefly, then disengages."))
		. = max(., 1)

/obj/item/stock_parts/access_lock/on_install(obj/machinery/machine)
	. = ..()
	if(autoset)
		req_access = machine.get_auto_access()
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
		var/obj/item/card/id/I = W.GetIdCard()
		if(I && check_access(I))
			locked = !locked
			visible_message(SPAN_NOTICE("\The [src] beeps and flashes green twice: it is now [locked ? "" : "un"]locked."))
			return TRUE
		return
	return ..()

/obj/item/stock_parts/access_lock/attack_self(mob/user)
	ui_interact(user)

/obj/item/stock_parts/access_lock/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.hands_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics.tmpl", src.name, 1000, 500, null, null, state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/stock_parts/access_lock/ui_data()
	var/list/data = list()
	var/list/regions = list()
	if(!autoset)
		for(var/i in ACCESS_REGION_MIN to ACCESS_REGION_MAX) //code/game/jobs/_access_defs.dm
			var/list/region = list()
			var/list/accesses = list()
			for(var/j in get_region_accesses(i))
				var/list/access = list()
				access["name"] = get_access_desc(j)
				access["id"] = j
				access["req"] = conf_access && (j in conf_access)
				accesses[++accesses.len] = access
			region["name"] = get_region_accesses_name(i)
			region["accesses"] = accesses
			regions[++regions.len] = region
		data["regions"] = regions
		data["oneAccess"] = one_access
	data["locked"] = locked
	data["lockable"] = !emagged
	data["autoset"] = autoset
	return data

/obj/item/stock_parts/access_lock/OnTopic(mob/user, list/href_list, state)
	if(!emagged)
		if(href_list["unlock"])
			if(!req_access)
				locked = FALSE
			else
				var/obj/item/card/id/I = user.GetIdCard()				
				if(!istype(I, /obj/item/card/id))
					to_chat(user, SPAN_WARNING("[\src] flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?"))
					return TOPIC_HANDLED
				if (check_access(I))
					locked = FALSE
				else
					to_chat(user, SPAN_WARNING("[\src] flashes a red LED near the ID scanner, indicating your access has been denied."))
					return TOPIC_HANDLED
			return TOPIC_REFRESH
		else if(href_list["lock"])
			locked = TRUE
			return TOPIC_REFRESH

	if(href_list["clear"])
		conf_access = null
		one_access = FALSE
		update_access()
		return TOPIC_REFRESH
	if(href_list["one_access"])
		one_access = !one_access
		update_access()
		return TOPIC_REFRESH
	if(href_list["autoset"])
		autoset = !autoset
		return TOPIC_REFRESH
	if(href_list["access"])
		var/access = href_list["access"]
		if (!conf_access || !(access in conf_access))
			LAZYADD(conf_access, access)
		else
			LAZYREMOVE(conf_access, access)
		update_access()
		return TOPIC_REFRESH

/obj/item/stock_parts/access_lock/proc/update_access()
	if(!conf_access)
		req_access = list()
		return
	if(one_access)
		req_access = list(conf_access.Copy())
	else
		req_access = conf_access.Copy()
/obj/item/stock_parts/access_lock/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/decl/stock_part_preset/access_lock
	expected_part_type = /obj/item/stock_parts/access_lock
	var/list/req_access = list()

/decl/stock_part_preset/access_lock/do_apply(obj/machinery/machine, obj/item/stock_parts/access_lock/part)
	part.req_access = req_access.Copy()