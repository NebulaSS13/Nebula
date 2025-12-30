/decl/codex_category/cultures
	name = "Places, Factions and Culture"
	desc = "Prominent planets, cultures, factions and religions of known space."

/decl/codex_category/cultures/Populate()
	var/list/all_background_info = decls_repository.get_decls_of_subtype(/decl/background_detail)
	for(var/thing in all_background_info)
		var/decl/background_detail/background = all_background_info[thing]
		var/decl/background_category/background_cat = GET_DECL(background.category)
		if(background.name && !background.hidden_from_codex)
			var/datum/codex_entry/entry = new(
				_display_name = "[background.name] ([lowertext(background_cat.name)])",
				_lore_text = background.description
			)
			items |= entry.name
	. = ..()
