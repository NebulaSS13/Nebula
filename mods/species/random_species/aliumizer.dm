/obj/structure/aliumizer
	name = "alien monolith"
	desc = "Your true form is calling. Use this to become an alien humanoid."
	icon = 'icons/obj/xenoarchaeology.dmi' // todo: duplicate icon in modpack to avoid skew from upstream changes?
	icon_state = "ano51"
	anchored = TRUE

/obj/structure/aliumizer/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You've got no business touching this."))
		return TRUE
	var/decl/species/species = user.get_species()
	if(!species)
		return TRUE
	if(species.uid == /decl/species/alium::uid)
		to_chat(user, SPAN_WARNING("You're already an alien."))
		return TRUE
	if(alert("Are you sure you want to be an alien?", "Mom Look I'm An Alien!", "Yes", "No") == "No")
		to_chat(user, SPAN_NOTICE("<b>You are now an alien!</b>"))
		return TRUE
	if(species.uid == /decl/species/alium::uid) //no spamming it to get free implants
		return TRUE
	to_chat(user, "You're now an alien humanoid of some undiscovered species. Make up what lore you want, no one knows a thing about your species! You can check info about your traits with Check Species Info verb in IC tab.")
	to_chat(user, "You can't speak any other languages by default. You can use translator implant that spawns on top of this monolith - it will give you knowledge of any language if you hear it enough times.")
	var/mob/living/human/H = user
	new /obj/item/implanter/translator(get_turf(src))
	H.change_species(/decl/species/alium::uid)
	var/decl/background_detail/background = H.get_background_datum_by_flag(BACKGROUND_FLAG_NAMING)
	H.fully_replace_character_name(background.get_random_cultural_name(H, H.gender, /decl/species/alium::uid))
	H.rename_self("Humanoid Alien", 1)
	return TRUE

OPTIONAL_SPAWNER(aliumizer, /obj/structure/aliumizer)