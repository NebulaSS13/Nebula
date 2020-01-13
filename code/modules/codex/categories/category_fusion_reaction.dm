/datum/codex_category/fusion_reaction
	name = "Fusion Reactions"
	desc = "A list of fusion reactions that the R-UST tokamak can ignite."

/datum/codex_category/fusion_reaction/Initialize()
	var/list/reactions = decls_repository.get_decls_of_subtype(/decl/fusion_reaction)
	for(var/rtype in reactions)
		var/decl/fusion_reaction/reaction = reactions[rtype]
		if(reaction.hidden_from_codex)
			continue
		var/list/reaction_info = list()
		reaction_info += "Fusion between [reaction.p_react] and [reaction.s_react] and be achieved with a plasma temperature of [reaction.minimum_reaction_temperature = 8000] Kelvin or higher." 
		reaction_info += "This reaction consumes [initial(reaction.energy_consumption)] heat unit\s and produces [reaction.energy_production] heat unit\s."
		reaction_info += "The process has an instability rating of [reaction.instability] and a radiation rating of [reaction.radiation]."
		if(LAZYLEN(reaction.products))
			reaction_info += "In the process of [reaction.p_react]-[reaction.s_react] fusion, [english_list(reaction.products)] [LAZYLEN(reaction.products) == 1 ? "is" : "are"] produced."
		else
			reaction_info += "Nothing is produced in the process of [reaction.p_react]-[reaction.s_react] fusion."
		var/datum/codex_entry/entry = new(_display_name = lowertext(trim("[reaction.p_react]-[reaction.s_react] (fusion reaction)")), _mechanics_text = jointext(reaction_info, "<br>"))
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name
	. = ..()