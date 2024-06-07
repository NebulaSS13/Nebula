
/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(effective_force)
		try_embed_in_mob(I, hit_zone, effective_force, direction = get_dir(user, src))
		return TRUE
	return FALSE
