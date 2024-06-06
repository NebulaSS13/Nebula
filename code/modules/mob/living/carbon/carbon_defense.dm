
/mob/living/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(!effective_force)
		return 0

	//Apply weapon damage
	var/damage_flags = I.damage_flags()
	var/datum/wound/created_wound = take_damage(effective_force, I.atom_damage_type, target_zone = hit_zone, damage_flags = damage_flags, used_weapon = I, armor_pen = I.armor_penetration)

	//Melee weapon embedded object code.
	if(istype(created_wound) && I && I.can_embed() && I.atom_damage_type == BRUTE && !I.anchored && !is_robot_module(I))
		var/weapon_sharp = (damage_flags & DAM_SHARP)
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		damage *= 1 - get_blocked_ratio(hit_zone, I.atom_damage_type, I.damage_flags(), I.armor_penetration, I.force)

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp? damage/I.w_class : damage/(I.w_class*3)
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if((weapon_sharp && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			embed_in_mob(I, hit_zone, damage, I.atom_damage_type, supplied_wound = created_wound)
			I.has_embedded()

	return 1
