// Exosuits only care about brute and burn.
/mob/living/exosuit/get_handled_damage_types()
	var/static/list/mob_damage_types = list(
		BRUTE = /decl/damage_handler/brute/exosuit,
		BURN  = /decl/damage_handler/burn/exosuit
	)
	return mob_damage_types

/decl/damage_handler/brute/exosuit
	expected_type = /mob/living/exosuit

/decl/damage_handler/brute/exosuit/apply_damage_to_mob(var/mob/living/target, var/damage, var/def_zone, var/damage_flags = 0, var/used_weapon, var/silent = FALSE, var/skip_update_health = FALSE)
	var/mob/living/exosuit/target_exo = target
	var/obj/item/mech_component/MC = target_exo.resolve_def_zone_to_component(def_zone)
	if(MC)
		MC.take_damage(damage, category_type)
		MC.update_component_health()
		return TRUE
	return FALSE

/decl/damage_handler/brute/exosuit/get_damage_for_mob(var/mob/living/target)
	. = 0
	var/mob/living/exosuit/target_exo = target
	for(var/obj/item/mech_component/MC in list(target_exo.arms, target_exo.legs, target_exo.body, target_exo.head))
		. += MC.brute_damage

/decl/damage_handler/brute/exosuit/set_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	return FALSE // No idea how to handle this sanely for exosuits.

/decl/damage_handler/brute/exosuit/heal_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	. = FALSE
	var/mob/living/exosuit/target_exo = target
	for(var/obj/item/mech_component/MC in list(target_exo.arms, target_exo.legs, target_exo.body, target_exo.head))
		if(MC.burn_damage)
			var/healing = min(damage, MC.brute_damage)
			MC.brute_damage -= healing
			damage -= healing
			. = TRUE
			if(damage <= 0)
				break

/decl/damage_handler/burn/exosuit
	expected_type = /mob/living/exosuit

/decl/damage_handler/burn/exosuit/apply_damage_to_mob(var/mob/living/target, var/damage, var/def_zone, var/damage_flags = 0, var/used_weapon, var/silent = FALSE, var/skip_update_health = FALSE)
	var/mob/living/exosuit/target_exo = target
	var/obj/item/mech_component/MC = target_exo.resolve_def_zone_to_component(def_zone)
	if(MC)
		MC.take_damage(damage, category_type)
		MC.update_component_health()
		return TRUE
	return FALSE

/decl/damage_handler/burn/exosuit/get_damage_for_mob(var/mob/living/target)
	. = 0
	var/mob/living/exosuit/target_exo = target
	for(var/obj/item/mech_component/MC in list(target_exo.arms, target_exo.legs, target_exo.body, target_exo.head))
		. += MC.burn_damage

/decl/damage_handler/burn/exosuit/set_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	return FALSE // No idea how to handle this sanely for exosuits.

/decl/damage_handler/burn/exosuit/heal_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	. = FALSE
	var/mob/living/exosuit/target_exo = target
	for(var/obj/item/mech_component/MC in list(target_exo.arms, target_exo.legs, target_exo.body, target_exo.head))
		if(MC.burn_damage)
			var/healing = min(damage, MC.burn_damage)
			MC.burn_damage -= healing
			damage -= healing
			. = TRUE
			if(damage <= 0)
				break

