/decl/pronouns
	var/name = PLURAL
	var/bureaucratic_term  = "other"
	var/informal_term = "hoopy frood"
	var/pronoun_string

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

/decl/pronouns/Initialize()
	pronoun_string = "[He]/[him]/[his]"
	. = ..()

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

var/global/list/byond_genders = list(MALE, FEMALE, NEUTER, PLURAL)
/atom/proc/set_gender(var/new_gender = NEUTER, var/update_body = FALSE)
	if(gender != new_gender)
		if(new_gender in global.byond_genders)
			gender = new_gender
		else
			gender = NEUTER
		if(update_body)
			update_icon()
		return TRUE
	return FALSE

// Living mob helpers.
/mob/living
	var/pronoun_gender
	var/decl/pronouns/pronouns

/mob/living/get_gender()
	if(!pronoun_gender)
		pronoun_gender = gender
	return pronoun_gender

/mob/living/set_gender(var/new_gender, var/update_body = FALSE)
	. = ..()
	if(.)
		pronoun_gender = new_gender
		pronouns = null

/mob/living/get_pronouns(var/ignore_coverings)
	if(!pronouns)
		pronouns = get_pronouns_by_gender(get_gender())
	return pronouns || GET_DECL(/decl/pronouns)

// Human concealment helper.
/mob/living/carbon/human/get_pronouns(var/ignore_coverings)
	if(!ignore_coverings)
		var/obj/item/suit = get_equipped_item(slot_wear_suit_str)
		var/obj/item/head = get_equipped_item(slot_head_str)
		if(suit && (suit.flags_inv & HIDEJUMPSUIT) && ((head && head.flags_inv & HIDEMASK) || get_equipped_item(slot_wear_mask_str)))
			return GET_DECL(/decl/pronouns)
	return ..()
