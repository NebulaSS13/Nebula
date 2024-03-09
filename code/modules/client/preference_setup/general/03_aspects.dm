/datum/preferences
	var/list/aspects = list()

/datum/preferences/proc/prune_invalid_aspects()
	var/removed_something = TRUE
	while(removed_something && length(aspects))
		removed_something = FALSE
		for(var/aspect_type in aspects)
			var/decl/aspect/aspect = GET_DECL(aspect_type)
			if(!istype(aspect) || !aspect.is_available_to(src) || (aspect.parent && !(aspect.parent.type in aspects)))
				aspects -= aspect_type
				removed_something = TRUE
			else if(length(aspect.incompatible_with))
				for(var/incompatible_aspect in aspect.incompatible_with)
					if(incompatible_aspect in aspects)
						aspects -= incompatible_aspect
						removed_something = TRUE

/datum/category_item/player_setup_item/aspects
	name = "Aspects"
	sort_order = 1
	var/selected_category

/datum/category_item/player_setup_item/aspects/load_character(datum/pref_record_reader/R)
	pref.aspects = R.read("aspects")
	var/list/all_aspects = decls_repository.get_decls_of_subtype(/decl/aspect)
	for(var/aspect in pref.aspects)
		if(ispath(aspect, /decl/aspect))
			continue
		pref.aspects -= aspect
		for(var/aspect_type in all_aspects)
			var/decl/aspect/aspect_decl = all_aspects[aspect_type]
			if(aspect_decl.name == aspect)
				pref.aspects |= aspect_type

/datum/category_item/player_setup_item/aspects/save_character(datum/pref_record_writer/W)
	var/list/aspect_names = list()
	for(var/aspect in pref.aspects)
		var/decl/aspect/aspect_decl = GET_DECL(aspect)
		if(istype(aspect_decl))
			aspect_names |= aspect_decl.name
	W.write("aspects", aspect_names)

/datum/category_item/player_setup_item/aspects/proc/get_aspect_total()
	var/aspect_cost = 0
	for(var/aspect_type in pref.aspects)
		var/decl/aspect/A = GET_DECL(aspect_type)
		if(!A)
			return null
		aspect_cost += A.aspect_cost
	return aspect_cost

/datum/category_item/player_setup_item/aspects/finalize_character()
	pref.prune_invalid_aspects()

/datum/category_item/player_setup_item/aspects/sanitize_character()

	if(!pref.aspects)
		pref.aspects = list()

	pref.prune_invalid_aspects()

	var/modified_list = FALSE
	var/max_character_aspects = get_config_value(/decl/config/num/max_character_aspects)
	while(get_aspect_total() > max_character_aspects)

		// Find a costly aspect with no children to drop until our cost is below the threshold.
		var/can_drop_aspect = FALSE
		for(var/aspect_type in pref.aspects)

			var/decl/aspect/aspect = GET_DECL(aspect_type)
			if(aspect.aspect_cost <= 0)
				continue

			can_drop_aspect = TRUE
			for(var/decl/aspect/child in aspect.children)
				if(child.type in pref.aspects)
					can_drop_aspect = FALSE
					break

			if(can_drop_aspect)
				pref.aspects -= aspect_type
				modified_list = TRUE
				break

		if(!can_drop_aspect)
			break

	if(modified_list)
		pref.prune_invalid_aspects()

/datum/category_item/player_setup_item/aspects/content()

	var/list/available_categories = list()
	for(var/aspect_category in global.aspect_categories)
		var/datum/aspect_category/AC = global.aspect_categories[aspect_category]
		if(AC.hide_from_chargen)
			continue
		for(var/decl/aspect/aspect as anything in AC.aspects)
			if(aspect.is_available_to(pref))
				available_categories[AC.name] = AC
				break
	if(!length(available_categories))
		return

	var/aspect_total = get_aspect_total()
	// Change our formatting data if needed.
	var/fcolor =  COLOR_CYAN_BLUE
	var/max_character_aspects = get_config_value(/decl/config/num/max_character_aspects)
	if(aspect_total == max_character_aspects)
		fcolor = COLOR_FONT_ORANGE

	// Build the string.
	. = list("<center><b><font color = '[fcolor]'>[aspect_total]/[max_character_aspects]</font> points spent.</b></center><br/>")
	if(!selected_category || !(selected_category in available_categories))
		selected_category = available_categories[1]

	var/header = ""
	var/body = ""
	for(var/aspect_category in available_categories)

		var/datum/aspect_category/AC = available_categories[aspect_category]
		if(!istype(AC) || AC.hide_from_chargen)
			continue

		var/aspect_spent = 0
		for(var/decl/aspect/A in AC.aspects)

			if(A.type in pref.aspects)
				aspect_spent += A.aspect_cost

			if(aspect_category == selected_category && !A.parent && A.available_at_chargen)
				body += A.get_aspect_selection_data(src, pref.aspects)

		var/category_label = AC.name
		if(aspect_spent != 0)
			category_label = "[category_label] ([aspect_spent])"
		if(aspect_category == selected_category)
			category_label = "<font color = '#e67300'>[category_label]</font>"
		header += "<td><a href='?src=\ref[src];select_category=[AC.name]'>[category_label]</a></td>"

	. += "<table align = 'center'><tr>[header]</tr></table>"
	. += "<table align = 'center'>[body]</table>"

	return jointext(., null)

/datum/category_item/player_setup_item/aspects/OnTopic(href, href_list, user)
	. = ..()
	if(!.)

		if(href_list["select_category"])
			if(href_list["select_category"] in global.aspect_categories)
				selected_category = href_list["select_category"]
			else
				selected_category = global.aspect_categories[1]
			return TOPIC_REFRESH

		if(href_list["toggle_aspect"])
			var/decl/aspect/A = locate(href_list["toggle_aspect"])
			if(!istype(A))
				return TOPIC_NOACTION
			// Disable aspect (and children).
			if(A.type in pref.aspects)
				var/list/aspects_to_remove = list(A)
				while(aspects_to_remove.len)
					A = aspects_to_remove[1]
					aspects_to_remove -= A
					if(!(A.type in pref.aspects))
						continue
					pref.aspects -= A.type
					if(A.children)
						aspects_to_remove |= A.children
			// Enable aspect.
			else if(get_aspect_total() + A.aspect_cost <= get_config_value(/decl/config/num/max_character_aspects))
				pref.aspects |= A.type
			// Tidy up in case we're in an incoherent state for whatever reason.
			pref.prune_invalid_aspects()
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()
