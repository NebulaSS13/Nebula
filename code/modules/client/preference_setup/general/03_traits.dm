/datum/preferences
	var/list/traits = list()

/datum/preferences/proc/prune_invalid_traits()
	var/removed_something = TRUE
	while(removed_something && length(traits))
		removed_something = FALSE
		for(var/trait_type in traits)
			var/decl/trait/trait = GET_DECL(trait_type)
			if(!istype(trait) || !trait.is_available_to(src) || (trait.parent && !(trait.parent.type in traits)))
				traits -= trait_type
				removed_something = TRUE
			else if(length(trait.incompatible_with))
				for(var/incompatible_trait in trait.incompatible_with)
					if(incompatible_trait in traits)
						traits -= incompatible_trait
						removed_something = TRUE

/datum/category_item/player_setup_item/traits
	name = "Traits"
	sort_order = 1
	var/selected_category

/datum/category_item/player_setup_item/traits/load_character(datum/pref_record_reader/R)
	pref.traits = R.read("aspects") | R.read("traits") // Grandfather in old aspect settings.
	for(var/trait_id in pref.traits)
		if(ispath(trait_id, /decl/trait))
			continue
		pref.traits -= trait_id
		var/decl/trait/trait = decls_repository.get_decl_by_id_or_var(trait_id, /decl/trait)
		if(istype(trait))
			pref.traits |= trait.type

/datum/category_item/player_setup_item/traits/save_character(datum/pref_record_writer/W)
	var/list/trait_names = list()
	for(var/trait_id in pref.traits)
		var/decl/trait/trait_decl = GET_DECL(trait_id)
		if(istype(trait_decl))
			trait_names |= trait_decl.uid
	W.write("traits", trait_names)

/datum/category_item/player_setup_item/traits/proc/get_trait_total()
	var/trait_cost = 0
	for(var/trait_type in pref.traits)
		var/decl/trait/trait = GET_DECL(trait_type)
		if(!trait)
			return null
		trait_cost += trait.trait_cost
	return trait_cost

/datum/category_item/player_setup_item/traits/finalize_character()
	pref.prune_invalid_traits()

/datum/category_item/player_setup_item/traits/sanitize_character()

	if(!pref.traits)
		pref.traits = list()

	pref.prune_invalid_traits()

	var/modified_list = FALSE
	var/max_character_traits = get_config_value(/decl/config/num/max_character_traits)
	while(get_trait_total() > max_character_traits)

		// Find a costly trait with no children to drop until our cost is below the threshold.
		var/can_drop_trait = FALSE
		for(var/trait_type in pref.traits)

			var/decl/trait/trait = GET_DECL(trait_type)
			if(trait.trait_cost <= 0)
				continue

			can_drop_trait = TRUE
			for(var/decl/trait/child in trait.children)
				if(child.type in pref.traits)
					can_drop_trait = FALSE
					break

			if(can_drop_trait)
				pref.traits -= trait_type
				modified_list = TRUE
				break

		if(!can_drop_trait)
			break

	if(modified_list)
		pref.prune_invalid_traits()

/datum/category_item/player_setup_item/traits/content()

	var/list/available_categories = list()
	for(var/trait_category_id in global.trait_categories)
		var/datum/trait_category/trait_category = global.trait_categories[trait_category_id]
		if(trait_category.hide_from_chargen)
			continue
		for(var/decl/trait/trait as anything in trait_category.items)
			if(trait.is_available_to(pref))
				available_categories[trait_category.name] = trait_category
				break
	if(!length(available_categories))
		return

	var/trait_total = get_trait_total()
	// Change our formatting data if needed.
	var/fcolor =  COLOR_CYAN_BLUE
	var/max_character_traits = get_config_value(/decl/config/num/max_character_traits)
	if(trait_total == max_character_traits)
		fcolor = COLOR_FONT_ORANGE

	// Build the string.
	. = list("<center><b><font color = '[fcolor]'>[trait_total]/[max_character_traits]</font> points spent.</b></center><br/>")
	if(!selected_category || !(selected_category in available_categories))
		selected_category = available_categories[1]

	var/header = ""
	var/body = ""
	for(var/trait_category_id in available_categories)

		var/datum/trait_category/trait_category = available_categories[trait_category_id]
		if(!istype(trait_category) || trait_category.hide_from_chargen)
			continue

		var/trait_spent = 0
		for(var/decl/trait/trait in trait_category.items)

			if(trait.type in pref.traits)
				trait_spent += trait.trait_cost

			if(trait_category_id == selected_category && !trait.parent && trait.is_available_at_chargen())
				body += trait.get_trait_selection_data(src, pref.traits)

		var/category_label = trait_category.name
		if(trait_spent != 0)
			category_label = "[category_label] ([trait_spent])"
		if(trait_category_id == selected_category)
			category_label = "<font color = '#e67300'>[category_label]</font>"
		header += "<td><a href='byond://?src=\ref[src];select_category=[trait_category.name]'>[category_label]</a></td>"

	. += "<table align = 'center'><tr>[header]</tr></table>"
	. += "<table align = 'center'>[body]</table>"

	return jointext(., null)

/datum/category_item/player_setup_item/traits/OnTopic(href, href_list, user)
	. = ..()
	if(!.)

		if(href_list["select_category"])
			if(href_list["select_category"] in global.trait_categories)
				selected_category = href_list["select_category"]
			else
				selected_category = global.trait_categories[1]
			return TOPIC_REFRESH

		if(href_list["toggle_trait"])
			var/decl/trait/trait = locate(href_list["toggle_trait"])
			if(!istype(trait))
				return TOPIC_NOACTION
			// Disable trait (and children).
			if(trait.type in pref.traits)
				var/list/traits_to_remove = list(trait)
				while(traits_to_remove.len)
					trait = traits_to_remove[1]
					traits_to_remove -= trait
					if(!(trait.type in pref.traits))
						continue
					pref.traits -= trait.type
					if(trait.children)
						traits_to_remove |= trait.children
			// Enable trait.
			else if(get_trait_total() + trait.trait_cost <= get_config_value(/decl/config/num/max_character_traits))
				pref.traits |= trait.type
			// Tidy up in case we're in an incoherent state for whatever reason.
			pref.prune_invalid_traits()
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()
