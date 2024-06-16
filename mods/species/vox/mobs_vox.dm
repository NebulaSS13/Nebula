/mob/living/simple_animal/hostile/slug/check_friendly_species(var/mob/living/human/H)
	return (istype(H) && H.get_bodytype_category() == BODYTYPE_VOX) || ..()
