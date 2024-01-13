/decl/codex_category/materials
	abstract_type = /decl/codex_category/materials
	var/reaction_category

/decl/codex_category/materials/Populate()

	guide_html = guide_html + {"
	<h3>Reactions</h3>
		<table border = '1px'>
		<tr><th><b>Product name</b></th><th><b>Product amount</b></th><th><b>Required reagents</b></th><th><b>Catalysts</b></th><th><b>Inhibitors</b></th><th><b>Min temperature</b></th><th><b>Max temperature</b></th><th><b>Notes</b></th></tr>
	"}

	var/list/entries_to_register = list()
	var/list/all_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)
	for(var/reactiontype in all_reactions)
		var/decl/chemical_reaction/reaction = all_reactions[reactiontype]
		if(!reaction || !reaction.name || reaction.hidden_from_codex || istype(reaction, /decl/chemical_reaction/recipe) || reaction.reaction_category != reaction_category)
			continue // Food recipes are handled in category_recipes.dm.
		var/mechanics_text = "This reaction requires the following reagents:<br>"
		if(reaction.mechanics_text)
			mechanics_text = "[reaction.mechanics_text]<br>[mechanics_text]"
		var/list/reactant_values = list()
		for(var/reactant_id in reaction.required_reagents)
			var/decl/material/reactant = GET_DECL(reactant_id)
			var/reactant_name = "<span codexlink='[reactant.codex_name || reactant.name] (substance)'>[reactant.name]</span>"
			reactant_values += "[reaction.required_reagents[reactant_id]]u [reactant_name]"
		mechanics_text += " [jointext(reactant_values, " + ")]"
		var/list/inhibitors = list()

		for(var/inhibitor_id in reaction.inhibitors)
			var/decl/material/inhibitor = GET_DECL(inhibitor_id)
			var/inhibitor_name = "<span codexlink='[inhibitor.codex_name || inhibitor.name] (substance)'>[inhibitor.name]</span>"
			inhibitors += inhibitor_name
		if(length(inhibitors))
			mechanics_text += " (inhibitors: [jointext(inhibitors, ", ")])"

		var/list/catalysts = list()
		for(var/catalyst_id in reaction.catalysts)
			var/decl/material/catalyst = GET_DECL(catalyst_id)
			var/catalyst_name = "<span codexlink='[catalyst.codex_name || catalyst.name] (substance)'>[catalyst.name]</span>"
			catalysts += "[reaction.catalysts[catalyst_id]]u [catalyst_name]"
		if(length(catalysts))
			mechanics_text += " (catalysts: [jointext(catalysts, ", ")])"

		var/produces
		if(reaction.result && reaction.result_amount)
			var/decl/material/product = GET_DECL(reaction.result)
			produces = product.codex_name || product.name
			mechanics_text += "<br>It will produce [reaction.result_amount]u <span codexlink='[product.codex_name || product.name] (substance)'>[product.name]</span>."
		if(reaction.maximum_temperature != INFINITY)
			mechanics_text += "<br>The reaction will not occur if the temperature is above [reaction.maximum_temperature]K."
		if(reaction.minimum_temperature > 0)
			mechanics_text += "<br>The reaction will not occur if the temperature is below [reaction.minimum_temperature]K."

		var/reaction_name = produces || lowertext(reaction.name)
		if(produces)
			guide_html += "<tr><td><span codexlink='[produces] (substance)'>[capitalize(reaction_name)]</span></td>"
		else
			guide_html += "<tr><td><span codexlink='[reaction_name] (reaction)'>[capitalize(reaction_name)]</span></td>"
		guide_html += "<td>[reaction.result_amount || "N/A"]</td>"
		guide_html += "<td>[jointext(reactant_values, "<br>")]</td>"
		if(length(catalysts))
			guide_html += "<td>[jointext(catalysts, "<br>")]</td>"
		else
			guide_html += "<td>No catalysts.</td>"
		if(length(inhibitors))
			guide_html += "<td>[jointext(inhibitors, "<br>")]</td>"
		else
			guide_html += "<td>No inhibitors.</td>"
		if(reaction.minimum_temperature > 0 && reaction.minimum_temperature < INFINITY)
			guide_html += "<td>[reaction.minimum_temperature]K</td>"
		else
			guide_html += "<td>Any</td>"
		if(reaction.maximum_temperature > 0 && reaction.maximum_temperature < INFINITY)
			guide_html += "<td>[reaction.maximum_temperature]K</td>"
		else
			guide_html += "<td>Any</td>"
		guide_html += "<td>"
		if(reaction.mechanics_text)
			guide_html += reaction.mechanics_text
			if(reaction.lore_text)
				guide_html += "<br>"
		if(reaction.lore_text)
			guide_html += reaction.lore_text
		guide_html += "</td></tr>"

		entries_to_register += new /datum/codex_entry(                      \
		 _display_name =       "[reaction.name] (reaction)",                \
		 _associated_strings = list("[reaction.name] (chemical reaction)"), \
		 _lore_text =          reaction.lore_text,                          \
		 _mechanics_text =     mechanics_text                               \
		)
	guide_html += "</table>"

	for(var/datum/codex_entry/entry in entries_to_register)
		items |= entry.name

	..()
