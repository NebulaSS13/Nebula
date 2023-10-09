/mob/living/silicon/robot/get_handled_damage_types()
	var/static/list/mob_damage_types = list(
		BRUTE       = /decl/damage_handler/brute/robot,
		BURN        = /decl/damage_handler/burn/robot
	)
	return mob_damage_types

/decl/damage_handler/brute/robot/apply_damage_to_mob(var/mob/living/target, var/damage, var/def_zone, var/damage_flags = 0, var/used_weapon, var/silent = FALSE, var/skip_update_health = FALSE)
	//var/mob/living/silicon/robot/target_robo = target

/decl/damage_handler/brute/robot/heal_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	//var/mob/living/silicon/robot/target_robo = target

/decl/damage_handler/brute/robot/get_damage_for_mob(var/mob/living/target)
	. = 0
	var/mob/living/silicon/robot/target_robo = target
	for(var/V in target_robo.components)
		var/datum/robot_component/C = target_robo.components[V]
		if(C.installed != 0)
			. += C.brute_damage

/decl/damage_handler/brute/robot/set_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	return FALSE // No idea how to handle this for components.

/decl/damage_handler/burn/robot/apply_damage_to_mob(var/mob/living/target, var/damage, var/def_zone, var/damage_flags = 0, var/used_weapon, var/silent = FALSE, var/skip_update_health = FALSE)
	//var/mob/living/silicon/robot/target_robo = target

/decl/damage_handler/burn/robot/heal_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	//var/mob/living/silicon/robot/target_robo = target

/decl/damage_handler/burn/robot/get_damage_for_mob(var/mob/living/target)
	. = 0
	var/mob/living/silicon/robot/target_robo = target
	for(var/V in target_robo.components)
		var/datum/robot_component/C = target_robo.components[V]
		if(C.installed != 0)
			. += C.electronics_damage

/*
/mob/living/silicon/robot/_heal_overall_damage(var/brute, var/burn)
	if(is_drone())
		return ..()
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)
	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_damage)
		burn -= (burn_was-picked.electronics_damage)

		parts -= picked

/mob/living/silicon/robot/take_damage(var/damage, var/damage_type = BRUTE, var/def_zone = null, var/damage_flags = 0, var/used_weapon = null, var/armor_pen, var/silent = FALSE)
	//Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active, /obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		if(damage_type in shield.absorbs_damage_types)
			//Shields absorb a certain percentage of damage based on their power setting.
			var/absorb_damage = damage * shield.shield_level
			var/cost = absorb_damage*100
			cell.charge -= cost
			if(cell.charge <= 0)
				cell.charge = 0
				to_chat(src, SPAN_DAMAGE("Your shield has overloaded!"))
			else
				damage -= absorb_damage
				to_chat(src, SPAN_WARNING("Your shield absorbs some of the impact!"))
	return ..()

/mob/living/silicon/robot/_take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	if(is_drone())
		return ..()
	if(status_flags & GODMODE)	return	//godmode
	var/list/datum/robot_component/parts = get_damageable_components()
	var/datum/robot_component/armour/A = get_armour()
	if(A)
		A.take_damage(brute,burn,sharp)
		return

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)
		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage
		picked.take_damage(brute,burn)
		brute	-= (picked.brute_damage - brute_was)
		burn	-= (picked.electronics_damage - burn_was)
		parts -= picked
*/