///Returns the multiplier applied to BRUTE damage affecting internal components vs the machine frame itself.
//This is a trade-off because several things like doors needs to be bashable to bits, and having to destroy internal components first made things a bit ridiculous, and made machine unsalvageable..
/obj/machinery/proc/physical_damage_to_components_multiplier()
	return 0.25

/obj/machinery/take_damage(damage, damage_type = BRUTE, damage_flags = 0, inflicter = null, armor_pen = 0, target_zone = null, quiet = FALSE)
	//Let's not bother initializing all the components for nothing
	if(damage <= 0)
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
	var/initial_damage = damage

	// Shielding components (armor/fuses) take first hit
	var/list/shielding = get_all_components_of_type(/obj/item/stock_parts/shielding)
	for(var/obj/item/stock_parts/shielding/soak in shielding)
		if(damtype in soak.protection_types)
			damage -= soak.take_damage(damage, damtype)
	if(damage <= 0)
		return initial_damage

	//Only let some of the damage through to the components from BRUTE, but let BURN and ELECTROCUTE damage go to town on them
	var/component_damage = (damage_type == BRUTE)? damage * physical_damage_to_components_multiplier() : damage
	var/init_component_damage = component_damage
	if(component_damage > 0)
		// If some damage got past, next it's generic (non-circuitboard) components
		var/obj/item/stock_parts/victim = get_damageable_component(damage_type)
		while(component_damage > 0 && victim)
			component_damage -= victim.take_damage(component_damage, damage_type)
			victim = get_damageable_component(damage_type)

		// And lastly hit the circuitboard
		if(component_damage > 0)
			victim = get_component_of_type(/obj/item/stock_parts/circuitboard)
			if(victim)
				component_damage -= victim.take_damage(component_damage, damage_type)

	//Remove only what the components absorbed
	damage -= init_component_damage - component_damage
	if(damage <= 0)
		return initial_damage

	//Electric damage doesn't damage the frame
	if(damage_type == ELECTROCUTE)
		return (initial_damage - damage)

	//Burn and brute may damage the frame
	return ..(initial_damage - damage, damage_type, damage_flags, inflicter, armor_pen, target_zone, quiet)

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
		spark_at(loc, 2, FALSE, src) //Gives some much needed feedback
	update_icon()

/obj/machinery/emp_act(severity)
	if(use_power && operable())
		new /obj/effect/temp_visual/emp_burst(loc)
		spark_at(loc, 4, FALSE, src)
		use_power_oneoff(7500/severity) //#TODO: Maybe use the active power usage value instead of a random power literal
		take_damage(100/severity, ELECTROCUTE, 0, "power spike")
	. = ..()

/obj/machinery/bash(obj/item/W, mob/user)
	//Add a lower damage threshold for machines
	if(!istype(W) || W.force <= 5)
		return FALSE
	. = ..()

// This is really pretty crap and should be overridden for specific machines.
/obj/machinery/fluid_act(var/datum/reagents/fluids)
	..()
	if(!waterproof && operable() && (fluids.total_volume > FLUID_DEEP))
		explosion_act(3)