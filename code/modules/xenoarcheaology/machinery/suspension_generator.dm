/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "Multi-phase mobile suspension field generator MK II \"Steadfast\". It has stubby legs bolted up against it's body for stabilising."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "suspension2"
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	active_power_usage = 5 KILOWATTS
	var/obj/effect/suspension_field/suspension_field
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock/sci = 1
	)

/decl/stock_part_preset/access_lock/sci
	req_access = list(access_research)

/obj/machinery/suspension_gen/Process()
	if(suspension_field)
		if(stat & NOPOWER)
			deactivate()
			return
		if(suspension_field.victim_number)
			use_power_oneoff(active_power_usage * suspension_field.victim_number)

/obj/machinery/suspension_gen/proc/locked()
	for(var/obj/item/stock_parts/access_lock/lock in get_all_components_of_type(/obj/item/stock_parts/access_lock))
		if(lock.locked)
			return TRUE
	return FALSE

/obj/machinery/suspension_gen/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/obj/item/cell/cell = get_cell()
	if(cell)
		data["charge"] = round(cell.percent())
	data["active"] = !!suspension_field
	data["locked"] = locked()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "suspension_gen.tmpl", "Suspension Field Generator", 400, 190)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/suspension_gen/OnTopic(var/mob/user, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["toggle_field"])
		if(locked())
			to_chat(user, SPAN_WARNING("You need to unlock the controls first."))
			return TOPIC_HANDLED
		if(!suspension_field)
			var/obj/item/cell/cell = get_cell()
			if(cell?.charge > 0)
				if(anchored)
					activate()
				else
					to_chat(user, SPAN_WARNING("You are unable to activate [src] until it is properly secured on the ground."))
		else
			deactivate()
		. = TOPIC_REFRESH

/obj/machinery/suspension_gen/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/suspension_gen/components_are_accessible(path)
	return !suspension_field && ..()

/obj/machinery/suspension_gen/cannot_transition_to(state_path)
	if(suspension_field)
		return SPAN_NOTICE("Turn \the [src] off first.")
	return ..()

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	var/turf/T = get_turf(get_step(src,dir))
	suspension_field = new(T)
	visible_message(SPAN_NOTICE("[html_icon(src)] [src] activates with a low hum."))
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/suspension_gen/proc/deactivate()
	visible_message(SPAN_NOTICE("[src] deactivates with a gentle shudder."))
	QDEL_NULL(suspension_field)
	update_use_power(POWER_USE_IDLE)

/obj/machinery/suspension_gen/on_update_icon()
	if(suspension_field)
		icon_state = "suspension3"
	else
		icon_state = "suspension2"

/obj/machinery/suspension_gen/Destroy()
	deactivate()
	return ..()

/obj/effect/suspension_field
	name = "energy field"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = TRUE
	var/victim_number  //number of mobs it affected, needed for generator powerdraw calc

/obj/effect/suspension_field/examine(mob/user)
	. = ..()
	if(.)
		to_chat(user, SPAN_NOTICE("You can see something floating inside it:"))
		to_chat(user, SPAN_NOTICE(english_list(contents)))

/obj/effect/suspension_field/Initialize()
	. = ..()
	suspend_things()
	START_PROCESSING(SSobj, src)

/obj/effect/suspension_field/Destroy()
	for(var/mob/living/M in loc)
		to_chat(M, SPAN_NOTICE("You no longer feel like floating."))
	for(var/atom/movable/A in src)
		A.dropInto(loc)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/suspension_field/Process()
	suspend_things()

/obj/effect/suspension_field/proc/suspend_things()
	victim_number = 0
	var/turf/T = get_turf(src)
	if(T)
		for(var/mob/living/M in T)
			SET_STATUS_MAX(M, STAT_WEAK, 3)
			victim_number++
			if(prob(5))
				to_chat(M, SPAN_WARNING("[pick("You feel tingly","You feel like floating","It is hard to speak","You can barely move")]."))
		for(var/obj/item/I in T)
			if(!I.anchored && I.simulated)
				I.forceMove(src)
	update_icon()

/obj/effect/suspension_field/on_update_icon()
	overlays.Cut()
	var/turf/T = get_turf(src)
	if(T?.is_wall())
		icon_state = "shieldsparkles"
	else
		icon_state = "shield2"
	if(contents.len)
		underlays += "energynet"
