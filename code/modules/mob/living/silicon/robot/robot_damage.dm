/mob/living/silicon/robot/getBruteLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.brute_damage
	return amount

/mob/living/silicon/robot/getFireLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.electronics_damage
	return amount

/mob/living/silicon/robot/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE) // take/heal overall call update_health regardless of arg
	if(amount > 0)
		take_damage(amount)
	else
		heal_damage(-amount, heal_synthetic = TRUE)

/mob/living/silicon/robot/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	if(amount > 0)
		take_damage(amount, BURN)
	else
		heal_damage(-amount, BURN, heal_synthetic = TRUE)

/mob/living/silicon/robot/proc/get_damaged_components(var/brute, var/burn, var/destroyed = 0)
	var/list/datum/robot_component/parts = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1 || (C.installed == -1 && destroyed))
			if((brute && C.brute_damage) || (burn && C.electronics_damage) || (!C.toggled) || (!C.powered && C.toggled))
				parts += C
	return parts

/mob/living/silicon/robot/proc/get_damageable_components()
	var/list/rval = new
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1) rval += C
	return rval

/mob/living/silicon/robot/proc/get_armour()

	if(!components.len) return 0
	var/datum/robot_component/C = components["armour"]
	if(C && C.installed == 1)
		return C
	return 0

/mob/living/silicon/robot/heal_damage(amount, damage_type = BRUTE, do_update_health, heal_synthetic)
	if(!heal_synthetic || !amount)
		return
	// Robots ignore all other damage types currently.
	if(damage_type != BURN && damage_type != BRUTE)
		return
	var/list/datum/robot_component/parts = damage_type == BRUTE ? get_damaged_components(amount, 0) : get_damaged_components(0, amount)
	if(!length(parts))
		return
	var/datum/robot_component/picked = pick(parts)
	if(damage_type == BRUTE)
		picked.heal_component_damage(amount, 0)
	else
		picked.heal_component_damage(0, amount)

/mob/living/silicon/robot/take_damage(damage, damage_type = BRUTE, damage_flags, used_weapon, armor_pen = 0, target_zone, silent = FALSE, override_droplimb, do_update_health = TRUE)

	if(status_flags & GODMODE)
		return

	// Robots ignore all other damage types currently.
	if(damage_type != BURN && damage_type != BRUTE)
		return

	var/list/components = get_damageable_components()
	if(!length(components))
		return

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_damage = damage*shield.shield_level
		var/cost = absorb_damage*100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, SPAN_DANGER("Your shield has overloaded!"))
		else
			damage -= absorb_damage
			to_chat(src, SPAN_NOTICE("Your shield absorbs some of the impact!"))

	if(armor_pen < 100)
		var/datum/robot_component/armour/A = get_armour()
		if(A)
			if(damage_type == BRUTE)
				A.take_component_damage(damage, 0)
			else
				A.take_component_damage(0, damage)
			return

	var/datum/robot_component/C = pick(components)
	if(damage_type == BRUTE)
		C.take_component_damage(damage, 0)
	else
		C.take_component_damage(0, damage)

/mob/living/silicon/robot/emp_act(severity)
	uneq_all()
	..() //Damage is handled at /silicon/ level.
