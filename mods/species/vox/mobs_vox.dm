/mob/living/critter/hostile/slug/check_friendly_species(var/mob/living/carbon/human/H)
	return (istype(H) && H.species.get_bodytype(H) == BODYTYPE_VOX) || ..()
