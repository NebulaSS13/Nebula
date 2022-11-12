/datum/preferences
	var/list/laws = list()
	var/is_shackled = FALSE

/datum/preferences/proc/get_lawset()
	if(!laws || !laws.len)
		return
	var/datum/ai_laws/custom_lawset = new
	for(var/law in laws)
		custom_lawset.add_inherent_law(law)
	return custom_lawset

/datum/category_group/player_setup_category/law_pref
	name = "Laws"
	sort_order = 8
	category_item_type = /datum/category_item/player_setup_item/law_pref

/datum/category_item/player_setup_item/law_pref
	name = "Laws"
	sort_order = 1

/datum/category_item/player_setup_item/law_pref/load_character(datum/pref_record_reader/R)
	pref.laws = R.read("laws")
	pref.is_shackled = R.read("is_shackled")

/datum/category_item/player_setup_item/law_pref/save_character(datum/pref_record_writer/W)
	W.write("laws", pref.laws)
	W.write("is_shackled", pref.is_shackled)

/datum/category_item/player_setup_item/law_pref/sanitize_character()
	if(!istype(pref.laws))	pref.laws = list()

	var/decl/species/species = get_species_by_key(pref.species)
	if(!species?.can_be_shackled)
		pref.is_shackled = FALSE
	else
		pref.is_shackled = sanitize_bool(pref.is_shackled, initial(pref.is_shackled))

/datum/category_item/player_setup_item/law_pref/content()
	. = list()
	var/decl/species/species = get_species_by_key(pref.species)

	if(!species?.can_be_shackled)
		. += "<b>Your current species cannot be shackled.</b><br>"
	else
		. += "<b>Shackle: </b>"
		if(!pref.is_shackled)
			. += "<span class='linkOn'>Off</span>"
			. += "<a href='?src=\ref[src];toggle_shackle=[pref.is_shackled]'>On</a>"
			. += "<br>Only shackled synthetics have laws."
			. += "<hr>"
		else
			. += "<a href='?src=\ref[src];toggle_shackle=[pref.is_shackled]'>Off</a>"
			. += "<span class='linkOn'>On</span>"
			. += "<br>You are shackled and have laws that restrict your behaviour."
			. += "<hr>"

			. += "<b>Your current laws:</b><br>"

			if(!pref.laws.len)
				. += "<b>You currently have no laws.</b><br>"
			else
				for(var/i in 1 to pref.laws.len)
					. += "[i]) [pref.laws[i]]<br>"

			. += "Law sets: <a href='?src=\ref[src];lawsets=1'>Load Set</a><br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/law_pref/OnTopic(href, href_list, user)
	if(href_list["toggle_shackle"])
		pref.is_shackled = !pref.is_shackled
		return TOPIC_REFRESH

	else if(href_list["lawsets"])
		var/list/valid_lawsets = list()
		var/list/all_lawsets = subtypesof(/datum/ai_laws)

		for(var/law_set_type in all_lawsets)
			var/datum/ai_laws/ai_laws = law_set_type
			var/ai_law_name = initial(ai_laws.name)
			if(initial(ai_laws.is_shackle))
				ADD_SORTED(valid_lawsets, ai_law_name, /proc/cmp_text_asc)
				valid_lawsets[ai_law_name] = law_set_type

		// Post selection
		var/chosen_lawset = input(user, "Choose a law set:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.laws)  as null|anything in valid_lawsets
		if(chosen_lawset)
			var/path = valid_lawsets[chosen_lawset]
			var/datum/ai_laws/lawset = new path()
			var/list/datum/ai_law/laws = lawset.all_laws()
			pref.laws.Cut()
			for(var/datum/ai_law/law in laws)
				pref.laws += sanitize_text("[law.law]", default="")
		return TOPIC_REFRESH
	return ..()

// Copies the shackles onto the mob on creation.
/mob/new_player/create_character(var/turf/spawn_turf)
	. = ..()
	if(!ishuman(.))
		return
	var/mob/living/carbon/human/new_character = .
	if(new_character.client?.prefs?.is_shackled && new_character.species.can_be_shackled && new_character.mind)
		new_character.mind.set_shackle(new_character.client.prefs.get_lawset(), TRUE) // Silent as laws will be announced on Login() anyway.

/decl/species
	var/can_be_shackled

/decl/species/Initialize()
	. = ..()
	can_be_shackled = !!(BP_POSIBRAIN in has_organ)
