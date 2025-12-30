/decl/codex_category/phenomena
	name = "Phenomena"
	desc = "Rumoured esoteric effects, fringe pseudoscience, and the kind of nonsense our field researchers submit at 4:55 on a Friday before heading to the pub."

/decl/codex_category/phenomena/Populate()

	var/list/abilities = list()
	for(var/decl/ability/ability in decls_repository.get_decls_of_subtype_unassociated(/decl/ability))
		if(ability.hidden_from_codex || !ability.is_supernatural || !ability.desc)
			continue
		abilities["[ability.name] (phenomena)"] = ability.desc

	for(var/ability in abilities)
		var/datum/codex_entry/entry = new(
			_display_name = ability,
			_antag_text = abilities[ability]
		)
		items |= entry.name
	. = ..()
