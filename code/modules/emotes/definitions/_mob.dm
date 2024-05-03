/mob/proc/get_default_emotes()
	return

/mob/living/get_default_emotes()
	. = ..()
	var/decl/species/my_species = get_species()
	if(LAZYLEN(my_species?.default_emotes))
		LAZYINITLIST(.)
		. |= my_species.default_emotes
	var/decl/bodytype/my_bodytype = get_bodytype()
	if(LAZYLEN(my_bodytype?.default_emotes))
		LAZYINITLIST(.)
		. |= my_bodytype.default_emotes
