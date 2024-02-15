/mob/proc/get_default_emotes()
	return

/mob/living/get_default_emotes()
	. = ..()
	var/decl/species/my_species = get_species()
	if(LAZYLEN(my_species?.default_emotes))
		return . | my_species.default_emotes
