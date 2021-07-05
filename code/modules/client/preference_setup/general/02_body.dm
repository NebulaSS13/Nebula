var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/species
	var/b_type                           //blood type
	var/h_style = "Bald"                 //Hair type
	var/hair_colour = COLOR_BLACK
	var/skin_colour = COLOR_BLACK
	var/facial_hair_colour = COLOR_BLACK
	var/eye_colour = COLOR_BLACK
	var/f_style = "Shaved"               //Face hair type
	var/skin_tone = 0                    //Skin tone
	var/list/body_markings = list()
	var/list/appearance_descriptors = list()
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

/datum/category_item/player_setup_item/physical/body
	name = "Body"
	sort_order = 2
	var/hide_species = TRUE

/datum/category_item/player_setup_item/physical/body/load_character(datum/pref_record_reader/R)
	pref.species =                R.read("species")
	pref.hair_colour =            R.read("hair_colour")
	pref.facial_hair_colour =     R.read("facial_hair_colour")
	pref.skin_colour =            R.read("skin_colour")
	pref.eye_colour =             R.read("eye_colour")
	pref.skin_tone =              R.read("skin_tone")
	pref.h_style =                R.read("hair_style_name")
	pref.f_style =                R.read("facial_style_name")
	pref.b_type =                 R.read("b_type")
	pref.body_markings =          R.read("body_markings")
	pref.appearance_descriptors = R.read("appearance_descriptors")
	pref.bgstate =                R.read("bgstate")

/datum/category_item/player_setup_item/physical/body/save_character(datum/pref_record_writer/W)
	W.write("species",                pref.species)
	W.write("skin_tone",              pref.skin_tone)
	W.write("hair_colour",            pref.hair_colour)
	W.write("facial_hair_colour",     pref.facial_hair_colour)
	W.write("skin_colour",            pref.skin_colour)
	W.write("eye_colour",             pref.eye_colour)
	W.write("hair_style_name",        pref.h_style)
	W.write("facial_style_name",      pref.f_style)
	W.write("b_type",                 pref.b_type)
	W.write("body_markings",          pref.body_markings)
	W.write("appearance_descriptors", pref.appearance_descriptors)
	W.write("bgstate",                pref.bgstate)

/datum/category_item/player_setup_item/physical/body/sanitize_character()

	pref.skin_colour =        pref.skin_colour        || COLOR_BLACK
	pref.hair_colour =        pref.hair_colour        || COLOR_BLACK
	pref.facial_hair_colour = pref.facial_hair_colour || COLOR_BLACK
	pref.eye_colour  =        pref.eye_colour         || COLOR_BLACK
	pref.h_style =            sanitize_inlist(pref.h_style, global.hair_styles_list, initial(pref.h_style))
	pref.f_style =            sanitize_inlist(pref.f_style, global.facial_hair_styles_list, initial(pref.f_style))
	pref.b_type =             sanitize_text(pref.b_type, initial(pref.b_type))

	if(!pref.b_type || !(pref.b_type in global.valid_bloodtypes))
		pref.b_type = RANDOM_BLOOD_TYPE

	if(!pref.species || !(pref.species in get_playable_species()))
		pref.species = global.using_map.default_species

	var/decl/species/mob_species = get_species_by_key(pref.species)

	var/low_skin_tone = mob_species ? (35 - mob_species.max_skin_tone()) : -185
	sanitize_integer(pref.skin_tone, low_skin_tone, 34, initial(pref.skin_tone))

	if(!istype(pref.body_markings))
		pref.body_markings = list()
	else
		pref.body_markings &= global.body_marking_styles_list

	var/list/last_descriptors = list()
	if(islist(pref.appearance_descriptors))
		last_descriptors = pref.appearance_descriptors.Copy()

	pref.appearance_descriptors = list()
	for(var/entry in mob_species.appearance_descriptors)
		var/datum/appearance_descriptor/descriptor = mob_species.appearance_descriptors[entry]
		if(istype(descriptor))
			if(isnull(last_descriptors[descriptor.name]))
				pref.appearance_descriptors[descriptor.name] = descriptor.default_value // Species datums have initial default value.
			else
				pref.appearance_descriptors[descriptor.name] = descriptor.sanitize_value(last_descriptors[descriptor.name])

	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

/datum/category_item/player_setup_item/physical/body/content(var/mob/user)
	. = list()

	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/title = "<b>Species<a href='?src=\ref[src];show_species=1'><small>?</small></a>:</b> <a href='?src=\ref[src];set_species=1'>[mob_species.name]</a>"
	var/append_text = "<a href='?src=\ref[src];toggle_species_verbose=1'>[hide_species ? "Expand" : "Collapse"]</a>"
	. += "<hr>"
	. += mob_species.get_description(title, append_text, verbose = !hide_species, skip_detail = TRUE, skip_photo = TRUE)
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"

	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"

	if(has_flag(mob_species, HAS_A_SKIN_TONE))
		. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.skin_tone + 35]/[mob_species.max_skin_tone()]</a><br>"
	. += "</td></tr></table><hr/>"

	if(LAZYLEN(pref.appearance_descriptors))
		. += "<h3>Physical Appearance</h3>"
		. += "<table width = '100%'>"
		for(var/entry in pref.appearance_descriptors)
			var/datum/appearance_descriptor/descriptor = mob_species.appearance_descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]</b></td>"
			if(descriptor.has_custom_value())
				. += "<td align = 'center' width = '50px'><a href='?src=\ref[src];set_descriptor=\ref[descriptor];set_descriptor_custom=1'>[descriptor.get_value_text(pref.appearance_descriptors[entry])]</a></td><td align = 'center'>"
			else
				. += "<td align = 'center' colspan = 2>"
			for(var/i = descriptor.chargen_min_index to descriptor.chargen_max_index)
				var/use_string = descriptor.chargen_value_descriptors[i]
				var/desc_index = descriptor.get_index_from_value(pref.appearance_descriptors[entry])
				if(i == desc_index)
					. += "<span class='linkOn'>[use_string]</span>"
				else
					. += "<a href='?src=\ref[src];set_descriptor=\ref[descriptor];set_descriptor_value=[i]'>[use_string]</a>"
			. += "</td></tr>"
		. += "</table>"

	. += "<h3>Colouration</h3>"
	. += "<table width = '100%'>"
	. += "<tr>"
	. += "<td><b>Hair</b></td>"
	. += "<td><a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a></td>"
	. += "<td>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<font face='fixedsys' size='3' color='[pref.hair_colour]'><table style='display:inline;' bgcolor='[pref.hair_colour]'><tr><td>__</td></tr></table></font> <a href='?src=\ref[src];hair_color=1'>Change</a>"
	. += "</td>"
	. += "<tr>"
	. += "</tr>"
	. += "<td><b>Facial</b></td>"
	. += "<td><a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a></td>"
	. += "<td>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<font face='fixedsys' size='3' color='[pref.facial_hair_colour]'><table  style='display:inline;' bgcolor='[pref.facial_hair_colour]'><tr><td>__</td></tr></table></font> <a href='?src=\ref[src];facial_color=1'>Change</a>"
	. += "</td>"
	. += "</tr>"
	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<tr>"
		. += "<td><b>Eyes</b></td>"
		. += "<td><font face='fixedsys' size='3' color='[pref.eye_colour]'><table  style='display:inline;' bgcolor='[pref.eye_colour]'><tr><td>__</td></tr></table></font> <a href='?src=\ref[src];eye_color=1'>Change</a></td>"
		. += "</tr>"
	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<tr>"
		. += "<td><b>Body</b></td>"
		. += "<td><font face='fixedsys' size='3' color='[pref.skin_colour]'><table style='display:inline;' bgcolor='[pref.skin_colour]'><tr><td>__</td></tr></table></font> <a href='?src=\ref[src];skin_color=1'>Change</a></td>"
		. += "</tr>"
	. += "</table>"

	. += "<h3>Markings</h3>"
	. += "<table width = '100%'>"
	for(var/M in pref.body_markings)
		. += "<tr>"
		. += "<td>[M]</td><td><a href='?src=\ref[src];marking_remove=[M]'>Remove</a></td>"
		. += "<td><font face='fixedsys' size='3' color='[pref.body_markings[M]]'><table style='display:inline;' bgcolor='[pref.body_markings[M]]'><tr><td>__</td></tr></table></font><a href='?src=\ref[src];marking_color=[M]'>Change</a></td>"
		. += "</tr>"
	. += "<tr><td colspan = 3><a href='?src=\ref[src];marking_style=1'>Add marking</a></td></tr>"
	. += "</table>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/body/proc/has_flag(var/decl/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/physical/body/OnTopic(var/href,var/list/href_list, var/mob/user)

	var/decl/species/mob_species = get_species_by_key(pref.species)
	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TOPIC_REFRESH

	if(href_list["set_descriptor"])

		var/datum/appearance_descriptor/descriptor = locate(href_list["set_descriptor"])
		if(istype(descriptor) && (descriptor.name in pref.appearance_descriptors))

			if(href_list["set_descriptor_value"])
				pref.appearance_descriptors[descriptor.name] = descriptor.get_value_from_index(text2num(href_list["set_descriptor_value"]))
				return TOPIC_REFRESH_UPDATE_PREVIEW

			if(href_list["set_descriptor_custom"])
				var/new_age = input(user, "Choose your character's [descriptor.name] (between [descriptor.get_min_chargen_value()] and [descriptor.get_max_chargen_value()]).", CHARACTER_PREFERENCE_INPUT_TITLE, pref.appearance_descriptors[descriptor.name]) as num|null
				if(new_age && CanUseTopic(user) && (descriptor.name in pref.appearance_descriptors))
					pref.appearance_descriptors[descriptor.name] = descriptor.sanitize_value(new_age)
					return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood-type:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in global.valid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
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

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.hair_colour) as color|null
		if(new_hair && has_flag(get_species_by_key(pref.species), HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.hair_colour = new_hair
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = mob_species.get_hair_styles()
		var/new_h_style = input(user, "Choose your character's hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.h_style)  as null|anything in valid_hairstyles

		mob_species = get_species_by_key(pref.species)
		if(new_h_style && CanUseTopic(user) && (new_h_style in mob_species.get_hair_styles()))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.facial_hair_colour) as color|null
		if(new_facial && has_flag(get_species_by_key(pref.species), HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.facial_hair_colour = new_facial
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.eye_colour) as color|null
		if(new_eyes && has_flag(get_species_by_key(pref.species), HAS_EYE_COLOR) && CanUseTopic(user))
			pref.eye_colour = new_eyes
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_A_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone. Lower numbers are lighter, higher are darker. Range: 1 to [mob_species.max_skin_tone()]", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.skin_tone) + 35) as num|null
		mob_species = get_species_by_key(pref.species)
		if(new_s_tone && has_flag(mob_species, HAS_A_SKIN_TONE) && CanUseTopic(user))
			pref.skin_tone = 35 - max(min(round(new_s_tone), mob_species.max_skin_tone()), 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.skin_colour) as color|null
		if(new_skin && has_flag(get_species_by_key(pref.species), HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.skin_colour = new_skin
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/decl/bodytype/B = mob_species.get_bodytype_by_name(pref.bodytype)
		var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(B.associated_gender)

		var/new_f_style = input(user, "Choose your character's facial-hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.f_style)  as null|anything in valid_facialhairstyles

		mob_species = get_species_by_key(pref.species)
		if(new_f_style && CanUseTopic(user) && mob_species.get_facial_hair_styles(B.associated_gender))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/disallowed_markings = list()
		for (var/M in pref.body_markings)
			var/datum/sprite_accessory/marking/mark_style = global.body_marking_styles_list[M]
			disallowed_markings |= mark_style.disallows
		var/list/usable_markings = pref.body_markings.Copy() ^ global.body_marking_styles_list.Copy()
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(is_type_in_list(S, disallowed_markings) || (S.species_allowed && !(mob_species.get_root_species_name() in S.species_allowed)) || (S.subspecies_allowed && !(mob_species.name in S.subspecies_allowed)))
				usable_markings -= M

		var/new_marking = input(user, "Choose a body marking:", CHARACTER_PREFERENCE_INPUT_TITLE)  as null|anything in usable_markings
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Choose the [M] color: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

/datum/category_item/player_setup_item/proc/ResetAllHair()
	ResetHair()
	ResetFacialHair()

/datum/category_item/player_setup_item/proc/ResetHair()
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/list/valid_hairstyles = mob_species.get_hair_styles()

	if(valid_hairstyles.len)
		pref.h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		pref.h_style = global.hair_styles_list["Bald"]

/datum/category_item/player_setup_item/proc/ResetFacialHair()
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/decl/bodytype/B = mob_species.get_bodytype_by_name(pref.bodytype)
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(B.associated_gender)

	if(valid_facialhairstyles.len)
		pref.f_style = pick(valid_facialhairstyles)
	else
		//this shouldn't happen
		pref.f_style = global.facial_hair_styles_list["Shaved"]
