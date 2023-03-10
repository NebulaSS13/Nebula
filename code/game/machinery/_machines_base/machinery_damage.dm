/**
 * Returns the multiplier applied to BRUTE damage affecting internal components vs the machine frame itself. 
 * This is a trade-off because several things like doors needs to be bashable to bits, and having to destroy internal components first made things a bit ridiculous, 
 * and made machine unsalvageable..
*/
/obj/machinery/proc/physical_damage_to_components_multiplier()
	return 0.25

/**
 * Returns the base time an emp should cause the machine to go into EMPED status. If null, will never go into EMPED. 
 */
/obj/machinery/proc/get_base_emp_duration()
	return MACHINERY_EMP_DEFAULT_DURATION

/obj/machinery/take_damage(amount, damage_type = BRUTE, damage_flags = 0, inflicter = null, armor_pen = 0, target_zone = null, quiet = FALSE)
	//Let's not bother initializing all the components for nothing
	if(amount <= 0)
		return 0
	if(damage_type != BRUTE && damage_type != BURN && damage_type != ELECTROCUTE)
		return 0

	//#TODO: Damage sound effects should probably be handled earlier by whatever interaction caused the damage, cause nothing gates how often this proc can be called.
	if(!quiet)
		var/snd = hitsound
		if(damage_type == ELECTROCUTE)
			snd = "sparks"
		else if(damage_type == BURN)
			snd = 'sound/items/Welder.ogg'
		playsound(src, snd, 20, TRUE)

	//Keep track of the damage passed in the args
	var/initial_damage = amount

	// Shielding components (armor/fuses) take first hit
	var/list/shielding = get_all_components_of_type(/obj/item/stock_parts/shielding)
	for(var/obj/item/stock_parts/shielding/soak in shielding)
		if(damtype in soak.protection_types)
			amount -= soak.take_damage(amount, damtype, damage_flags, inflicter, armor_pen, target_zone, TRUE)
	if(amount <= 0)
		return initial_damage

	//Only let some of the damage through to the components from BRUTE, but let BURN and ELECTROCUTE damage go to town on them
	var/component_damage = (damage_type == BRUTE)? amount * physical_damage_to_components_multiplier() : amount
	var/init_component_damage = component_damage
	if(component_damage > 0)
		// If some damage got past, next it's generic (non-circuitboard) components
		var/obj/item/stock_parts/victim = get_damageable_component(damage_type)
		while(component_damage > 0 && victim)
			//When dealing brute damage, have a chance for a component not to take damage
			if(damage_type != BRUTE || (damage_type == BRUTE && prob(min(100, component_damage))))
				component_damage -= victim.take_damage(component_damage, damage_type, damage_flags, inflicter, 0, target_zone, quiet)
			victim = get_damageable_component(damage_type)

		// And lastly hit the circuitboard, with a chance to not damage it when dealing brute damage
		if(component_damage > 0 && (damage_type != BRUTE || (damage_type == BRUTE && prob(min(100, component_damage)))))
			victim = get_component_of_type(/obj/item/stock_parts/circuitboard)
			if(victim)
				component_damage -= victim.take_damage(component_damage, damage_type)

	//Remove only what the components absorbed
	amount -= init_component_damage - component_damage
	if(amount <= 0)
		return initial_damage

	//Electric damage doesn't damage the frame
	if(damage_type == ELECTROCUTE)
		return (initial_damage - amount)

	//Burn and brute may damage the frame
	return ..(amount, damage_type, damage_flags, inflicter, armor_pen, target_zone, quiet)

/obj/machinery/proc/get_damageable_component(var/damage_type)
	var/list/victims = shuffle(component_parts)
	if(LAZYLEN(victims))
		for(var/obj/item/stock_parts/component in victims)
			// Circuitboards are handled separately
			if(istype(component, /obj/item/stock_parts/circuitboard))
				continue
			if(damage_type && (damage_type in component.ignore_damage_types))
				continue
			// Don't damage what can't be repaired
			if(!component.can_take_damage())
				continue
			if(component.is_functional())
				return component
	for(var/path in uncreated_component_parts)
		if(uncreated_component_parts[path])
			var/obj/item/stock_parts/component = path
			//Must be checked this way, since we don't have an instance to call component.can_take_damage() on.
			if(initial(component.max_health) != OBJ_HEALTH_NO_DAMAGE)
				return force_init_component(path)

/obj/machinery/proc/on_component_failure(var/obj/item/stock_parts/component)
	RefreshParts()
	if(istype(component, /obj/item/stock_parts/power))
		power_change()
		spark_at(loc, rand(1, 4), FALSE, src) //Gives some much needed feedback
	update_icon()

//skip_emp_stat will completely skip over setting the EMPED flag
/obj/machinery/emp_act(severity, var/skip_emp_stat = FALSE)
	if(use_power && operable())
		new /obj/effect/temp_visual/emp_burst(loc)
		spark_at(loc, rand(1, 5), FALSE, src)
		use_power_oneoff(7500/severity) //#TODO: Maybe use the active power usage value instead of a random power literal
		take_damage(100/severity, ELECTROCUTE, 0, "power spike")

		var/emptime = get_base_emp_duration()
		//#TODO: Not entirely sure if this should be handled here. However it does make emps a whole lot more relevant/consistent, and less niche.
		if(!skip_emp_stat && (emptime > 0) && !(stat_immune & EMPED))
			stat |= EMPED
			addtimer(CALLBACK(.proc/emp_end, severity), (emptime / severity), TIMER_UNIQUE | TIMER_OVERRIDE)
	. = ..()

///Called by the base machinery code when the EMPED state expires.
/obj/machinery/proc/emp_end(var/severity)
	stat &= ~EMPED

/obj/machinery/bash(obj/item/W, mob/user)
	//Add a lower damage threshold for machines
	if(!istype(W) || W.force <= 5) //#FIXME: probably should use the armor thresholds system
		return FALSE
	. = ..()

// This is really pretty crap and should be overridden for specific machines.
/obj/machinery/fluid_act(var/datum/reagents/fluids)
	..()
	if(QDELETED(src))
		return
	if(!waterproof && operable() && (fluids.total_volume > FLUID_DEEP))
		var/short_damage = active_power_usage
		if(take_damage(short_damage, ELECTROCUTE, DAM_DISPERSED, "overvoltage", quiet = TRUE) > 0)
			if(QDELETED(src))
				explosion(get_turf(src), 0, 0, 1, 2, z_transfer = 0) //#FIXME: if we handle water damage in check_health eventually, move that over there
			else
				use_power_oneoff(active_power_usage) //The thing is shorting
				spark_at(get_turf(src), 2, FALSE)

/obj/machinery/attack_generic(var/mob/user, var/damage, var/attack_verb, var/environment_smash)
	if(environment_smash >= 1)
		damage = max(damage, 10)

	//#TODO: Probably should get the natural_weapon properties from the mob
	if(damage >= 10)
		visible_message(SPAN_DANGER("\The [user] [attack_verb] into \the [src]!"))
		take_damage(damage)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))
	attack_animation(user)

/obj/machinery/attackby(obj/item/I, mob/user)
	//Added an extra is_damaged check, because can_repair_with could be expensive.
	//Generic machine frame repair code
	if(can_repair_with(I) && can_repair(user) && handle_repair(user, I))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		add_fingerprint(user)
		return TRUE
	return ..()

/obj/machinery/physically_destroyed(skip_qdel, quiet)
	. = ..(TRUE, quiet)
	dismantle()