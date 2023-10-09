/decl/damage_handler/electrocute
	name                = "electrocution"
	can_ignite_reagents = TRUE
	damage_verb         = "sparks"
	category_type       = /decl/damage_handler/electrocute

/decl/damage_handler/electrocute/get_armor_key(var/damage_flags)
	return ARMOR_ENERGY

/decl/damage_handler/electrocute/apply_damage_to_mob(var/mob/living/target, var/damage, var/def_zone, var/damage_flags = 0, var/used_weapon, var/silent = FALSE, var/skip_update_health = FALSE)
	target.electrocute_act(damage) // todo
	return TRUE

/decl/damage_handler/electrocute/set_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	return FALSE

/decl/damage_handler/electrocute/heal_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	return FALSE

/decl/damage_handler/electrocute/get_damage_for_mob(var/mob/living/target)
	return 0