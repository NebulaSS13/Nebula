#define WELDING_TOOL_HOTSPOT_TEMP_ACTIVE 700
#define WELDING_TOOL_HOTSPOT_TEMP_IDLE   400

/obj/item/weldingtool
	name                                = "welding tool"
	desc                                = "A portable welding gun with a port for attaching fuel tanks."
	icon                                = 'icons/obj/items/tool/welders/welder.dmi'
	icon_state                          = ICON_STATE_WORLD
	obj_flags                           = OBJ_FLAG_CONDUCTIBLE
	slot_flags                          = SLOT_LOWER_BODY
	center_of_mass                      = @"{'x':14,'y':15}"
	force                               = 5
	throwforce                          = 5
	throw_speed                         = 1
	throw_range                         = 5
	w_class                             = ITEM_SIZE_SMALL
	material                            = /decl/material/solid/metal/steel
	matter                              = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech                         = "{'engineering':1}"
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

/obj/item/weldingtool/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && welding && check_state_in_icon("[overlay.icon_state]-lit", overlay.icon))
		overlay.add_overlay(emissive_overlay(overlay.icon, "[overlay.icon_state]-lit"))
	. = ..()

/obj/item/weldingtool/get_heat()
	. = max(..(), isOn() ? 3800 : 0)

/obj/item/weldingtool/isflamesource()
	. = isOn()

/obj/item/weldingtool/examine(mob/user, distance)
	. = ..()
	if (tank)
		to_chat(user, (distance <= 1 ? "It has [round(get_fuel(), 0.1)] [welding_resource] remaining. " : "") + "[tank] is attached.")

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
	force   = tank.unlit_force
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
	force   = initial(force)
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

/obj/item/weldingtool/proc/attempt_modify(var/obj/item/W, var/mob/user)
	if(!status && istype(W, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/R = W
		R.use(1)
		user.drop_from_inventory(src)
		user.put_in_hands(new /obj/item/flamethrower(get_turf(src), src))
		qdel(src)
		return TRUE

/obj/item/weldingtool/attackby(obj/item/W, mob/user)
	if(welding)
		to_chat(user, SPAN_WARNING("Stop welding first!"))
		return

	if (istype(W, /obj/item/chems/welder_tank))
		return insert_tank(W, user)

	if(IS_SCREWDRIVER(W))
		return toggle_unscrewed(user)

	if(attempt_modify(W, user))
		return TRUE

	return ..()

/obj/item/weldingtool/attack_hand(mob/user)
	if (tank && user.is_holding_offhand(src) && user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return remove_tank(user)
	return ..()

/obj/item/weldingtool/fluid_act(var/datum/reagents/fluids)
	..()
	if(welding && !waterproof)
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
			L.IgniteMob()
		else if(istype(O))
			O.HandleObjectHeating(src, user, WELDING_TOOL_HOTSPOT_TEMP_ACTIVE)
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
		return
	if(get_fuel() < fuel_usage)
		if(user)
			to_chat(user, SPAN_NOTICE("You need more [welding_resource] to complete this task."))
		return

	use_fuel(fuel_usage)
	if(user)
		user.welding_eyecheck()

	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, 5)
	set_light(5, 0.7, COLOR_LIGHT_CYAN)
	addtimer(CALLBACK(src, /atom/proc/update_icon), 5)
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
			L.IgniteMob()

	else if(isobj(loc))
		var/obj/O = loc
		O.HandleObjectHeating(src, null, WELDING_TOOL_HOTSPOT_TEMP_IDLE)

	else if(isturf(loc))
		var/turf/location = get_turf(src)
		location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_IDLE, 5) //a bit colder when idling

	if(use_fuel(fuel_usage))
		return TRUE
	else
		turn_off()

/obj/item/weldingtool/proc/use_fuel(var/amount)
	. = TRUE
	if(get_fuel() < amount)
		. = FALSE //Try to burn as much as possible anyways
	if(tank)
		tank.reagents.remove_reagent(/decl/material/liquid/fuel, amount)

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return src.welding

/obj/item/weldingtool/get_storage_cost()
	if(isOn())
		return ITEM_SIZE_NO_CONTAINER
	return ..()

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
	if(isOn())
		force   = tank ? tank.lit_force : initial(force)
		damtype = BURN
	else
		damtype = BRUTE
		force   = tank? tank.unlit_force : initial(force)

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
	update_icon()
	return TRUE

/obj/item/weldingtool/proc/toggle(var/mob/user)
	if(welding)
		return turn_off(user)
	else
		return turn_on(user)

/obj/item/weldingtool/attack(mob/living/M, mob/living/user, target_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = GET_EXTERNAL_ORGAN(H, target_zone)

		if(!S || !S.is_robotic() || user.a_intent != I_HELP)
			return ..()

		if(BP_IS_BRITTLE(S))
			to_chat(user, SPAN_WARNING("\The [M]'s [S.name] is hard and brittle - \the [src]  cannot repair it."))
			return TRUE

		if(!welding)
			to_chat(user, SPAN_WARNING("You'll need to turn [src] on to patch the damage on [M]'s [S.name]!"))
			return TRUE

		if(S.robo_repair(15, BRUTE, "some dents", src, user))
			weld(1, user)
			return TRUE
	else
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

//////////////////////////////////////////////////////////////////
// Welding tool tanks
//////////////////////////////////////////////////////////////////
/obj/item/chems/welder_tank
	name              = "welding tank"
	base_name         = "welding tank"
	desc              = "An interchangeable fuel tank meant for a welding tool."
	icon              = 'icons/obj/items/tool/welders/welder_tanks.dmi'
	icon_state        = "tank_normal"
	w_class           = ITEM_SIZE_SMALL
	obj_flags         = OBJ_FLAG_HOLLOW
	force             = 5
	throwforce        = 5
	volume            = 20
	show_reagent_name = TRUE
	health            = 40
	max_health        = 40
	material          = /decl/material/solid/metal/steel
	var/can_refuel    = TRUE
	var/size_in_use   = ITEM_SIZE_NORMAL
	var/unlit_force   = 7
	var/lit_force     = 11

/obj/item/chems/welder_tank/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/fuel, reagents.maximum_volume)

/obj/item/chems/welder_tank/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if(reagents.total_volume <= 0)
		to_chat(user, "It is empty.")
	else
		to_chat(user, "It contains [reagents.total_volume] units of liquid.")
	to_chat(user, " It can hold up to [reagents.maximum_volume] units.")

/obj/item/chems/welder_tank/afterattack(obj/O, mob/user, proximity, click_parameters)
	if (!ATOM_IS_OPEN_CONTAINER(src) || !proximity)
		return
	if(standard_dispenser_refill(user, O))
		return TRUE
	if(standard_pour_into(user, O))
		return TRUE
	if(standard_feed_mob(user, O))
		return TRUE
	if(user.a_intent == I_HURT)
		if(standard_splash_mob(user, O))
			return TRUE
		if(reagents && reagents.total_volume)
			to_chat(user, SPAN_DANGER("You splash the contents of \the [src] onto \the [O]."))
			reagents.splash(O, reagents.total_volume)
			return TRUE
	return ..()

/obj/item/chems/welder_tank/standard_dispenser_refill(mob/user, obj/structure/reagent_dispensers/target)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] does not have a refuelling port."))
		return FALSE
	. = ..()
	if(.)
		playsound(src.loc, 'sound/effects/refill.ogg', 50, TRUE, -6)

/obj/item/chems/welder_tank/standard_pour_into(mob/user, atom/target)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] is sealed shut."))
		return FALSE
	. = ..()

/obj/item/chems/welder_tank/standard_splash_mob(mob/user, mob/target)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] is sealed shut."))
		return FALSE
	. = ..()

/obj/item/chems/welder_tank/standard_feed_mob(mob/user, mob/target)
	if(!can_refuel)
		to_chat(user, SPAN_DANGER("\The [src] is sealed shut."))
		return FALSE
	. = ..()

/obj/item/chems/welder_tank/get_alt_interactions(var/mob/user)
	. = ..()
	if(!can_refuel)
		LAZYREMOVE(., /decl/interaction_handler/set_transfer/chems)

/obj/item/chems/welder_tank/mini
	name        = "small welding tank"
	base_name   = "small welding tank"
	icon_state  = "tank_small"
	w_class     = ITEM_SIZE_TINY
	volume      = 5
	force       = 4
	throwforce  = 4
	size_in_use = ITEM_SIZE_SMALL
	unlit_force = 5
	lit_force   = 7

/obj/item/chems/welder_tank/large
	name        = "large welding tank"
	base_name   = "large welding tank"
	icon_state  = "tank_large"
	w_class     = ITEM_SIZE_SMALL
	volume      = 40
	force       = 6
	throwforce  = 6
	size_in_use = ITEM_SIZE_NORMAL

/obj/item/chems/welder_tank/huge
	name        = "huge welding tank"
	base_name   = "huge welding tank"
	icon_state  = "tank_huge"
	w_class     = ITEM_SIZE_NORMAL
	volume      = 80
	force       = 8
	throwforce  = 8
	size_in_use = ITEM_SIZE_LARGE
	unlit_force = 9
	lit_force   = 15

/obj/item/chems/welder_tank/experimental
	name              = "experimental welding tank"
	base_name         = "experimental welding tank"
	icon_state        = "tank_experimental"
	w_class           = ITEM_SIZE_NORMAL
	volume            = 40
	can_refuel        = FALSE
	force             = 8
	throwforce        = 8
	size_in_use       = ITEM_SIZE_LARGE
	unlit_force       = 9
	lit_force         = 15
	show_reagent_name = FALSE
	var/tmp/last_gen  = 0

/obj/item/chems/welder_tank/experimental/Initialize(ml, material_key)
	. = ..()
	atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
	START_PROCESSING(SSobj, src)

/obj/item/chems/welder_tank/experimental/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/chems/welder_tank/experimental/Process()
	if(REAGENT_VOLUME(reagents, /decl/material/liquid/fuel) < reagents.maximum_volume)
		var/gen_amount = ((world.time-last_gen)/25)
		reagents.add_reagent(/decl/material/liquid/fuel, gen_amount)
		last_gen = world.time

#undef WELDING_TOOL_HOTSPOT_TEMP_ACTIVE
#undef WELDING_TOOL_HOTSPOT_TEMP_IDLE