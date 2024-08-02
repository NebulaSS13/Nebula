/datum/preferences
	var/species
	var/blood_type                           //blood type

	var/eye_colour = COLOR_BLACK
	var/skin_colour = COLOR_BLACK
	var/skin_tone = 0                    //Skin tone
	var/list/sprite_accessories = list()
	var/list/appearance_descriptors = list()
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate

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
	for(var/category_uid in load_accessories)
		var/decl/sprite_accessory_category/accessory_category = decls_repository.get_decl_by_id_or_var(category_uid, /decl/sprite_accessory_category)
		if(!istype(accessory_category))
			continue
		pref.sprite_accessories[accessory_category.type] = list()
		for(var/accessory_name in load_accessories[category_uid])
			var/decl/sprite_accessory/loaded_accessory = decls_repository.get_decl_by_id_or_var(accessory_name, accessory_category.base_accessory_type)
			if(istype(loaded_accessory, accessory_category.base_accessory_type))
				pref.sprite_accessories[accessory_category.type][loaded_accessory.type] = load_accessories[category_uid][accessory_name]

	// Grandfather in pre-existing hair and markings.
	var/decl/style_decl
	var/decl/sprite_accessory_category/accessory_cat
	var/hair_name = R.read("hair_style_name")
	if(hair_name)
		accessory_cat = GET_DECL(SAC_HAIR)
		style_decl = decls_repository.get_decl_by_id_or_var(hair_name, accessory_cat.base_accessory_type)
		if(style_decl)
			LAZYINITLIST(pref.sprite_accessories[accessory_cat.type])
			pref.sprite_accessories[accessory_cat.type][style_decl.type] = R.read("hair_colour") || COLOR_BLACK

	hair_name = R.read("facial_style_name")
	if(hair_name)
		accessory_cat = GET_DECL(SAC_FACIAL_HAIR)
		style_decl = decls_repository.get_decl_by_id_or_var(hair_name, accessory_cat.base_accessory_type)
		if(style_decl)
			LAZYINITLIST(pref.sprite_accessories[accessory_cat.type])
			pref.sprite_accessories[accessory_cat.type][style_decl.type] = R.read("facial_hair_colour") || COLOR_BLACK

	var/list/load_markings = R.read("body_markings")
	if(length(load_markings))
		accessory_cat = GET_DECL(SAC_MARKINGS)
		for(var/accessory in load_markings)
			style_decl = decls_repository.get_decl_by_id_or_var(accessory, accessory_cat.base_accessory_type)
			if(style_decl)
				LAZYINITLIST(pref.sprite_accessories[accessory_cat.type])
				pref.sprite_accessories[accessory_cat.type][style_decl.type] = load_markings[accessory] || COLOR_BLACK

	if(!pref.bgstate || !(pref.bgstate in global.using_map.char_preview_bgstate_options))
		pref.bgstate = global.using_map.char_preview_bgstate_options[1]

/datum/category_item/player_setup_item/physical/body/save_character(datum/pref_record_writer/W)

	var/list/save_accessories = list()
	for(var/acc_cat in pref.sprite_accessories)
		var/decl/sprite_accessory_category/accessory_category = GET_DECL(acc_cat)
		save_accessories[accessory_category.uid] = list()
		for(var/acc in pref.sprite_accessories[acc_cat])
			var/decl/sprite_accessory/accessory = GET_DECL(acc)
			save_accessories[accessory_category.uid][accessory.uid] = pref.sprite_accessories[acc_cat][acc]

	W.write("sprite_accessories",     save_accessories)
	W.write("skin_tone",              pref.skin_tone)
	W.write("skin_colour",            pref.skin_colour)
	W.write("eye_colour",             pref.eye_colour)
	W.write("b_type",                 pref.blood_type)
	W.write("appearance_descriptors", pref.appearance_descriptors)
	W.write("bgstate",                pref.bgstate)

/datum/category_item/player_setup_item/physical/body/sanitize_character()
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/decl/bodytype/mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
	if(mob_bodytype.appearance_flags & HAS_SKIN_COLOR)
		pref.skin_colour = pref.skin_colour || mob_bodytype.base_color     || COLOR_BLACK
	else
		pref.skin_colour = mob_bodytype.base_color     || COLOR_BLACK
	if(mob_bodytype.appearance_flags & HAS_EYE_COLOR)
		pref.eye_colour  = pref.eye_colour  || mob_bodytype.base_eye_color || COLOR_BLACK
	else
		pref.eye_colour  = mob_bodytype.base_eye_color || COLOR_BLACK

	pref.blood_type = sanitize_text(pref.blood_type, initial(pref.blood_type))

	if(!pref.species || !(pref.species in get_playable_species()))
		pref.species = global.using_map.default_species

	if(!pref.blood_type || !(pref.blood_type in mob_species.blood_types))
		pref.blood_type = pickweight(mob_species.blood_types)

	var/low_skin_tone = mob_bodytype ? (35 - mob_bodytype.max_skin_tone()) : -185
	sanitize_integer(pref.skin_tone, low_skin_tone, 34, initial(pref.skin_tone))

	var/acc_mob = get_mannequin(pref.client?.ckey)
	LAZYINITLIST(pref.sprite_accessories)
	for(var/acc_cat in pref.sprite_accessories)
		if(!(acc_cat in mob_species.available_accessory_categories))
			pref.sprite_accessories -= acc_cat
			continue
		var/decl/sprite_accessory_category/accessory_category = GET_DECL(acc_cat)
		for(var/acc in pref.sprite_accessories[acc_cat])
			var/decl/sprite_accessory/accessory = GET_DECL(acc)
			if(!istype(accessory, accessory_category.base_accessory_type) || !accessory.accessory_is_available(acc_mob, mob_species, mob_bodytype))
				pref.sprite_accessories[acc_cat] -= acc

	for(var/accessory_category in mob_species.available_accessory_categories)
		LAZYINITLIST(pref.sprite_accessories[accessory_category])
		var/decl/sprite_accessory_category/accessory_cat_decl = GET_DECL(accessory_category)
		if(accessory_cat_decl.single_selection)
			var/list/current_accessories = pref.sprite_accessories[accessory_category]
			if(!length(current_accessories))
				current_accessories[accessory_cat_decl.default_accessory] = accessory_cat_decl.default_accessory_color
			else if(length(current_accessories) > 1)
				current_accessories.Cut(2)

	var/list/last_descriptors = list()
	if(islist(pref.appearance_descriptors))
		last_descriptors = pref.appearance_descriptors.Copy()

	pref.appearance_descriptors = list()
	for(var/entry in mob_bodytype.appearance_descriptors)
		var/datum/appearance_descriptor/descriptor = mob_bodytype.appearance_descriptors[entry]
		if(istype(descriptor))
			if(isnull(last_descriptors[descriptor.name]))
				pref.appearance_descriptors[descriptor.name] = descriptor.default_value // Species datums have initial default value.
			else
				pref.appearance_descriptors[descriptor.name] = descriptor.sanitize_value(last_descriptors[descriptor.name])

	if(!pref.bgstate || !(pref.bgstate in global.using_map.char_preview_bgstate_options))
		pref.bgstate = global.using_map.char_preview_bgstate_options[1]

/datum/category_item/player_setup_item/physical/body/content(var/mob/user)
	. = list()

	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/decl/bodytype/mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
	. += "Blood Type: <a href='byond://?src=\ref[src];blood_type=1'>[pref.blood_type]</a><br>"
	. += "<a href='byond://?src=\ref[src];random=1'>Randomize Appearance</A><br>"

	if(LAZYLEN(pref.appearance_descriptors))
		. += "<h3>Physical Appearance</h3>"
		. += "<table width = '100%'>"
		for(var/entry in pref.appearance_descriptors)
			var/datum/appearance_descriptor/descriptor = mob_bodytype.appearance_descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]</b></td>"
			if(descriptor.has_custom_value())
				. += "<td align = 'left' width = '50px'><a href='byond://?src=\ref[src];set_descriptor=\ref[descriptor];set_descriptor_custom=1'>[descriptor.get_value_text(pref.appearance_descriptors[entry])]</a></td><td align = 'left'>"
			else
				. += "<td align = 'left' colspan = 2>"
			for(var/i = descriptor.chargen_min_index to descriptor.chargen_max_index)
				var/use_string = descriptor.chargen_value_descriptors[i]
				var/desc_index = descriptor.get_index_from_value(pref.appearance_descriptors[entry])
				if(i == desc_index)
					. += "<span class='linkOn'>[use_string]</span>"
				else
					. += "<a href='byond://?src=\ref[src];set_descriptor=\ref[descriptor];set_descriptor_value=[i]'>[use_string]</a>"
			. += "</td></tr>"
		. += "</table>"

	if((mob_bodytype.appearance_flags & (HAS_EYE_COLOR|HAS_SKIN_COLOR|HAS_A_SKIN_TONE)) || length(mob_species.available_accessory_categories))

		. += "<h3>Colouration and accessories</h3>"
		. += "<table width = '500px'>"

		if(mob_bodytype.appearance_flags & HAS_A_SKIN_TONE)
			. += "<tr>"
			. += "<td width = '100px'><b>Skin tone</b></td>"
			. += "<td width = '100px'><a href='byond://?src=\ref[src];skin_tone=1'>[-pref.skin_tone + 35]/[mob_bodytype.max_skin_tone()]</a></td>"
			. += "<td colspan = 3 width = '300px'><td>"
			. += "</tr>"

		if(mob_bodytype.appearance_flags & HAS_SKIN_COLOR)
			. += "<tr>"
			. += "<td width = '100px'><b>Skin color</b></td>"
			. += "<td width = '100px'>[COLORED_SQUARE(pref.skin_colour)] <a href='byond://?src=\ref[src];skin_color=1'>Change</a></td>"
			. += "<td colspan = 3 width = '300px'><td>"
			. += "</tr>"

		if(mob_bodytype.appearance_flags & HAS_EYE_COLOR)
			. += "<tr>"
			. += "<td width = '100px'><b>Eyes</b></td>"
			. += "<td width = '100px'>[COLORED_SQUARE(pref.eye_colour)] <a href='byond://?src=\ref[src];eye_color=1'>Change</a></td>"
			. += "<td colspan = 3 width = '300px'><td>"
			. += "</tr>"

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
				. += "<td width = '100px'>[COLORED_SQUARE(accessory_color)] <a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_color=1'>Change</a></td>"
				. += "<td width = '20px'><a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_prev=1'>[left_arrow]</a></td>"
				. += "<td width = '260px'><a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_style=1'>[accessory_decl.name]</a></td>"
				. += "<td width = '20px'><a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_next=1'>[right_arrow]</a></td>"
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
				. += "<td width = '100px'><a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_remove=1'>Remove</a></td>"
				. += "<td width = '100px'>[COLORED_SQUARE(current_accessories[accessory])] <a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_color=1'>Change</a></td>"
				. += "<td width = '20px'><a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_move_up=1'>[up_arrow]</a></td>"
				. += "<td width = '260px'>[accessory_decl.name]</td>"
				. += "<td width = '20px'><a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_decl=[acc_decl_ref];acc_move_down=1'>[down_arrow]</a></td>"
				. += "</tr>"
			if(isnull(accessory_cat_decl.max_selections) || i < accessory_cat_decl.max_selections)
				. += "<tr><td colspan = 5 width = '500px'><a href='byond://?src=\ref[src];acc_cat_decl=[cat_decl_ref];acc_style=1'>Add marking</a></td></tr>"

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
		pref.randomize_appearance_and_body_for(get_mannequin(pref.client?.ckey))
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood type:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in mob_species.blood_types
		if(new_b_type && CanUseTopic(user))
			mob_species = get_species_by_key(pref.species)
			if(new_b_type in mob_species.blood_types)
				pref.blood_type = new_b_type
				return TOPIC_REFRESH

	else if (href_list["acc_decl"] || href_list["acc_cat_decl"])

		var/decl/sprite_accessory/accessory_decl = locate(href_list["acc_decl"])
		var/decl/sprite_accessory_category/accessory_category = locate(href_list["acc_cat_decl"])
		if(!istype(accessory_decl) && !istype(accessory_category))
			return TOPIC_NOACTION
		if(!istype(accessory_category))
			accessory_category = GET_DECL(accessory_decl.accessory_category)
		if(!(accessory_category.type in mob_species.available_accessory_categories))
			return TOPIC_NOACTION

		// Ensure we have a list for the category.
		var/list/current_accessories = pref.sprite_accessories[accessory_category.type]
		if(!current_accessories)
			current_accessories = list()
			pref.sprite_accessories[accessory_category.type] = current_accessories

		if(href_list["acc_color"])

			if(!istype(accessory_decl))
				return TOPIC_NOACTION
			var/cur_color = current_accessories[accessory_decl.type] || COLOR_BLACK
			var/acc_color = input(user, "Choose a colour for your [accessory_decl.name]: ", CHARACTER_PREFERENCE_INPUT_TITLE, cur_color) as color|null
			if(!acc_color || acc_color == cur_color || !(accessory_decl.type in current_accessories))
				return TOPIC_NOACTION
			if(accessory_category.single_selection)
				current_accessories.Cut()
			current_accessories[accessory_decl.type] = acc_color
			return TOPIC_REFRESH_UPDATE_PREVIEW

		else if(href_list["acc_style"])

			var/decl/sprite_accessory/new_accessory = input(user, "Choose an accessory:", CHARACTER_PREFERENCE_INPUT_TITLE)  as null|anything in pref.get_usable_sprite_accessories(get_mannequin(pref.client?.ckey), mob_species, mob_bodytype, accessory_category.type, current_accessories - accessory_decl?.type)
			if(!(new_accessory in pref.get_usable_sprite_accessories(get_mannequin(pref.client?.ckey), mob_species, mob_bodytype, accessory_category.type, current_accessories)))
				return TOPIC_NOACTION
			var/style_colour = (accessory_decl && current_accessories[accessory_decl.type]) || accessory_category.default_accessory_color
			if(accessory_category.single_selection)
				current_accessories.Cut()
			current_accessories[new_accessory.type] = style_colour
			return TOPIC_REFRESH_UPDATE_PREVIEW

		else if(accessory_category.single_selection && (href_list["acc_next"] || href_list["acc_prev"]))

			if(!length(current_accessories) || !istype(accessory_decl))
				return TOPIC_NOACTION
			var/decl/sprite_accessory/next_accessory_decl
			var/style_colour = current_accessories[accessory_decl.type]
			var/list/available_accessories = pref.get_usable_sprite_accessories(get_mannequin(pref.client?.ckey), mob_species, mob_bodytype, accessory_category.type, current_accessories - accessory_decl?.type)
			if(length(available_accessories) <= 1)
				return TOPIC_NOACTION

			if(href_list["acc_next"])
				next_accessory_decl = next_in_list(accessory_decl, available_accessories)
			else if(href_list["acc_prev"])
				next_accessory_decl = previous_in_list(accessory_decl, available_accessories)

			if(istype(next_accessory_decl) && accessory_decl != next_accessory_decl)
				current_accessories.Cut()
				current_accessories[next_accessory_decl.type] = style_colour
				return TOPIC_REFRESH_UPDATE_PREVIEW
			return TOPIC_NOACTION

		else if(!accessory_category.single_selection)

			if(!istype(accessory_decl))
				return TOPIC_NOACTION

			if(href_list["acc_remove"])

				current_accessories -= accessory_decl.type
				return TOPIC_REFRESH_UPDATE_PREVIEW

			else if(href_list["acc_move_down"] || href_list["acc_move_up"])

				if(!length(current_accessories))
					return TOPIC_NOACTION
				var/current_index = current_accessories.Find(accessory_decl.type)
				if(href_list["acc_move_up"] && current_index <= 1)
					return TOPIC_NOACTION
				else if(href_list["acc_move_down"] && current_index >= length(current_accessories))
					return TOPIC_NOACTION
				var/accessory_color = current_accessories[accessory_decl.type]
				current_accessories -= accessory_decl.type
				if(href_list["acc_move_up"])
					current_accessories.Insert(current_index-1, accessory_decl.type)
				else if(href_list["acc_move_down"])
					current_accessories.Insert(current_index+1, accessory_decl.type)
				current_accessories[accessory_decl.type] = accessory_color
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

/datum/preferences/proc/get_usable_sprite_accessories(mob/acc_mob, decl/species/mob_species, decl/bodytype/mob_bodytype, accessory_category, list/existing_accessories)
	var/decl/sprite_accessory_category/accessory_category_decl = GET_DECL(accessory_category)
	if(!istype(accessory_category_decl))
		return
	var/list/disallowed_accessories = list()
	for (var/accessory in existing_accessories)
		var/decl/sprite_accessory/accessory_decl = GET_DECL(accessory)
		if(length(accessory_decl.disallows_accessories))
			disallowed_accessories |= accessory_decl.disallows_accessories
	var/list/all_accessories = decls_repository.get_decls_of_subtype(accessory_category_decl.base_accessory_type)
	for(var/accessory in all_accessories)
		if(accessory in existing_accessories)
			continue
		var/decl/sprite_accessory/accessory_decl = all_accessories[accessory]
		if(istype(accessory_decl) && !is_type_in_list(accessory_decl, disallowed_accessories) && accessory_decl.accessory_is_available(acc_mob, mob_species, mob_bodytype))
			LAZYADD(., accessory_decl)
	return sortTim(., /proc/cmp_name_asc)
