/obj/item/stock_parts/circuitboard/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	material = /decl/material/solid/glass
	req_access = list(access_engine)

	build_path = /obj/machinery/door/airlock
	board_type = "door"

	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
		/obj/item/stock_parts/power/apc/buildable
	) // The borg UI thing doesn't need screen/keyboard as borgs don't need those.

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = list()
	var/one_access = 0 //if set to 1, door would receive OR instead of AND on the access restrictions.
	var/last_configurator = null
	var/locked = 1
	var/lockable = 1
	var/autoset = TRUE // Whether the door should inherit access from surrounding areas

/obj/item/stock_parts/circuitboard/airlock_electronics/attack_self(mob/user)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	ui_interact(user)

/obj/item/stock_parts/circuitboard/airlock_electronics/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.hands_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics.tmpl", src.name, 1000, 500, null, null, state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/stock_parts/circuitboard/airlock_electronics/ui_data()
	var/list/data = list()
	var/list/regions = list()

	for(var/i in ACCESS_REGION_MIN to ACCESS_REGION_MAX) //code/game/jobs/_access_defs.dm
		var/list/region = list()
		var/list/accesses = list()
		for(var/j in get_region_accesses(i))
			var/list/access = list()
			access["name"] = get_access_desc(j)
			access["id"] = j
			access["req"] = (j in src.conf_access)
			accesses[++accesses.len] = access
		region["name"] = get_region_accesses_name(i)
		region["accesses"] = accesses
		regions[++regions.len] = region
	data["regions"] = regions
	data["oneAccess"] = one_access
	data["locked"] = locked
	data["lockable"] = lockable
	data["autoset"] = autoset

	return data

/obj/item/stock_parts/circuitboard/airlock_electronics/OnTopic(mob/user, list/href_list, state)
	if(lockable)
		if(href_list["unlock"])
			if(!req_access || istype(user, /mob/living/silicon))
				locked = FALSE
				last_configurator = user.name
			else
				var/obj/item/card/id/I = user.get_active_hand()
				I = I ? I.GetIdCard() : null
				if(!istype(I, /obj/item/card/id))
					to_chat(user, SPAN_WARNING("[\src] flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?"))
					return TOPIC_HANDLED
				if (check_access(I))
					locked = FALSE
					last_configurator = I.registered_name
				else
					to_chat(user, SPAN_WARNING("[\src] flashes a red LED near the ID scanner, indicating your access has been denied."))
					return TOPIC_HANDLED
			return TOPIC_REFRESH
		else if(href_list["lock"])
			locked = TRUE
			return TOPIC_REFRESH

	if(href_list["clear"])
		conf_access = list()
		one_access = FALSE
		return TOPIC_REFRESH
	if(href_list["one_access"])
		one_access = !one_access
		return TOPIC_REFRESH
	if(href_list["autoset"])
		autoset = !autoset
		return TOPIC_REFRESH
	if(href_list["access"])
		var/access = href_list["access"]
		if (!(access in conf_access))
			conf_access += access
		else
			conf_access -= access
		return TOPIC_REFRESH

/obj/item/stock_parts/circuitboard/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = "{'programming':2}"
	secure = TRUE

/obj/item/stock_parts/circuitboard/airlock_electronics/windoor
	icon_state = "door_electronics_smoked"
	name = "window door electronics"
	build_path = /obj/machinery/door/window
	additional_spawn_components = list()

/obj/item/stock_parts/circuitboard/airlock_electronics/morgue
	name = "morgue door electronics"
	build_path = /obj/machinery/door/morgue
	additional_spawn_components = list()

/obj/item/stock_parts/circuitboard/airlock_electronics/blast
	name = "blast door and shutter electronics"
	build_path = /obj/machinery/door/blast
	additional_spawn_components = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/power/apc/buildable
	)

/obj/item/stock_parts/circuitboard/airlock_electronics/brace
	name = "airlock brace access circuit"
	build_path = /obj/item/airlock_brace // idk why they use this; I think it's just to share the UI. This isn't used to build machines.
	req_access = list()
	locked = FALSE
	lockable = FALSE

/obj/item/stock_parts/circuitboard/airlock_electronics/firedoor
	name = "fire door electronics"
	build_path = /obj/machinery/door/firedoor
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable
	)

/obj/item/stock_parts/circuitboard/airlock_electronics/brace/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.deep_inventory_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics.tmpl", src.name, 1000, 500, null, null, state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/stock_parts/circuitboard/airlock_electronics/proc/set_access(var/obj/object)
	if(LAZYLEN(object.req_access))
		conf_access = list()
		for(var/entry in object.req_access)
			conf_access |= entry // This flattens the list, turning everything into AND
			// Can be reworked to have the electronics inherit a precise access set, but requires UI changes.

/obj/item/stock_parts/circuitboard/airlock_electronics/construct(obj/machinery/door/door)
	. = ..()
	if(!istype(door))
		return
	//update the door's access to match the electronics'
	if(autoset)
		door.autoset_access = TRUE
	else
		door.req_access = conf_access
		if(one_access)
			door.req_access = list(door.req_access)
		door.autoset_access = FALSE // We just set it, so don't try and do anything fancy later.
	if(istype(door, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock = door
		airlock.secured_wires = secure

/obj/item/stock_parts/circuitboard/airlock_electronics/deconstruct(obj/machinery/door/door)
	. = ..()
	if(!istype(door))
		return
	set_access(door)
	autoset = door.autoset_access
	if(istype(door, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock = door
		secure = airlock.secured_wires