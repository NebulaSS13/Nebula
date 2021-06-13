/decl/pronouns
	var/name = PLURAL
	var/formal_term = "other"
	var/informal_term = "hoopy frood"

	var/He   = "They"
	var/he   = "they"
	var/His  = "Their"
	var/his  = "their"
	var/him  = "them"
	var/has  = "have"
	var/is   = "are"
	var/does = "do"
	var/self = "themselves"
	var/s    = ""
	var/es   = ""

// I regret having to refactor this, but someone put it in unarmed attacks and here we are.
/decl/pronouns/proc/get_message_for_being_kicked_in_the_dick()
	return "Oh god, that hurt!"

/proc/get_pronouns_by_gender(var/gender)
	switch(gender)
		if(PLURAL)
			. = /decl/pronouns
		if(MALE)
			. = /decl/pronouns/male
		if(FEMALE)
			. = /decl/pronouns/female
		if(NEUTER)
			. = /decl/pronouns/neuter
		else
			gender = lowertext(gender)
			var/list/all_genders = decls_repository.get_decls_of_type(/decl/pronouns)
			for(var/g in all_genders)
				var/decl/pronouns/pronouns = all_genders[g]
				if(lowertext(pronouns.name) == gender)
					. = g
					break 
	. = GET_DECL(.) || GET_DECL(/decl/pronouns)

// Atom helpers.
/atom/proc/get_pronouns(var/ignore_coverings)
	. = get_pronouns_by_gender(gender)

/atom/proc/set_gender(var/new_gender, var/update_body = FALSE)
	if(gender != new_gender)
		gender = new_gender
		if(update_body)
			update_icon()
		return TRUE
	return FALSE

// Living mob helpers.
/mob/living
	var/decl/pronouns/pronouns

// TODO: separate body and gender.
/mob/living/set_gender(var/new_gender, var/update_body = FALSE)
	. = ..()
	if(.)
		pronouns = null

/mob/living/get_pronouns(var/ignore_coverings)
	if(!pronouns)
		pronouns = get_pronouns_by_gender(gender)
	return pronouns || GET_DECL(/decl/pronouns)

// Human concealment helper.
/mob/living/carbon/human/get_pronouns(var/ignore_coverings)
	if(!ignore_coverings && (wear_suit && (wear_suit.flags_inv & HIDEJUMPSUIT)) && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return GET_DECL(/decl/pronouns)
	return ..()
