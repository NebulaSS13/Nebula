/decl/codex_category/phenomena
	name = "Phenomena"
	desc = "Rumoured esoteric effects, fringe pseudoscience, and the kind of nonsense our field researchers submit at 4:55 on a Friday before heading to the pub."

/decl/codex_category/phenomena/Populate()

	// This needs duplicate checking but I resent even having to spend time on spellcode.
	var/list/spells = list()
	for(var/thing in subtypesof(/spell))
		var/spell/spell = thing
		if(!initial(spell.hidden_from_codex) && initial(spell.desc) && initial(spell.name))
			spells["[initial(spell.name)] (phenomena)"] = initial(spell.desc)
	for(var/spell in spells)
		var/datum/codex_entry/entry = new(
			_display_name = spell,
			_antag_text = spells[spell]
		)
		items |= entry.name
	. = ..()
