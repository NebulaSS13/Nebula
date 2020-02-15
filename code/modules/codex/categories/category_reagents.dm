/datum/codex_category/reagents
	name = "Reagents"
	desc = "Chemicals and reagents, both natural and artificial."

/datum/codex_category/reagents/Initialize()

	var/list/entries_to_register = list()
	for(var/reactiontype in subtypesof(/datum/chemical_reaction/grenade_reaction))
		var/datum/chemical_reaction/grenade_reaction/boom = SSchemistry.chemical_reactions[reactiontype]
		if(!boom || !boom.name || boom.hidden_from_codex)
			continue
		var/mechanics_text = "It can be caused with the following reagents:"
		if(boom.mechanics_text)
			mechanics_text = "[boom.mechanics_text]<br>[mechanics_text]"
		var/list/reactant_values = list()
		for(var/reactant_id in boom.required_reagents)
			var/datum/reagent/reactant = reactant_id
			reactant_values += "[boom.required_reagents[reactant_id]]u [lowertext(initial(reactant.name))]"
		mechanics_text += " [jointext(reactant_values, " + ")]"
		var/list/catalysts = list()
		for(var/catalyst_id in boom.catalysts)
			var/datum/reagent/catalyst = catalyst_id
			catalysts += "[boom.catalysts[catalyst_id]]u [lowertext(initial(catalyst.name))]"
		if(catalysts.len)
			mechanics_text += " [jointext(reactant_values, " + ")] (catalysts: [jointext(catalysts, ", ")])]"
		if(boom.maximum_temperature != INFINITY)
			mechanics_text += "<br>The reaction will not occur if the temperature is above [boom.maximum_temperature]K."
		if(boom.minimum_temperature > 0)
			mechanics_text += "<br>The reaction will not occur if the temperature is below [boom.minimum_temperature]K."

		entries_to_register += new /datum/codex_entry(              \
		 _display_name =       "[lowertext(boom.name)] (reaction)", \
		 _associated_strings = list(lowertext(boom.name)),          \
		 _lore_text =          boom.lore_text,                      \
		 _mechanics_text =     mechanics_text                       \
		)

	for(var/thing in subtypesof(/datum/reagent))
		var/datum/reagent/reagent = thing
		if(!initial(reagent.name) || initial(reagent.hidden_from_codex))
			continue
		var/chem_name = lowertext(initial(reagent.name))
		var/new_lore_text = initial(reagent.description) 
		if(initial(reagent.taste_description))
			new_lore_text = "[new_lore_text] It apparently tastes of [initial(reagent.taste_description)]."
		var/datum/codex_entry/entry = new(               \
		 _display_name = "[chem_name] (chemical)",       \
		 _associated_strings = list("[chem_name] pill"), \
		 _lore_text = new_lore_text)

		var/list/production_strings = list()
		for(var/react in SSchemistry.chemical_reactions_by_result[thing])

			var/datum/chemical_reaction/reaction = react

			if(!reaction.name || reaction.hidden_from_codex)
				continue

			var/list/reactant_values = list()
			for(var/reactant_id in reaction.required_reagents)
				var/datum/reagent/reactant = reactant_id
				reactant_values += "[reaction.required_reagents[reactant_id]]u [lowertext(initial(reactant.name))]"

			if(!reactant_values.len)
				continue

			var/list/catalysts = list()
			for(var/catalyst_id in reaction.catalysts)
				var/datum/reagent/catalyst = catalyst_id
				catalysts += "[reaction.catalysts[catalyst_id]]u [lowertext(initial(catalyst.name))]"

			var/datum/reagent/result = reaction.result
			if(catalysts.len)
				production_strings += "- [jointext(reactant_values, " + ")] (catalysts: [jointext(catalysts, ", ")]): [reaction.result_amount]u [lowertext(initial(result.name))]"
			else
				production_strings += "- [jointext(reactant_values, " + ")]: [reaction.result_amount]u [lowertext(initial(result.name))]"

		if(production_strings.len)
			if(!entry.mechanics_text)
				entry.mechanics_text = "It can be produced as follows:<br>"
			else
				entry.mechanics_text += "<br><br>It can be produced as follows:<br>"
			entry.mechanics_text += jointext(production_strings, "<br>")
		entries_to_register += entry

	for(var/datum/codex_entry/entry in entries_to_register)
		entry.update_links()
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name

	..()