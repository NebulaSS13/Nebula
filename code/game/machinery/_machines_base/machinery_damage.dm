/obj/machinery/proc/take_damage(amount, damtype = BRUTE, silent = FALSE)
	//Let's not bother initializing all the components for nothing
	if(amount <= 0)
		return
	if(damtype != BRUTE && damtype != BURN && damtype != ELECTROCUTE)
		return
	if(!silent)
		var/hitsound = 'sound/weapons/smash.ogg'
		if(damtype == ELECTROCUTE)
			hitsound = "sparks"
		else if(damtype == BURN)
			hitsound = 'sound/items/Welder.ogg'
		playsound(src, hitsound, 10, 1)
		
	// Shielding components (armor/fuses) take first hit
	var/list/shielding = get_all_components_of_type(/obj/item/stock_parts/shielding)
	for(var/obj/item/stock_parts/shielding/soak in shielding)
		if(damtype in soak.protection_types)
			amount -= soak.take_damage(amount, damtype)
	if(amount <= 0)
		return

	// If some damage got past, next it's generic (non-circuitboard) components
	var/obj/item/stock_parts/victim = get_damageable_component(damtype)
	while(amount > 0 && victim)
		amount -= victim.take_damage(amount, damtype)
		victim = get_damageable_component(damtype)
	if(amount <= 0)
		return

	// And lastly hit the circuitboard
	victim = get_component_of_type(/obj/item/stock_parts/circuitboard)
	if(victim)
		victim.take_damage(amount, damtype)
	
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
			if(component.part_flags & PART_FLAG_NODAMAGE)
				continue
			if(component.is_functional())
				return component
	for(var/path in uncreated_component_parts)
		if(uncreated_component_parts[path])
			var/obj/item/stock_parts/component = path
			if(!(initial(component.part_flags) & PART_FLAG_NODAMAGE))
				return force_init_component(path)

/obj/machinery/proc/on_component_failure(var/obj/item/stock_parts/component)
	RefreshParts()
	update_icon()
	if(istype(component, /obj/item/stock_parts/power))
		power_change()

/obj/machinery/emp_act(severity)
	if(use_power && stat == 0)
		new /obj/effect/temp_visual/emp_burst(loc)
		use_power_oneoff(7500/severity)
		take_damage(100/severity, ELECTROCUTE)
	..()

/obj/machinery/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if((severity == 1 || (severity == 2 && prob(25))))
			physically_destroyed()
		else
			take_damage(100/severity, BRUTE, TRUE)

/obj/machinery/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	take_damage(P.damage, P.damage_type)

/obj/machinery/bash(obj/item/W, mob/user)
	if(W.force <= 5)
		return FALSE
	. = ..()
	if(.)
		user.setClickCooldown(W.attack_cooldown + W.w_class)
		take_damage(W.force, W.damtype)