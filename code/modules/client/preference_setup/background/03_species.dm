/datum/category_item/player_setup_item/background/species
	sort_order = 3
	var/hide_species = TRUE

/datum/category_item/player_setup_item/background/species/save_character(datum/pref_record_writer/W)
	W.write("species",                pref.species)

/datum/category_item/player_setup_item/background/species/load_character(datum/pref_record_reader/R)
	pref.species =                R.read("species") 

/datum/category_item/player_setup_item/background/species/proc/has_flag(var/decl/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/background/species/content(var/mob/user)
	. = list()

	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/title = "<b>Species<a href='?src=\ref[src];show_species=1'><small>?</small></a>:</b> <a href='?src=\ref[src];set_species=1'>[mob_species.name]</a>"
	var/append_text = "<a href='?src=\ref[src];toggle_species_verbose=1'>[hide_species ? "Expand" : "Collapse"]</a>"
	. += "<hr>"
	. += mob_species.get_description(title, append_text, verbose = !hide_species, skip_detail = TRUE, skip_photo = TRUE)
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/background/species/OnTopic(var/href,var/list/href_list, var/mob/user)

	var/decl/species/mob_species = get_species_by_key(pref.species)
	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TOPIC_REFRESH

	else if(href_list["show_species"])
		var/choice = input("Which species would you like to look at?") as null|anything in get_playable_species()
		if(choice)
			var/decl/species/current_species = get_species_by_key(choice)
			show_browser(user, current_species.get_description(), "window=species;size=700x400")
			return TOPIC_HANDLED

	else if(href_list["set_species"])

		var/list/species_to_pick = list()
		for(var/species in get_playable_species())
			if(!check_rights(R_ADMIN, 0) && config.usealienwhitelist)
				var/decl/species/current_species = get_species_by_key(species)
				if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
					continue
				else if((current_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),current_species))
					continue
			species_to_pick += species

		var/choice = input("Select a species to play as.") as null|anything in species_to_pick
		if(!choice || !(choice in get_all_species()))
			return

		var/prev_species = pref.species
		pref.species = choice
		if(prev_species != pref.species)
			mob_species = get_species_by_key(pref.species)
			var/decl/pronouns/pronouns = get_pronouns_by_gender(pref.gender)
			if(!istype(pronouns) || !(pronouns in mob_species.available_pronouns))
				pronouns = mob_species.available_pronouns[1]
				pref.gender = pronouns.name

			ResetAllHair()

			//reset hair colour and skin colour
			pref.hair_colour = COLOR_BLACK
			pref.skin_tone = 0
			pref.body_markings.Cut() // Basically same as above.

			prune_occupation_prefs()
			pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)

			pref.cultural_info = mob_species.default_cultural_info.Copy()

			mob_species.handle_post_species_pref_set(pref)

			if(!has_flag(get_species_by_key(pref.species), HAS_UNDERWEAR))
				pref.all_underwear.Cut()

			return TOPIC_REFRESH_UPDATE_PREVIEW
	. = ..()