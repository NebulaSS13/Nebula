/obj/machinery/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	//Let's not bother initializing all the components for nothing
	if(damage <= 0)
		return
	if(damage_type != BRUTE && damage_type != BURN && damage_type != ELECTROCUTE)
		return
	if(!silent)
		var/hitsound = 'sound/weapons/smash.ogg'
		if(damage_type == ELECTROCUTE)
			hitsound = "sparks"
		else if(damage_type == BURN)
			hitsound = 'sound/items/Welder.ogg'
		playsound(src, hitsound, 10, 1)

	// Shielding components (armor/fuses) take first hit
	var/list/shielding = get_all_components_of_type(/obj/item/stock_parts/shielding)
	for(var/obj/item/stock_parts/shielding/soak in shielding)
		if(soak.is_functional() && (damage_type in soak.protection_types))
			damage -= soak.take_damage(damage, damage_type)
	if(damage <= 0)
		return

	// If some damage got past, next it's generic (non-circuitboard) components
	var/obj/item/stock_parts/victim = get_damageable_component(damage_type)
	while(damage > 0 && victim)
		damage -= victim.take_damage(damage, damage_type)
		victim = get_damageable_component(damage_type)
	if(damage <= 0)
		return

	// And lastly hit the circuitboard
	victim = get_component_of_type(/obj/item/stock_parts/circuitboard)
	if(victim?.can_take_damage() && victim.is_functional())
		damage -= victim.take_damage(damage, damage_type)

	if(damage && (damage_type == BRUTE || damage_type == BURN))
		dismantle()

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
			if(initial(component.max_health) != ITEM_HEALTH_NO_DAMAGE)
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
			take_damage(100/severity, silent = TRUE)

/obj/machinery/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	take_damage(P.damage, P.atom_damage_type)

/obj/machinery/bash(obj/item/W, mob/user)
	if(!istype(W))
		return FALSE
	var/force = W.get_attack_force(user)
	if(force <= 5)
		return FALSE
	. = ..()
	if(.)
		user.setClickCooldown(W.attack_cooldown + W.w_class)
		take_damage(force, W.atom_damage_type)