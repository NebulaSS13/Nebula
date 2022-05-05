/decl/codex_category/phenomena
	name = "Phenomena"
	desc = "Rumoured esoteric effects, fringe pseudoscience, and the kind of nonsense our field researchers submit at 4:55 on a Friday before heading to the pub."

/decl/codex_category/phenomena/Initialize()
	for(var/thing in subtypesof(/spell))
		var/spell/spell = thing
		if(!initial(spell.hidden_from_codex) && initial(spell.desc))
			var/datum/codex_entry/entry = new(_display_name = "[initial(spell.name)] (phenomena)")
			entry.antag_text = initial(spell.desc)
			SScodex.add_entry_by_string(entry.name, entry)
			items |= entry.name
	. = ..()
