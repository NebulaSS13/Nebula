/obj/item/passport
	name = "identification papers"
	icon = 'icons/obj/items/passport.dmi'
	icon_state = "passport"
	force = 1
	gender = PLURAL
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A set of identifying documents."
	material = /decl/material/solid/cardboard
	matter = list(/decl/material/solid/leather = MATTER_AMOUNT_REINFORCEMENT)
	var/info

/obj/item/passport/proc/set_info(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/decl/cultural_info/culture = H.get_cultural_value(TAG_HOMEWORLD)
	var/pob = culture ? culture.name : "Unset"

	var/fingerprint = "N/A"
	if(H.dna)
		fingerprint = md5(H.dna.uni_identity)

	var/decl/pronouns/G = H.get_pronouns(ignore_coverings = TRUE)
	info = "\icon[src] [src]:\nName: [H.real_name]\nSpecies: [H.get_species_name()]\nGender: [capitalize(G.name)]\nAge: [H.get_age()]\nPlace of Birth: [pob]\nFingerprint: [fingerprint]"

/obj/item/passport/attack_self(mob/user)
	user.visible_message(
		SPAN_ITALIC("\The [user] checks over \the [src]."),
		SPAN_ITALIC("You check over \the [src]."),
		SPAN_ITALIC("You hear the faint rustle of pages."),
		5)
	to_chat(user, info || SPAN_WARNING("\The [src] is completely blank!"))
