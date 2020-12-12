/decl/codex_category/species/
	name = "Species"
	desc = "Sapient species encountered in known space."

/decl/codex_category/species/Initialize()
	for(var/thing in get_all_species())
		var/decl/species/species = get_species_by_key(thing)
		if(!species.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[species.name] (species)")
			entry.lore_text = species.codex_description
			entry.mechanics_text = species.ooc_codex_information
			SScodex.add_entry_by_string(entry.display_name, entry)
			SScodex.add_entry_by_string(species.name, entry)
			items += entry.display_name
	. = ..()
