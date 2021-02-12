/datum/preferences
	var/list/laws = list()
	var/has_personal_laws = FALSE

/datum/preferences/proc/get_lawset(var/mob/M)
	if(!laws || !laws.len || !has_personal_laws)
		return
	var/datum/lawset/custom_lawset = new(M)
	for(var/law in laws)
		custom_lawset.add_inherent_law(law)
	return custom_lawset

/datum/category_item/player_setup_item/law_pref
	name = "Laws"
	sort_order = 1

/datum/category_item/player_setup_item/law_pref/load_character(var/savefile/S)
	from_file(S["laws"], pref.laws)
	from_file(S["has_personal_laws"], pref.has_personal_laws)

/datum/category_item/player_setup_item/law_pref/save_character(var/savefile/S)
	to_file(S["laws"], pref.laws)
	to_file(S["has_personal_laws"], pref.has_personal_laws)

/datum/category_item/player_setup_item/law_pref/sanitize_character()
	if(!istype(pref.laws))	pref.laws = list()

	var/decl/species/species = get_species_by_key(pref.species)
	if(!length(species?.personal_lawsets))
		pref.has_personal_laws = initial(pref.has_personal_laws)
	else
		pref.has_personal_laws = sanitize_bool(pref.has_personal_laws, initial(pref.has_personal_laws))

/datum/category_item/player_setup_item/law_pref/content()
	. = list()
	var/decl/species/species = get_species_by_key(pref.species)
	if(!length(species?.personal_lawsets))
		. += "<b>Your species has no laws to abide by.</b><br>"
	else
		. += "<b>Laws: </b>"
		if(!pref.has_personal_laws)
			. += "<span class='linkOn'>Off</span>"
			. += "<a href='?src=\ref[src];toggle_personal_laws=[pref.has_personal_laws]'>Enable</a>"
		else
			. += "<a href='?src=\ref[src];toggle_personal_laws=[pref.has_personal_laws]'>Disable</a>"
			. += "<span class='linkOn'>On</span>"
			. += "<br>You have inviolable laws that restrict your behaviour."
			. += "<hr>"
			. += "<b>Your current laws:</b><br>"
			if(!pref.laws.len)
				. += "<b>You currently have no laws.</b><br>"
			else
				. += "<ul>"
				for(var/i in 1 to length(pref.laws))
					. += "<li>[i]) [pref.laws[i]]</li>"
				. += "</ul>"
			. += "<b>Lawsets:</b> <a href='?src=\ref[src];lawsets=1'>Load Set</a><br>"
		. += "<hr>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/law_pref/OnTopic(href, href_list, user)
	if(href_list["toggle_personal_laws"])
		pref.has_personal_laws = !pref.has_personal_laws
		return TOPIC_REFRESH

	else if(href_list["lawsets"])

		var/list/valid_lawsets = list()
		var/decl/species/species = get_species_by_key(pref.species)
		for(var/law_set_type in species?.personal_lawsets)
			var/decl/lawset/laws = decls_repository.get_decl(law_set_type)
			var/law_name = laws.name
			ADD_SORTED(valid_lawsets, law_name, /proc/cmp_text_asc)
			valid_lawsets[law_name] = laws

		// Post selection
		var/chosen_lawset = input(user, "Choose a law set:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.laws)  as null|anything in valid_lawsets
		if(chosen_lawset)
			var/decl/lawset/lawset = valid_lawsets[chosen_lawset]
			pref.laws.Cut()
			for(var/datum/law/law in lawset.get_all_laws())
				pref.laws += sanitize_text("[law.law_text]", default="")
		return TOPIC_REFRESH
	return ..()
