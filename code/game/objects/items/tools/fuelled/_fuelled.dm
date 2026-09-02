/obj/item/fuelled_tool
	abstract_type = /obj/item/fuelled_tool
	icon_state      = ICON_STATE_WORLD
	obj_flags       = OBJ_FLAG_CONDUCTIBLE
	throw_speed     = 1
	throw_range     = 5
	w_class         = ITEM_SIZE_SMALL
	material        = /decl/material/solid/metal/steel
	matter          = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech     = @'{"engineering":1}'
	drop_sound      = 'sound/foley/tooldrop1.ogg'
	attack_cooldown = DEFAULT_ATTACK_COOLDOWN

	var/idle_fuel_usage               = 0.5
	var/waterproof                    = FALSE
	/// Whether or not the tool is off(0), on(1) or currently running(2)
	var/running_state                 = FALSE
	var/tmp/fuel_name                 = /decl/material/liquid/fuel::name
	/// where the fuel is stored
	var/obj/item/chems/fuel_tank/tank = /obj/item/chems/fuel_tank
	var/tmp/activate_sound            = 'sound/items/welderactivate.ogg'
	var/tmp/deactivate_sound          = 'sound/items/welderdeactivate.ogg'
	var/datum/composite_sound/running_loop

/obj/item/fuelled_tool/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	if(ispath(tank))
		insert_tank(new tank, null, TRUE, TRUE)
	if(ispath(running_loop))
		running_loop = new running_loop(list(src), FALSE)
	update_icon()

/obj/item/fuelled_tool/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(tank)
	if(istype(running_loop))
		QDEL_NULL(running_loop)
	return ..()

/obj/item/fuelled_tool/attack_hand(mob/user)
	if (tank && user.is_holding_offhand(src) && user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return remove_tank(user)
	return ..()

/obj/item/fuelled_tool/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/chems/fuel_tank))
		insert_tank(used_item, user)
		return TRUE
	. = ..()

/obj/item/fuelled_tool/dropped(mob/user)
	. = ..()
	if(running_state)
		update_icon()

/obj/item/fuelled_tool/equipped(mob/user, slot)
	. = ..()
	if(running_state)
		update_icon()

/obj/item/fuelled_tool/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "It has [round(get_fuel(), 0.1)] [fuel_name] remaining."
		if (tank)
			. += "\The [tank] is attached."

/obj/item/fuelled_tool/proc/insert_tank(var/obj/item/chems/fuel_tank/T, var/mob/user, var/no_updates = FALSE, var/quiet = FALSE)
	if(tank && !ispath(tank))
		if(user && !quiet)
			to_chat(user, SPAN_WARNING("\The [src] already has a tank attached - remove it first."))
		return

	if(user && !(src in user.get_held_items()))
		if(user && !quiet)
			to_chat(user, SPAN_WARNING("You must hold \the [src] in your hands to attach a tank."))
		return

	if(user && !user.try_unequip(T, src))
		return

	tank    = T
	w_class = tank.size_in_use
	set_base_attack_force(tank.unlit_force)
	if(user && !quiet)
		user.visible_message("[user] slots \a [T] into \the [src].", "You slot \a [T] into \the [src].")

	if(!quiet)
		playsound(loc, 'sound/effects/hypospray.ogg', 50, TRUE)
	if(!no_updates)
		update_icon()
	return TRUE

/obj/item/fuelled_tool/proc/remove_tank(var/mob/user)
	if(!tank || ispath(tank))
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a tank attached."))
		return

	if(running_state)
		if(user)
			to_chat(user, SPAN_WARNING("Stop using \the [src] first."))
		return

	if(user && !user.is_holding_offhand(src))
		if(user)
			to_chat(user, SPAN_WARNING("You must hold \the [src] in your hands to detach its tank."))
		return

	if(user)
		user.put_in_hands(tank)
		user.visible_message("[user] removes \the [tank] from \the [src].", "You remove \the [tank] from \the [src].")
	else
		tank.dropInto(get_turf(src))

	tank    = null
	w_class = initial(w_class)
	set_base_attack_force(get_initial_base_attack_force())
	update_icon()
	return TRUE

/obj/item/fuelled_tool/afterattack(var/atom/target, var/mob/user, proximity, click_parameters)
	return handle_afterattack(target, user, proximity, click_parameters) || ..()

/obj/item/fuelled_tool/proc/handle_afterattack(var/atom/target, var/mob/user, proximity, click_parameters)
	if(proximity && istype(target, /obj/structure/reagent_dispensers/fueltank) && !running_state)
		if(tank)
			return tank.afterattack(target, user, proximity, click_parameters)
		to_chat(user, SPAN_WARNING("\The [src] has no tank attached!"))
	return FALSE

/obj/item/fuelled_tool/attack_self(mob/user)
	toggle(user)
	return TRUE

//Returns the amount of fuel in the welder
/obj/item/fuelled_tool/proc/get_fuel()
	return istype(tank) ? REAGENT_VOLUME(tank.reagents, /decl/material/liquid/fuel) : 0

/obj/item/fuelled_tool/proc/use_fuel(var/amount)
	. = TRUE
	if(get_fuel() < amount)
		. = FALSE //Try to burn as much as possible anyways
	if(tank)
		tank.remove_from_reagents(/decl/material/liquid/fuel, amount)

//Returns whether or not the tool is currently on.
/obj/item/fuelled_tool/proc/isOn()
	return !!running_state

/obj/item/fuelled_tool/on_update_icon()
	. = ..()
	if(tank)
		add_overlay("[icon_state]-[tank.icon_state]")

/obj/item/fuelled_tool/proc/get_running_force()
	return get_initial_base_attack_force()

/obj/item/fuelled_tool/proc/get_running_damage_type()
	return BRUTE

/**Handles updating damage depening on whether the welder is on or off */
/obj/item/fuelled_tool/proc/update_physical_damage()
	atom_damage_type = get_running_damage_type()
	set_base_attack_force(get_running_force())

/obj/item/fuelled_tool/proc/can_turn_on(mob/user)
	if(!waterproof && submerged())
		if(user)
			to_chat(user, SPAN_WARNING("You cannot start \the [src] underwater."))
		return FALSE
	if(get_fuel() <= 0)
		if(user)
			to_chat(user, SPAN_NOTICE("You need [fuel_name] to start \the [src]."))
		return FALSE
	return TRUE

/obj/item/fuelled_tool/proc/perform_activation_check(mob/user)
	return TRUE

/obj/item/fuelled_tool/proc/show_activation_message(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] turns \the [src] on."), SPAN_NOTICE("You turn on \the [src]."))

/obj/item/fuelled_tool/proc/turn_on(var/mob/user)
	if (!can_turn_on(user))
		return

	if(!perform_activation_check(user))
		return

	if(user)
		show_activation_message(user)
	else
		visible_message(SPAN_WARNING("\The [src] turns on."))

	playsound(src, activate_sound, 50, TRUE)
	if(running_loop && !running_loop.started)
		running_loop.start(src)

	running_state = TRUE
	obj_flags |= OBJ_FLAG_NO_STORAGE
	update_physical_damage()
	update_icon()
	update_held_icon()
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/item/fuelled_tool/proc/turn_off(var/mob/user)
	STOP_PROCESSING(SSobj, src)

	if(user)
		user.visible_message(SPAN_NOTICE("\The [user] turns \the [src] off."), SPAN_NOTICE("You switch \the [src] off."))
	else
		visible_message(SPAN_WARNING("\The [src] turns off."))

	if(deactivate_sound)
		playsound(src, deactivate_sound, 50, TRUE)
	if(running_loop?.started)
		running_loop.stop(src)

	running_state = FALSE
	obj_flags &= ~OBJ_FLAG_NO_STORAGE
	update_physical_damage()
	update_icon()
	update_held_icon()
	return TRUE

/obj/item/fuelled_tool/proc/toggle(var/mob/user)
	if(running_state)
		return turn_off(user)
	return turn_on(user)

/obj/item/fuelled_tool/proc/handle_idling(fuel_usage = 0.5)
	return use_fuel(fuel_usage)

// Handle burning fuel while the tool is running.
/obj/item/fuelled_tool/Process()
	..()
	if(!running_state)
		return PROCESS_KILL
	if((!waterproof && submerged()) || (get_fuel() < idle_fuel_usage) || !handle_idling(idle_fuel_usage))
		turn_off()
