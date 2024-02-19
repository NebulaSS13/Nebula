/decl/damage_handler/radiation
	name = "radiation"
	category_type = /decl/damage_handler/radiation

/decl/damage_handler/radiation/apply_damage_to_mob(var/mob/living/target, var/damage, var/def_zone, var/damage_flags = 0, var/used_weapon, var/silent = FALSE)
	. = ..()
	if(. && iscarbon(target) && !target.isSynthetic())
		var/mob/living/carbon/target_carbon = target
		if(!target_carbon.ignore_rads)
			target.take_damage(0.25 * damage * target.get_damage_modifier(category_type), /decl/damage_handler/burn)

/decl/damage_handler/radiation/get_armor_key(var/damage_flags)
	return ARMOR_RAD
