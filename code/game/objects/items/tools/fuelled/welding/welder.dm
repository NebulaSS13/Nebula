#define WELDING_TOOL_HOTSPOT_TEMP_ACTIVE 700
#define WELDING_TOOL_HOTSPOT_TEMP_IDLE   400

/obj/item/fuelled_tool/welding
	name            = "welding tool"
	desc            = "A portable welding gun with a port for attaching fuel tanks."
	icon            = 'icons/obj/items/tool/welders/welder.dmi'
	slot_flags      = SLOT_LOWER_BODY
	center_of_mass  = @'{"x":14,"y":15}'
	z_flags         = ZMM_MANGLE_PLANES
	var/lit_colour  = COLOR_PALE_ORANGE
	/// Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/status      = TRUE

/obj/item/fuelled_tool/welding/Initialize()
	set_extension(src, /datum/extension/tool, list(TOOL_WELDER = TOOL_QUALITY_DEFAULT))
	set_extension(src, /datum/extension/demolisher/welder)
	. = ..()

/obj/item/fuelled_tool/welding/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && running_state && check_state_in_icon("[overlay.icon_state]-lit", overlay.icon))
		overlay.add_overlay(emissive_overlay(overlay.icon, "[overlay.icon_state]-lit"))
	. = ..()

/obj/item/fuelled_tool/welding/get_heat()
	. = max(..(), tool_is_running() ? 3800 : 0)

/obj/item/fuelled_tool/welding/isflamesource()
	. = tool_is_running()

/obj/item/fuelled_tool/welding/proc/toggle_unscrewed(var/mob/user)
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

/obj/item/fuelled_tool/welding/proc/attempt_modify(var/obj/item/used_item, var/mob/user)
	if(!status && istype(used_item, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/R = used_item
		R.use(1)
		user.drop_from_inventory(src)
		user.put_in_hands(new /obj/item/flamethrower(get_turf(src), src))
		qdel(src)
		return TRUE
	return FALSE

/obj/item/fuelled_tool/welding/attackby(obj/item/used_item, mob/user)
	if(IS_SCREWDRIVER(used_item))
		return toggle_unscrewed(user)
	if(attempt_modify(used_item, user))
		return TRUE
	return ..()

/obj/item/fuelled_tool/welding/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && REAGENT_TOTAL_VOLUME(fluids) && running_state && !waterproof)
		var/turf/location = get_turf(src)
		if(location)
			location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, 50, 1)
		turn_off()

/obj/item/fuelled_tool/welding/handle_afterattack(var/atom/target, var/mob/user, proximity, click_parameters)
	if(proximity && running_state)
		weld(1)
		var/turf/location = get_turf(user)
		if(isliving(target))
			var/mob/living/L = target
			L.ignite_fire()
		else if(isatom(target))
			target.handle_external_heating(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, src, user)
		if (isturf(location))
			location.hotspot_expose(WELDING_TOOL_HOTSPOT_TEMP_ACTIVE, 50, 1)
		spark_at(get_turf(target), 3, FALSE, target)
		user.setClickCooldown(attack_cooldown + w_class) //Prevent spam
		return TRUE
	return ..()

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob.
/obj/item/fuelled_tool/welding/proc/weld(var/fuel_usage = 1, var/mob/user = null)
	if(!running_state)
		return FALSE
	if(get_fuel() < fuel_usage)
		if(user)
			to_chat(user, SPAN_NOTICE("You need more [fuel_name] to complete this task."))
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

/obj/item/fuelled_tool/welding/handle_idling(fuel_usage = 0.5)
	. = ..()
	if(!.)
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

/obj/item/fuelled_tool/welding/on_update_icon()
	. = ..()
	z_flags &= ~ZMM_MANGLE_PLANES
	if(running_state && check_state_in_icon("[icon_state]-lit", icon))
		if(plane == HUD_PLANE)
			add_overlay(image(icon, "[icon_state]-lit"))
		else
			add_overlay(emissive_overlay(icon, "[icon_state]-lit"))
			z_flags |= ZMM_MANGLE_PLANES
		set_light(2.5, 0.6, lit_colour)
	else
		set_light(0)
	update_held_icon()

/obj/item/fuelled_tool/welding/get_running_force()
	return tool_is_running() ? tank?.lit_force : tank?.unlit_force

/obj/item/fuelled_tool/welding/get_running_damage_type()
	return tool_is_running() ? BURN : BRUTE

/obj/item/fuelled_tool/welding/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	var/obj/item/organ/external/affecting = istype(target) && GET_EXTERNAL_ORGAN(target, user?.get_target_zone())
	if(affecting && user.check_intent(I_FLAG_HELP))
		if(!affecting.is_robotic())
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is not robotic. \The [src] cannot repair it."))
		else if(BP_IS_BRITTLE(affecting))
			to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is hard and brittle. \The [src] cannot repair it."))
		else if(!running_state)
			to_chat(user, SPAN_WARNING("You'll need to turn \the [src] on to patch the damage on \the [target]'s [affecting.name]!"))
		else if(affecting.robo_repair(15, BRUTE, "some dents", src, user))
			weld(1, user)
		return TRUE
	return ..()

/obj/item/fuelled_tool/welding/get_autopsy_descriptors()
	if(tool_is_running())
		return list("jet of flame")
	return ..()

/obj/item/fuelled_tool/welding/can_turn_on()
	return status && ..()

//////////////////////////////////////////////////////////////////
// Welding Tool Variants
//////////////////////////////////////////////////////////////////
/obj/item/fuelled_tool/welding/mini
	tank = /obj/item/chems/fuel_tank/mini

/obj/item/fuelled_tool/welding/largetank
	tank = /obj/item/chems/fuel_tank/large

/obj/item/fuelled_tool/welding/hugetank
	tank = /obj/item/chems/fuel_tank/huge

/obj/item/fuelled_tool/welding/experimental
	tank     = /obj/item/chems/fuel_tank/experimental
	material = /decl/material/solid/metal/steel
	matter   = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

#undef WELDING_TOOL_HOTSPOT_TEMP_ACTIVE
#undef WELDING_TOOL_HOTSPOT_TEMP_IDLE
