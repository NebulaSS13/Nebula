/datum/preferences
	var/species
	var/blood_type                           //blood type

	var/eye_colour = COLOR_BLACK
	var/skin_colour = COLOR_BLACK
	var/skin_tone = 0                    //Skin tone
	var/list/sprite_accessories = list()
	var/list/appearance_descriptors = list()
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

/datum/category_item/player_setup_item/physical/body
	name = "Body"
	sort_order = 2

/datum/category_item/player_setup_item/physical/body/load_character(datum/pref_record_reader/R)

	pref.skin_colour =            R.read("skin_colour")
	pref.eye_colour =             R.read("eye_colour")
	pref.skin_tone =              R.read("skin_tone")
	pref.blood_type =             R.read("b_type")
	pref.appearance_descriptors = R.read("appearance_descriptors")
	pref.bgstate =                R.read("bgstate")

	// Load all of our saved accessories.
	pref.sprite_accessories = list()
	var/list/load_accessories = R.read("sprite_accessories")
	for(var/category_string in load_accessories)
		var/decl/sprite_accessory_category/category_type = text2path(category_string)
		if(!ispath(category_type, /decl/sprite_accessory_category))
			continue
		pref.sprite_accessories[category_type] = list()
		for(var/accessory_name in load_accessories[category_string])
			var/decl/sprite_accessory/loaded_accessory = decls_repository.get_decl_by_id_or_var(accessory_name, category_type.base_accessory_type)
			if(!istype(loaded_accessory, category_type))
				continue
			pref.sprite_accessories[category_type][loaded_accessory.type] = load_accessories[category_string][accessory_name]
	world.log << "1 load [json_encode(pref.sprite_accessories)]"

	// Grandfather in pre-existing hair and markings.
	var/decl/style_decl
	var/decl/sprite_accessory_category/accessory_cat
	var/hair_name = R.read("hair_style_name")
	if(hair_name)
		accessory_cat = GET_DECL(/decl/sprite_accessory_category/hair)
		style_decl = decls_repository.get_decl_by_id_or_var(hair_name, accessory_cat.base_accessory_type)
		if(style_decl)
			LAZYINITLIST(pref.sprite_accessories[accessory_cat.type])
			pref.sprite_accessories[accessory_cat.type][style_decl.type] = R.read("hair_colour") || COLOR_BLACK
	world.log << "2 load [json_encode(pref.sprite_accessories)]"

	hair_name = R.read("facial_style_name")
	if(hair_name)
		accessory_cat = GET_DECL(/decl/sprite_accessory_category/facial_hair)
		style_decl = decls_repository.get_decl_by_id_or_var(hair_name, accessory_cat.base_accessory_type)
		if(style_decl)
			LAZYINITLIST(pref.sprite_accessories[accessory_cat.type])
			pref.sprite_accessories[accessory_cat.type][style_decl.type] = R.read("facial_hair_colour") || COLOR_BLACK
	world.log << "3 load [json_encode(pref.sprite_accessories)]"

	var/list/load_markings = R.read("body_markings")
	if(length(load_markings))
		accessory_cat = GET_DECL(/decl/sprite_accessory_category/markings)
		for(var/accessory in load_markings)
			style_decl = decls_repository.get_decl_by_id_or_var(accessory, accessory_cat.base_accessory_type)
			if(style_decl)
				LAZYINITLIST(pref.sprite_accessories[accessory_cat.type])
				pref.sprite_accessories[accessory_cat.type][style_decl.type] = load_markings[accessory] || COLOR_BLACK
	world.log << "4 load [json_encode(pref.sprite_accessories)]"

/datum/category_item/player_setup_item/physical/body/save_character(datum/pref_record_writer/W)

	W.write("skin_tone",              pref.skin_tone)
	W.write("skin_colour",            pref.skin_colour)
	W.write("eye_colour",             pref.eye_colour)
	W.write("b_type",                 pref.blood_type)
	W.write("appearance_descriptors", pref.appearance_descriptors)
	W.write("bgstate",                pref.bgstate)

	var/list/save_accessories = list()
	for(var/acc_cat in pref.sprite_accessories)
		save_accessories["[acc_cat]"] = list()
		for(var/acc in pref.sprite_accessories[acc_cat])
			var/decl/sprite_accessory/accessory = GET_DECL(acc)
			save_accessories["[acc_cat]"][accessory.uid] = pref.sprite_accessories[acc_cat][acc]
	W.write("sprite_accessories", save_accessories)
	world.log << "5 save [save_accessories]"

/datum/category_item/player_setup_item/physical/body/sanitize_character()

	pref.skin_colour =        pref.skin_colour        || COLOR_BLACK
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

	world.log << "6 sanitize [pref.sprite_accessories]"
	var/pref_mob = preference_mob()
	for(var/acc_cat in pref.sprite_accessories)
		for(var/acc in pref.sprite_accessories[acc_cat])
			var/decl/sprite_accessory/accessory = GET_DECL(acc)
			if(!istype(accessory, acc_cat) || !accessory.accessory_is_available(pref_mob, mob_species, mob_bodytype))
				pref.sprite_accessories[acc_cat] -= acc
		if(!length(pref.sprite_accessories[acc_cat]))
			pref.sprite_accessories -= acc_cat
	UNSETEMPTY(pref.sprite_accessories)
	world.log << "7 sanitize [pref.sprite_accessories]"

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
	. += "<table width = '500px'>"

	var/const/up_arrow    = "&#8679;"
	var/const/down_arrow  = "&#8681;"
	var/const/left_arrow  = "&#8678;"
	var/const/right_arrow = "&#8680;"

	for(var/accessory_category in mob_species.available_accessory_categories)
		var/decl/sprite_accessory_category/accessory_cat_decl = GET_DECL(accessory_category)
		var/list/current_accessories = LAZYACCESS(pref.sprite_accessories, accessory_category)
		var/cat_decl_ref = "\ref[accessory_cat_decl]"
		if(accessory_cat_decl.single_selection)
			var/current_accessory = length(current_accessories) ? current_accessories[1]                 : accessory_cat_decl.default_accessory
			var/accessory_color =   length(current_accessories) ? current_accessories[current_accessory] : accessory_cat_decl.default_accessory_color
			var/decl/sprite_accessory/accessory_decl = GET_DECL(current_accessory)
			var/acc_decl_ref = "\ref[accessory_decl]"
			. += "<tr>"
			. += "<td width = '100px'><b>[accessory_cat_decl.name]</b></td>"
			. += "<td width = '100px'>[COLORED_SQUARE(accessory_color)] <a href='?src=\ref[src];acc_color=[acc_decl_ref]'>Change</a></td>"
			. += "<td width = '20px'><a href='?src=\ref[src];acc_prev=[cat_decl_ref]'>[left_arrow]</a></td>"
			. += "<td width = '260px'><a href='?src=\ref[src];acc_style=[cat_decl_ref]'>[accessory_decl.name]</a></td>"
			. += "<td width = '20px'><a href='?src=\ref[src];acc_next=[cat_decl_ref]'>[right_arrow]</a></td>"
			. += "</tr>"
			continue

		. += "<tr>"
		. += "<td width = '100px'><b>[accessory_cat_decl.name]</b></td>"
		. += "<td width = '400px' colspan = 4></td>"
		. += "</tr>"

		var/i = 0
		for(var/accessory in current_accessories)
			i++
			var/decl/sprite_accessory/accessory_decl = GET_DECL(accessory)
			var/acc_decl_ref = "\ref[accessory_decl]"
			. += "<tr>"
			. += "<td width = '100px'><a href='?src=\ref[src];acc_remove=[acc_decl_ref]'>Remove</a></td>"
			. += "<td width = '100px'>[COLORED_SQUARE(current_accessories[accessory])] <a href='?src=\ref[src];acc_color=[acc_decl_ref]'>Change</a></td>"
			. += "<td width = '20px'><a href='?src=\ref[src];acc_move_up=[acc_decl_ref]'>[up_arrow]</a></td>"
			. += "<td width = '260px'>[accessory_decl.name]</td>"
			. += "<td width = '20px'><a href='?src=\ref[src];acc_move_down=[acc_decl_ref]'>[down_arrow]</a></td>"
			. += "</tr>"
		if(isnull(accessory_cat_decl.max_selections) || i < accessory_cat_decl.max_selections)
			. += "<tr><td colspan = 5 width = '500px'><a href='?src=\ref[src];acc_style=[cat_decl_ref]'>Add marking</a></td></tr>"

	if(mob_bodytype.appearance_flags & HAS_EYE_COLOR)
		. += "<tr>"
		. += "<td width = '100px'><b>Eyes</b></td>"
		. += "<td width = '100px'>[COLORED_SQUARE(pref.eye_colour)] <a href='?src=\ref[src];eye_color=1'>Change</a></td>"
		. += "<td colspan = 3 width = '300px'><td>"
		. += "</tr>"

	if(mob_bodytype.appearance_flags & HAS_SKIN_COLOR)
		. += "<tr>"
		. += "<td width = '100px'><b>Body</b></td>"
		. += "<td width = '100px'>[COLORED_SQUARE(pref.skin_colour)] <a href='?src=\ref[src];skin_color=1'>Change</a></td>"
		. += "<td colspan = 3 width = '300px'><td>"
		. += "</tr>"
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

/*
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

		var/decl/sprite_accessory/new_h_style = input(user, "Choose your character's hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.h_style)  as null|anything in mob_species.get_hair_styles(mob_bodytype)
		mob_species =  get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_h_style && CanUseTopic(user) && (new_h_style in mob_species.get_hair_styles(mob_bodytype)))
			pref.h_style = new_h_style.type
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_next"] || href_list["hair_prev"])
		var/decl/sprite_accessory/current_hair = GET_DECL(pref.h_style)
		var/list/available_hair = mob_species.get_hair_styles(mob_bodytype)
		if(current_hair in available_hair)
			if(href_list["hair_next"])
				current_hair = next_in_list(current_hair, available_hair)
			else if(href_list["hair_prev"])
				current_hair = previous_in_list(current_hair, available_hair)
			if(istype(current_hair) && pref.h_style != current_hair.type)
				pref.h_style = current_hair.type
				return TOPIC_REFRESH_UPDATE_PREVIEW

		return TOPIC_NOACTION
	else if(href_list["facial_style"])

		var/decl/sprite_accessory/new_f_style = input(user, "Choose your character's facial-hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, GET_DECL(pref.f_style)) as null|anything in mob_species.get_facial_hair_styles(mob_bodytype)
		mob_species =  get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_f_style && CanUseTopic(user) && (new_f_style in mob_species.get_facial_hair_styles(mob_bodytype)))
			pref.f_style = new_f_style.type
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_next"] || href_list["facial_prev"])

		var/decl/sprite_accessory/current_facial_hair = GET_DECL(pref.f_style)
		var/list/available_facial_hair = mob_species.get_facial_hair_styles(mob_bodytype)
		if(current_facial_hair in available_facial_hair)
			if(href_list["facial_next"])
				current_facial_hair = next_in_list(current_facial_hair, available_facial_hair)
			else if(href_list["facial_prev"])
				current_facial_hair = previous_in_list(current_facial_hair, available_facial_hair)
			if(istype(current_facial_hair) && pref.f_style != current_facial_hair.type)
				pref.f_style = current_facial_hair.type
				return TOPIC_REFRESH_UPDATE_PREVIEW

		return TOPIC_NOACTION

	else if(href_list["facial_color"])
		if(!(mob_bodytype.appearance_flags & HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.facial_hair_colour) as color|null
		mob_species = get_species_by_key(pref.species)
		mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
		if(new_facial && (mob_bodytype.appearance_flags & HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.facial_hair_colour = new_facial
			return TOPIC_REFRESH_UPDATE_PREVIEW

	//TODO SPRITE ACCESSORY UPDATE
	else if(href_list["marking_style"])

		var/decl/sprite_accessory/new_marking = input(user, "Choose a body marking:", CHARACTER_PREFERENCE_INPUT_TITLE)  as null|anything in get_usable_markings(preference_mob(), mob_species, mob_bodytype, pref.body_markings)
		if(new_marking && CanUseTopic(user))
			mob_species = get_species_by_key(pref.species)
			mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
			if(new_marking in get_usable_markings(preference_mob(), mob_species, mob_bodytype, pref.body_markings))
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

	else if(href_list["marking_move_down"])
		var/decl/sprite_accessory/M = locate(href_list["marking_move_down"])
		if(istype(M))
			var/current_index = pref.body_markings.Find(M.type)
			if(current_index < length(pref.body_markings))
				var/marking_color = pref.body_markings[M.type]
				pref.body_markings -= M.type
				pref.body_markings.Insert(current_index+1, M.type)
				pref.body_markings[M.type] = marking_color
				return TOPIC_REFRESH_UPDATE_PREVIEW
		return TOPIC_NOACTION

	else if(href_list["marking_move_up"])
		var/decl/sprite_accessory/M = locate(href_list["marking_move_up"])
		if(istype(M))
			var/current_index = pref.body_markings.Find(M.type)
			if(current_index > 1)
				var/marking_color = pref.body_markings[M.type]
				pref.body_markings -= M.type
				pref.body_markings.Insert(current_index-1, M.type)
				pref.body_markings[M.type] = marking_color
				return TOPIC_REFRESH_UPDATE_PREVIEW
		return TOPIC_NOACTION


	acc_color=[acc_decl_ref]
	acc_prev=[cat_decl_ref]
	acc_style=[cat_decl_ref]
	acc_next=[cat_decl_ref]

	acc_remove=[acc_decl_ref]
	acc_color=[acc_decl_ref]
	acc_move_up=[acc_decl_ref]
	acc_move_down=[acc_decl_ref]

	*/

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

/datum/category_item/player_setup_item/physical/body/proc/get_usable_markings(mob/pref_mob, decl/species/mob_species, decl/bodytype/mob_bodytype, list/existing_markings)
	var/list/disallowed_markings = list()
	for (var/accessory in existing_markings)
		var/decl/sprite_accessory/accessory_decl = GET_DECL(accessory)
		if(length(accessory_decl.disallows_accessories))
			disallowed_markings |= accessory_decl.disallows_accessories
	var/list/all_markings = decls_repository.get_decls_of_subtype(/decl/sprite_accessory/marking)
	for(var/M in all_markings)
		if(M in existing_markings)
			continue
		var/decl/sprite_accessory/accessory = all_markings[M]
		if(!is_type_in_list(accessory, disallowed_markings) && accessory.accessory_is_available(pref_mob, mob_species, mob_bodytype))
			LAZYADD(., accessory)
