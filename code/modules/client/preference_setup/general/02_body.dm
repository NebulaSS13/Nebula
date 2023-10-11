/datum/preferences
	var/species
	var/blood_type                           //blood type

	var/h_style = /decl/sprite_accessory/hair/bald
	var/f_style = /decl/sprite_accessory/facial_hair/shaved

	var/hair_colour = COLOR_BLACK
	var/skin_colour = COLOR_BLACK
	var/facial_hair_colour = COLOR_BLACK
	var/eye_colour = COLOR_BLACK
	var/skin_tone = 0                    //Skin tone
	var/list/body_markings = list()
	var/list/appearance_descriptors = list()
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

/datum/category_item/player_setup_item/physical/body
	name = "Body"
	sort_order = 2

/datum/category_item/player_setup_item/physical/body/load_character(datum/pref_record_reader/R)

	pref.hair_colour =            R.read("hair_colour")
	pref.facial_hair_colour =     R.read("facial_hair_colour")
	pref.skin_colour =            R.read("skin_colour")
	pref.eye_colour =             R.read("eye_colour")
	pref.skin_tone =              R.read("skin_tone")
	pref.blood_type =             R.read("b_type")
	pref.appearance_descriptors = R.read("appearance_descriptors")
	pref.bgstate =                R.read("bgstate")

	// Get h_style type.
	var/decl/h_style_decl = decls_repository.get_decl_by_id_or_var(R.read("hair_style_name"), /decl/sprite_accessory/hair)
	pref.h_style = istype(h_style_decl) ? h_style_decl.type : /decl/sprite_accessory/hair/bald
	// Get f_style type.
	var/decl/f_style_decl = decls_repository.get_decl_by_id_or_var(R.read("facial_style_name"), /decl/sprite_accessory/facial_hair)
	pref.f_style = istype(f_style_decl) ? f_style_decl.type : /decl/sprite_accessory/facial_hair/shaved
	// Get markings type.
	var/list/load_markings = R.read("body_markings")
	pref.body_markings = list()
	if(length(load_markings))
		for(var/marking in load_markings)
			var/decl/sprite_accessory/marking/loaded_marking = decls_repository.get_decl_by_id_or_var(marking, /decl/sprite_accessory/marking)
			if(istype(loaded_marking))
				pref.body_markings[loaded_marking.type] = load_markings[marking]

/datum/category_item/player_setup_item/physical/body/save_character(datum/pref_record_writer/W)
	W.write("skin_tone",              pref.skin_tone)
	W.write("hair_colour",            pref.hair_colour)
	W.write("facial_hair_colour",     pref.facial_hair_colour)
	W.write("skin_colour",            pref.skin_colour)
	W.write("eye_colour",             pref.eye_colour)
	W.write("b_type",                 pref.blood_type)
	W.write("appearance_descriptors", pref.appearance_descriptors)
	W.write("bgstate",                pref.bgstate)

	// Get names of sprite accessories to serialize.
	var/decl/sprite_accessory/sprite = GET_DECL(pref.h_style)
	W.write("hair_style_name", sprite.uid)
	sprite = GET_DECL(pref.f_style)
	W.write("facial_style_name", sprite.uid)
	var/list/body_marking_names = list()
	for(var/marking in pref.body_markings)
		sprite = GET_DECL(marking)
		body_marking_names[sprite.uid] = pref.body_markings[marking]
	W.write("body_markings", body_marking_names)

/datum/category_item/player_setup_item/physical/body/sanitize_character()

	pref.skin_colour =        pref.skin_colour        || COLOR_BLACK
	pref.hair_colour =        pref.hair_colour        || COLOR_BLACK
	pref.facial_hair_colour = pref.facial_hair_colour || COLOR_BLACK
	pref.eye_colour  =        pref.eye_colour         || COLOR_BLACK

	pref.blood_type = sanitize_text(pref.blood_type, initial(pref.blood_type))

	if(!pref.species || !(pref.species in get_playable_species()))
		pref.species = global.using_map.default_species

	var/decl/species/mob_species = get_species_by_key(pref.species)
	if(!pref.blood_type || !(pref.blood_type in mob_species.blood_types))
		pref.blood_type = pickweight(mob_species.blood_types)

	var/decl/bodytype/mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
	var/low_skin_tone = mob_bodytype ? (35 - mob_bodytype.max_skin_tone()) : -185
	sanitize_integer(pref.skin_tone, low_skin_tone, 34, initial(pref.skin_tone))

	if(!ispath(pref.h_style, /decl/sprite_accessory/hair))
		pref.h_style = initial(pref.h_style)

	if(!ispath(pref.f_style, /decl/sprite_accessory/facial_hair))
		pref.f_style = initial(pref.f_style)

	if(!islist(pref.body_markings))
		pref.body_markings = list()
	for(var/marking in pref.body_markings)
		if(!ispath(marking, /decl/sprite_accessory/marking))
			pref.body_markings -= marking

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
	var/decl/bodytype/mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.blood_type]</a><br>"
	. += "<a href='?src=\ref[src];random=1'>Randomize Appearance</A><br>"

	if(mob_bodytype.appearance_flags & HAS_A_SKIN_TONE)
		. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.skin_tone + 35]/[mob_bodytype.max_skin_tone()]</a><br>"
	. += "</td></tr></table><hr/>"

	if(LAZYLEN(pref.appearance_descriptors))
		. += "<h3>Physical Appearance</h3>"
		. += "<table width = '100%'>"
		for(var/entry in pref.appearance_descriptors)
			var/datum/appearance_descriptor/descriptor = mob_species.appearance_descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]</b></td>"
			if(descriptor.has_custom_value())
				. += "<td align = 'left' width = '50px'><a href='?src=\ref[src];set_descriptor=\ref[descriptor];set_descriptor_custom=1'>[descriptor.get_value_text(pref.appearance_descriptors[entry])]</a></td><td align = 'left'>"
			else
				. += "<td align = 'left' colspan = 2>"
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
	. += "<td><a href='?src=\ref[src];hair_style=1'>[GET_DECL(pref.h_style)]</a></td>"
	. += "<td>"
	if(mob_bodytype.appearance_flags & HAS_HAIR_COLOR)
		. += "[COLORED_SQUARE(pref.hair_colour)] <a href='?src=\ref[src];hair_color=1'>Change</a>"
	. += "</td>"
	. += "<tr>"
	. += "</tr>"
	. += "<td><b>Facial</b></td>"
	. += "<td><a href='?src=\ref[src];facial_style=1'>[GET_DECL(pref.f_style)]</a></td>"
	. += "<td>"
	if(mob_bodytype.appearance_flags & HAS_HAIR_COLOR)
		. += "[COLORED_SQUARE(pref.facial_hair_colour)] <a href='?src=\ref[src];facial_color=1'>Change</a>"
	. += "</td>"
	. += "</tr>"
	if(mob_bodytype.appearance_flags & HAS_EYE_COLOR)
		. += "<tr>"
		. += "<td><b>Eyes</b></td>"
		. += "<td>[COLORED_SQUARE(pref.eye_colour)] <a href='?src=\ref[src];eye_color=1'>Change</a></td>"
		. += "</tr>"
	if(mob_bodytype.appearance_flags & HAS_SKIN_COLOR)
		. += "<tr>"
		. += "<td><b>Body</b></td>"
		. += "<td>[COLORED_SQUARE(pref.skin_colour)] <a href='?src=\ref[src];skin_color=1'>Change</a></td>"
		. += "</tr>"
	. += "</table>"

	. += "<h3>Markings</h3>"
	. += "<table width = '100%'>"
	for(var/M in pref.body_markings)
		var/decl/sprite_accessory/mark = GET_DECL(M)
		. += "<tr>"
		. += "<td>[mark.name]</td><td><a href='?src=\ref[src];marking_remove=\ref[mark]'>Remove</a></td>"
		. += "<td>[COLORED_SQUARE(pref.body_markings[M])] <a href='?src=\ref[src];marking_color=\ref[mark]'>Change</a></td>"
		. += "</tr>"
	. += "<tr><td colspan = 3><a href='?src=\ref[src];marking_style=1'>Add marking</a></td></tr>"
	. += "</table>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/decl/bodytype/mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
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
		var/new_b_type = input(user, "Choose your character's blood type:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in mob_species.blood_types
		if(new_b_type && CanUseTopic(user))
			mob_species = get_species_by_key(pref.species)
			if(new_b_type in mob_species.blood_types)
				pref.blood_type = new_b_type
				return TOPIC_REFRESH

	else if(href_list["hair_color"])
		if(!(mob_bodytype.appearance_flags & HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.hair_colour) as color|null
		mob_species = get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_hair && (mob_bodytype.appearance_flags & HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.hair_colour = new_hair
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])

		var/decl/bodytype/B = mob_species.get_bodytype_by_name(pref.bodytype)
		mob_species = get_species_by_key(pref.species)
		var/decl/sprite_accessory/new_h_style = input(user, "Choose your character's hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.h_style)  as null|anything in mob_species.get_hair_styles(B)
		mob_species = get_species_by_key(pref.species)
		if(new_h_style && CanUseTopic(user) && (new_h_style in mob_species.get_hair_styles(B)))
			pref.h_style = new_h_style.type
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!(mob_bodytype.appearance_flags & HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.facial_hair_colour) as color|null
		mob_species = get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_facial && (mob_bodytype.appearance_flags & HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.facial_hair_colour = new_facial
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!(mob_bodytype.appearance_flags & HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.eye_colour) as color|null
		mob_species = get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_eyes && (mob_bodytype.appearance_flags & HAS_EYE_COLOR) && CanUseTopic(user))
			pref.eye_colour = new_eyes
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!(mob_bodytype.appearance_flags & HAS_A_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone. Lower numbers are lighter, higher are darker. Range: 1 to [mob_bodytype.max_skin_tone()]", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.skin_tone) + 35) as num|null
		mob_species = get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_s_tone && (mob_bodytype.appearance_flags & HAS_A_SKIN_TONE) && CanUseTopic(user))
			pref.skin_tone = 35 - max(min(round(new_s_tone), mob_bodytype.max_skin_tone()), 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!(mob_bodytype.appearance_flags & HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.skin_colour) as color|null
		mob_species = get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_skin && (mob_bodytype.appearance_flags & HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.skin_colour = new_skin
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])

		var/decl/bodytype/B = mob_species.get_bodytype_by_name(pref.bodytype)
		mob_species = get_species_by_key(pref.species)
		var/decl/sprite_accessory/new_f_style = input(user, "Choose your character's facial-hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, GET_DECL(pref.f_style)) as null|anything in mob_species.get_facial_hair_styles(B)
		mob_species = get_species_by_key(pref.species)
		if(new_f_style && CanUseTopic(user) && (new_f_style in mob_species.get_facial_hair_styles(B)))
			pref.f_style = new_f_style.type
			return TOPIC_REFRESH_UPDATE_PREVIEW

	//TODO SPRITE ACCESSORY UPDATE
	else if(href_list["marking_style"])

		var/list/disallowed_markings = list()
		for (var/M in pref.body_markings)
			var/decl/sprite_accessory/marking/mark_style = GET_DECL(M)
			disallowed_markings |= mark_style.disallows

		var/list/usable_markings = list()
		var/list/all_markings = decls_repository.get_decls_of_subtype(/decl/sprite_accessory/marking)
		for(var/M in all_markings)
			if(M in pref.body_markings)
				continue
			var/decl/sprite_accessory/accessory = all_markings[M]
			mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype)
			if(!is_type_in_list(accessory, disallowed_markings) && accessory.accessory_is_available(preference_mob(), mob_species, mob_bodytype))
				usable_markings += accessory

		var/decl/sprite_accessory/new_marking = input(user, "Choose a body marking:", CHARACTER_PREFERENCE_INPUT_TITLE)  as null|anything in usable_markings
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking.type] = COLOR_BLACK
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/decl/sprite_accessory/M = locate(href_list["marking_remove"])
		pref.body_markings -= M.type
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/decl/sprite_accessory/M = locate(href_list["marking_color"])
		var/mark_color = input(user, "Choose the [M] color: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.body_markings[M.type]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M.type] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

/datum/category_item/player_setup_item/proc/ResetAllHair()
	ResetHair()
	ResetFacialHair()

/datum/category_item/player_setup_item/proc/ResetHair()
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/list/valid_hairstyles = mob_species?.get_hair_style_types(pref.get_bodytype_decl())
	pref.h_style = length(valid_hairstyles) ? pick(valid_hairstyles) : initial(pref.h_style)

/datum/category_item/player_setup_item/proc/ResetFacialHair()
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/list/valid_facialhairstyles = mob_species?.get_facial_hair_styles(pref.get_bodytype_decl())
	pref.f_style = length(valid_facialhairstyles) ? pick(valid_facialhairstyles) : initial(pref.f_style)
