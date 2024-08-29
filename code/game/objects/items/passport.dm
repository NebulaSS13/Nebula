/obj/item/passport
	name = "identification papers"
	icon = 'icons/obj/items/passport.dmi'
	icon_state = "passport"
	_base_attack_force = 1
	gender = PLURAL
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A set of identifying documents."
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/leather   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_REINFORCEMENT
	)
	var/info

/obj/item/passport/proc/set_info(mob/living/human/H)
	if(!istype(H))
		return

	var/decl/cultural_info/culture = H.get_cultural_value(TAG_HOMEWORLD)
	var/pob = culture ? culture.name : "Unset"

	var/fingerprint = H.get_full_print(ignore_blockers = TRUE) || "N/A"
	var/decl/pronouns/pronouns = H.get_pronouns(ignore_coverings = TRUE)
	info = "\icon[src] [src]:\nName: [H.real_name]\nSpecies: [H.get_species_name()]\nGender: [capitalize(pronouns.name)]\nAge: [H.get_age()]\nPlace of Birth: [pob]\nFingerprint: [fingerprint]"

/obj/item/passport/attack_self(mob/user)
	user.visible_message(
		SPAN_ITALIC("\The [user] checks over \the [src]."),
		SPAN_ITALIC("You check over \the [src]."),
		SPAN_ITALIC("You hear the faint rustle of pages."),
		5)
	to_chat(user, info || SPAN_WARNING("\The [src] is completely blank!"))
