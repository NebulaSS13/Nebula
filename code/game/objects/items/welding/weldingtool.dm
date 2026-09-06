#define WELDING_TOOL_HOTSPOT_TEMP_ACTIVE 700
#define WELDING_TOOL_HOTSPOT_TEMP_IDLE   400

/obj/item/weldingtool
	name                                = "welding tool"
	desc                                = "A portable welding gun with a port for attaching fuel tanks."
	icon                                = 'icons/obj/items/tool/welders/welder.dmi'
	icon_state                          = ICON_STATE_WORLD
	obj_flags                           = OBJ_FLAG_CONDUCTIBLE
	slot_flags                          = SLOT_LOWER_BODY
	center_of_mass                      = @'{"x":14,"y":15}'
	throw_speed                         = 1
	throw_range                         = 5
	w_class                             = ITEM_SIZE_SMALL
	material                            = /decl/material/solid/metal/steel
	matter                              = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech                         = @'{"engineering":1}'
	drop_sound                          = 'sound/foley/tooldrop1.ogg'
	z_flags                             = ZMM_MANGLE_PLANES
	attack_cooldown                     = DEFAULT_ATTACK_COOLDOWN
	var/lit_colour                      = COLOR_PALE_ORANGE
	var/waterproof                      = FALSE
	var/welding                         = FALSE 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status                          = TRUE 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/tmp/welding_resource            = "welding fuel"
	var/obj/item/chems/welder_tank/tank = /obj/item/chems/welder_tank // where the fuel is stored
	var/tmp/activate_sound              = 'sound/items/welderactivate.ogg'
	var/tmp/deactivate_sound            = 'sound/items/welderdeactivate.ogg'

/obj/item/weldingtool/Initialize()
	if(ispath(tank))
		insert_tank(new tank, null, TRUE, TRUE)
	set_extension(src, /datum/extension/tool, list(TOOL_WELDER = TOOL_QUALITY_DEFAULT))
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	set_extension(src, /datum/extension/demolisher/welder)
	. = ..()
	update_icon()

/obj/item/weldingtool/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(tank)
	return ..()

/obj/item/weldingtool/dropped(mob/user)
	. = ..()
	if(welding)
		update_icon()

/obj/item/weldingtool/equipped(mob/user, slot)
	. = ..()
	if(welding)
		update_icon()

/obj/item/weldingtool/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && welding && check_state_in_icon("[overlay.icon_state]-lit", overlay.icon))
		overlay.add_overlay(emissive_overlay(overlay.icon, "[overlay.icon_state]-lit"))
	. = ..()

/obj/item/weldingtool/get_heat()
	. = max(..(), isOn() ? 3800 : 0)

/obj/item/weldingtool/isflamesource()
	. = isOn()

/obj/item/weldingtool/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "It has [round(get_fuel(), 0.1)] [welding_resource] remaining."
		if (tank)
			. += "\The [tank] is attached."

/obj/item/weldingtool/proc/insert_tank(var/obj/item/chems/welder_tank/T, var/mob/user, var/no_updates = FALSE, var/quiet = FALSE)
	if(tank && !ispath(tank))
		if(user && !quiet)
			to_chat(user, SPAN_WARNING("\The [src] already has a tank attached - remove it first."))
		return

	if(user && !(src in user.get_held_items()))
		if(user && !quiet)
			to_chat(user, SPAN_WARNING("You must hold the welder in your hands to attach a tank."))
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

/obj/item/weldingtool/proc/remove_tank(var/mob/user)
	if(!tank || ispath(tank))
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a tank attached."))
		return

	if(welding)
		if(user)
			to_chat(user, SPAN_WARNING("Stop welding first."))
		return

	if(user && !user.is_holding_offhand(src))
		if(user)
			to_chat(user, SPAN_WARNING("You must hold the welder in your hands to detach its tank."))
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

/obj/item/weldingtool/proc/toggle_unscrewed(var/mob/user)
	if(isrobot(loc))
		if(user)
			to_chat(user, SPAN_WARNING("You cannot modify your own welder!"))
		return

	status = !status
	if(user)
		if(status)
			to_chat(user, SPAN_NOTICE("You secure the welder."))
		else
			to_chat(user, SPAN_NOTICE("The welder can now be attached and modified."))
	return TRUE

/obj/item/weldingtool/proc/attempt_modify(var/obj/item/used_item, var/mob/user)
	if(!status && istype(used_item, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/R = used_item
		R.use(1)
		user.drop_from_inventory(src)
		user.put_in_hands(new /obj/item/flamethrower(get_turf(src), src))
		qdel(src)
		return TRUE

/obj/item/weldingtool/attackby(obj/item/used_item, mob/user)
	if(welding)
		to_chat(user, SPAN_WARNING("Stop welding first!"))
		return TRUE

	if (istype(used_item, /obj/item/chems/welder_tank))
		return insert_tank(used_item, user)

	if(IS_SCREWDRIVER(used_item))
		return toggle_unscrewed(user)

	if(attempt_modify(used_item, user))
		return TRUE

	return ..()

/obj/item/weldingtool/attack_hand(mob/user)
	if (tank && user.is_holding_offhand(src) && user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return remove_tank(user)
	return ..()

/obj/item/weldingtool/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && REAGENT_TOTAL_VOLUME(fluids) && welding && !waterproof)
		var/turf/location = get_turf(src)
		if(location)
			location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, 50, 1)
		turn_off()

/obj/item/weldingtool/Process()
	if(!(welding && idling()))
		return PROCESS_KILL

/obj/item/weldingtool/afterattack(var/obj/O, var/mob/user, proximity, click_parameters)
	if(!proximity)
		return

	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && !welding)
		if(!tank)
			to_chat(user, SPAN_WARNING("\The [src] has no tank attached!"))
			return
		return tank.afterattack(O, user, proximity, click_parameters)

	if(welding)
		weld(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.ignite_fire()
		else if(isatom(O))
			O.handle_external_heating(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, src, user)
		if (isturf(location))
			location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, 50, 1)
		spark_at(get_turf(O), 3, FALSE, O)
		user.setClickCooldown(attack_cooldown + w_class) //Prevent spam
		return TRUE
	return ..()

/obj/item/weldingtool/attack_self(mob/user)
	toggle(user)
	return TRUE

//Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return tank ? REAGENT_VOLUME(tank.reagents, /decl/material/liquid/fuel) : 0

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob.
/obj/item/weldingtool/proc/weld(var/fuel_usage = 1, var/mob/user = null)
	if(!welding)
		return FALSE
	if(get_fuel() < fuel_usage)
		if(user)
			to_chat(user, SPAN_NOTICE("You need more [welding_resource] to complete this task."))
		return FALSE

	use_fuel(fuel_usage)
	if(user)
		user.welding_eyecheck()

	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, 5)
	set_light(5, 0.7, COLOR_LIGHT_CYAN)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 5)
	return TRUE

/**Handle the flame burning fuel while the welder is on */
/obj/item/weldingtool/proc/idling(var/fuel_usage = 0.5)
	if(!welding)
		return
	if((!waterproof && submerged()) || (get_fuel() < fuel_usage))
		turn_off()
		return

	//consider ourselves in a mob if we are in the mob's contents and not in their hands
	if(isliving(loc))
		var/mob/living/L = loc
		if(!(src in L.get_held_items()))
			fuel_usage = max(fuel_usage, 2)
			L.ignite_fire()
	else if(isturf(loc))
		var/turf/location = get_turf(src)
		location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_IDLE, 5) //a bit colder when idling
	else if(isatom(loc))
		var/atom/A = loc
		A.handle_external_heating(WELDING_TOOL_HOTSPOT_TEMP_IDLE)

	if(use_fuel(fuel_usage))
		return TRUE
	else
		turn_off()

/obj/item/weldingtool/proc/use_fuel(var/amount)
	. = TRUE
	if(get_fuel() < amount)
		. = FALSE //Try to burn as much as possible anyways
	if(tank)
		tank.remove_from_reagents(/decl/material/liquid/fuel, amount)

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return src.welding

/obj/item/weldingtool/on_update_icon()
	. = ..()
	z_flags &= ~ZMM_MANGLE_PLANES
	if(tank)
		add_overlay("[icon_state]-[tank.icon_state]")
	if(welding && check_state_in_icon("[icon_state]-lit", icon))
		if(plane == HUD_PLANE)
			add_overlay(image(icon, "[icon_state]-lit"))
		else
			add_overlay(emissive_overlay(icon, "[icon_state]-lit"))
			z_flags |= ZMM_MANGLE_PLANES
		set_light(2.5, 0.6, lit_colour)
	else
		set_light(0)
	update_held_icon()

/**Handles updating damage depening on whether the welder is on or off */
/obj/item/weldingtool/proc/update_physical_damage()
	var/new_force
	if(isOn())
		new_force   = tank?.lit_force
		atom_damage_type = BURN
	else
		new_force   = tank?.unlit_force
		atom_damage_type = BRUTE
	if(isnull(new_force))
		set_base_attack_force(get_initial_base_attack_force())
	else
		set_base_attack_force(new_force)

/obj/item/weldingtool/proc/turn_on(var/mob/user)
	if (!status)
		return
	if(!waterproof && submerged())
		if(user)
			to_chat(user, SPAN_WARNING("You cannot light \the [src] underwater."))
		return
	if(get_fuel() <= 0)
		if(user)
			to_chat(user, SPAN_NOTICE("You need [welding_resource] to light \the [src]."))
		return

	if(user)
		user.visible_message(SPAN_NOTICE("\The [user] turns \the [src] on."), SPAN_NOTICE("You turn on \the [src]."))
	else
		visible_message(SPAN_WARNING("\The [src] turns on."))

	update_physical_damage()
	playsound(src, activate_sound, 50, TRUE)
	welding = TRUE
	obj_flags |= OBJ_FLAG_NO_STORAGE
	update_icon()
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/item/weldingtool/proc/turn_off(var/mob/user)
	STOP_PROCESSING(SSobj, src)

	if(user)
		user.visible_message(SPAN_NOTICE("\The [user] turns \the [src] off."), SPAN_NOTICE("You switch \the [src] off."))
	else
		visible_message(SPAN_WARNING("\The [src] turns off."))

	update_physical_damage()
	playsound(src, deactivate_sound, 50, TRUE)
	welding = FALSE
	obj_flags &= ~OBJ_FLAG_NO_STORAGE
	update_icon()
	return TRUE

/obj/item/weldingtool/proc/toggle(var/mob/user)
	if(welding)
		return turn_off(user)
	else
		return turn_on(user)

/obj/item/weldingtool/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	var/obj/item/organ/external/affecting = istype(target) && GET_EXTERNAL_ORGAN(target, user?.get_target_zone())
	if(affecting && user.check_intent(I_FLAG_HELP))
		if(!affecting.is_robotic())
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is not robotic. \The [src] cannot repair it."))
		else if(BP_IS_BRITTLE(affecting))
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is hard and brittle. \The [src] cannot repair it."))
		else if(!welding)
			to_chat(user, SPAN_WARNING("You'll need to turn \the [src] on to patch the damage on \the [target]'s [affecting.name]!"))
		else if(affecting.robo_repair(15, BRUTE, "some dents", src, user))
			weld(1, user)
		return TRUE
	return ..()

/obj/item/weldingtool/get_autopsy_descriptors()
	if(isOn())
		return list("jet of flame")
	return ..()

//////////////////////////////////////////////////////////////////
// Welding Tool Variants
//////////////////////////////////////////////////////////////////
/obj/item/weldingtool/mini
	tank = /obj/item/chems/welder_tank/mini

/obj/item/weldingtool/largetank
	tank = /obj/item/chems/welder_tank/large

/obj/item/weldingtool/hugetank
	tank = /obj/item/chems/welder_tank/huge

/obj/item/weldingtool/experimental
	tank     = /obj/item/chems/welder_tank/experimental
	material = /decl/material/solid/metal/steel
	matter   = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

#undef WELDING_TOOL_HOTSPOT_TEMP_ACTIVE
#undef WELDING_TOOL_HOTSPOT_TEMP_IDLE