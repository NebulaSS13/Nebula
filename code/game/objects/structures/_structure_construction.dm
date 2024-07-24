/obj/structure
	var/wired
	var/tool_interaction_flags

/obj/structure/proc/handle_default_wrench_attackby(var/mob/user, var/obj/item/wrench)
	if((tool_interaction_flags & TOOL_INTERACTION_ANCHOR) && can_unanchor(user))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		visible_message(SPAN_NOTICE("\The [user] begins [anchored ? "unsecuring [src]" : "securing [src] in place"] with \the [wrench]."))
		if(!do_after(user, 4 SECONDS, src) || QDELETED(src))
			return TRUE
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [user] has [anchored ? "secured" : "unsecured"] \the [src] with \the [wrench]."))
		update_icon()
		return TRUE
	return FALSE

/obj/structure/proc/handle_default_welder_attackby(var/mob/user, var/obj/item/weldingtool/welder)
	if((tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT) && can_dismantle(user))
		if(material && !material.removed_by_welder)
			to_chat(user, SPAN_WARNING("\The [src] is too delicate to be dismantled with \the [welder]; try a crowbar."))
			return TRUE
		if(!welder.isOn())
			to_chat(user, SPAN_WARNING("Try lighting \the [welder] first."))
			return TRUE
		if(welder.get_fuel() < 5)
			to_chat(user, SPAN_WARNING("You need more fuel to complete this task."))
			return TRUE
		playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
		visible_message(SPAN_NOTICE("\The [user] starts slicing apart \the [src] with \the [welder]."))
		if(!do_after(user, 3 SECONDS, src) || QDELETED(src) || !welder.weld(5, user))
			return TRUE
		playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
		visible_message(SPAN_NOTICE("\The [user] completely dismantles \the [src] with \the [welder]."))
		dismantle_structure(user)
		return TRUE
	return FALSE

/obj/structure/proc/handle_default_crowbar_attackby(var/mob/user, var/obj/item/crowbar)
	if((tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT) && can_dismantle(user))
		if(material && material.removed_by_welder)
			to_chat(user, SPAN_WARNING("\The [src] is too robust to be dismantled with \the [crowbar]; try a welding tool."))
			return TRUE
		playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		visible_message(SPAN_NOTICE("\The [user] starts levering apart \the [src] with \the [crowbar]."))
		if(!do_after(user, 5 SECONDS, src) || QDELETED(src))
			return TRUE
		playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		visible_message(SPAN_NOTICE("\The [user] completely dismantles \the [src] with \the [crowbar]."))
		dismantle_structure(user)
		return TRUE
	return FALSE

/obj/structure/proc/handle_default_cable_attackby(var/mob/user, var/obj/item/stack/cable_coil/coil)
	if((tool_interaction_flags & TOOL_INTERACTION_WIRING) && anchored)
		if(wired)
			to_chat(user, SPAN_WARNING("\The [src] has already been wired."))
			return TRUE
		var/obj/item/stack/cable_coil/cable = coil
		if(cable.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You need one length of coil to wire \the [src]."))
		else
			visible_message(SPAN_NOTICE("\The [user] starts to wire \the [src]."))
			if(do_after(user, 4 SECONDS, src) && !wired && anchored && !QDELETED(src) && cable.use(1))
				wired = TRUE
				visible_message(SPAN_NOTICE("\The [user] finishes wiring \the [src]."))
		return TRUE
	return FALSE

/obj/structure/proc/handle_default_wirecutter_attackby(var/mob/user, var/obj/item/wirecutters/wirecutters)
	if((tool_interaction_flags & TOOL_INTERACTION_WIRING) && anchored)
		if(!wired)
			to_chat(user, SPAN_WARNING("\The [src] has not been wired."))
			return TRUE
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		visible_message(SPAN_NOTICE("\The [user] begins stripping the wiring out of \the [src]."))
		if(do_after(user, 4 SECONDS, src) && !QDELETED(src) && wired)
			visible_message(SPAN_NOTICE("\The [user] finishes stripping the wiring from \the [src]."))
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = FALSE
		return TRUE
	return FALSE

/obj/structure/proc/handle_default_screwdriver_attackby(var/mob/user, var/obj/item/screwdriver)
	return FALSE

/obj/structure/proc/can_unanchor(var/mob/user)
	if(anchored && wired)
		to_chat(user, SPAN_WARNING("\The [src] needs to have its wiring stripped out before you can unanchor it."))
		return FALSE
	return TRUE

/obj/structure/proc/can_dismantle(var/mob/user)
	if(!anchored && (tool_interaction_flags & TOOL_INTERACTION_ANCHOR))
		to_chat(user, SPAN_WARNING("\The [src] needs to be anchored before you can dismantle it."))
		return FALSE
	if(wired && (tool_interaction_flags & TOOL_INTERACTION_WIRING))
		to_chat(user, SPAN_WARNING("\The [src] needs to have its wiring stripped out before you can dismantle it."))
		return FALSE
	return TRUE

/obj/structure/proc/can_repair_with(var/obj/item/tool)
	. = istype(tool, /obj/item/stack/material) && tool.get_material_type() == get_material_type()

/obj/structure/proc/handle_repair(mob/user, obj/item/tool)
	var/current_max_health = get_max_health()
	var/obj/item/stack/stack = tool
	var/amount_needed = CEILING((current_max_health - current_health)/DOOR_REPAIR_AMOUNT)
	var/used = min(amount_needed,stack.amount)
	if(used)
		to_chat(user, SPAN_NOTICE("You fit [stack.get_string_for_amount(used)] to damaged areas of \the [src]."))
		stack.use(used)
		last_damage_message = null
		current_health = clamp(current_health + used*DOOR_REPAIR_AMOUNT, current_health, current_max_health)

/obj/structure/attackby(obj/item/used_item, mob/user)
	if(used_item.user_can_wield(user, silent = TRUE))
		if(used_item.force && user.a_intent == I_HURT)
			attack_animation(user)
			visible_message(SPAN_DANGER("\The [src] has been [pick(used_item.attack_verb)] with \the [used_item] by \the [user]!"))
			take_damage(used_item.force, used_item.atom_damage_type)
			. = TRUE

		else if(IS_WRENCH(used_item))
			. = handle_default_wrench_attackby(user, used_item)
		else if(IS_SCREWDRIVER(used_item))
			. = handle_default_screwdriver_attackby(user, used_item)
		else if(IS_WELDER(used_item))
			. = handle_default_welder_attackby(user, used_item)
		else if(IS_CROWBAR(used_item))
			. = handle_default_crowbar_attackby(user, used_item)
		else if(IS_COIL(used_item))
			. = handle_default_cable_attackby(user, used_item)
		else if(IS_WIRECUTTER(used_item))
			. = handle_default_wirecutter_attackby(user, used_item)
		else if(can_repair_with(used_item) && can_repair(user))
			. = handle_repair(user, used_item)
		if(.)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			add_fingerprint(user)
			return .
	return ..()

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/environment_smash)
	if(environment_smash >= 1)
		damage = max(damage, 10)

	if(istype(user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
	if(!damage)
		return FALSE
	if(damage >= 10)
		visible_message(SPAN_DANGER("\The [user] [attack_verb] into [src]!"))
		take_damage(damage)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))
	return TRUE