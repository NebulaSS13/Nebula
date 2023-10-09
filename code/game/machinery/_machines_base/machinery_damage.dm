/obj/machinery/take_damage(damage, damage_type = BRUTE, def_zone, damage_flags = 0, used_weapon, armor_pen, silent = FALSE, override_droplimb, skip_update_health = FALSE)
	//Let's not bother initializing all the components for nothing
	if(damage <= 0)
		return
	var/decl/damage_handler/damage_type_data = GET_DECL(damtype)
	if(!damage_type_data.applies_to_machinery)
		return
	if(!silent)
		if(damage_type_data?.machinery_hit_sound)
			playsound(src, damage_type_data.machinery_hit_sound, 10, 1)

	// Shielding components (armor/fuses) take first hit
	var/list/shielding = get_all_components_of_type(/obj/item/stock_parts/shielding)
	for(var/obj/item/stock_parts/shielding/soak in shielding)
		if(soak.is_functional() && (damtype in soak.protection_types))
			damage -= soak.take_damage(damage, damtype)
	if(damage <= 0)
		return

	// If some damage got past, next it's generic (non-circuitboard) components
	var/obj/item/stock_parts/victim = get_damageable_component(damtype)
	while(damage > 0 && victim)
		damage -= victim.take_damage(damage, damtype)
		victim = get_damageable_component(damtype)
	if(damage <= 0)
		return

	// And lastly hit the circuitboard
	victim = get_component_of_type(/obj/item/stock_parts/circuitboard)
	if(victim?.can_take_damage() && victim.is_functional())
		damage -= victim.take_damage(damage, damtype)

	if(damage && (damtype == BRUTE || damtype == BURN))
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
			take_damage(100/severity, BRUTE, silent = TRUE)

/obj/machinery/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	take_damage(P.damage, P.damage_type, damage_flags = P.damage_flags)

/obj/machinery/bash(obj/item/W, mob/user)
	if(!istype(W) || W.force <= 5 || (W.item_flags & ITEM_FLAG_NO_BLUDGEON))
		return FALSE
	. = ..()
	if(.)
		user.setClickCooldown(W.attack_cooldown + W.w_class)
		take_damage(W.force, W.damtype)