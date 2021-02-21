/decl/codex_category/cultures
	name = "Factions and Culture"
	desc = "Prominent planets, cultures, factions and religions of known space."

/decl/codex_category/cultures/Initialize()
	var/list/all_cultural_info = decls_repository.get_decls_of_subtype(/decl/cultural_info)
	for(var/thing in all_cultural_info)
		var/decl/cultural_info/culture = all_cultural_info[thing]
		if(culture.name && !culture.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[culture.name] ([lowertext(culture.desc_type)])")
			entry.lore_text = culture.description
			SScodex.add_entry_by_string(culture.name, entry)
			items += culture.name
	. = ..()