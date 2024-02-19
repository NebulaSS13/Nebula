/mob/living/slime/get_handled_damage_types()
	var/static/list/mob_damage_types = list(
		BRUTE = /decl/damage_handler/brute,
		BURN  = /decl/damage_handler/burn/slime,
		TOX   = /decl/damage_handler/organ
	)
	return mob_damage_types

// TODO work out wtf is meant to happen with slime damage
/decl/damage_handler/burn/slime