/decl/codex_category/reactions
	name = "Reactions"
	desc = "Chemical reactions with mundane, interesting or spectacular effects."
	guide_name = "Chemistry"
	guide_strings = list("chemist", "reactions")

/decl/codex_category/reactions/Initialize()

	guide_html = {"
		<h1>Chemistry Basics</h1>
		<p>
		Some basic tips for being an effective chemist:
		<ul>
		<li>Use a dropper for precise reagent measurements.</li>
		<li>Grind solid sheets of materials, pills, or other reagent-bearing objects in the grinder to convert them into a usable form.</li>
		<li>Some materials must be dissolved with a solvent before they are useful in chemistry.</li>
		<li>Some reactions need a minimum temperature to occur; use a reagent heater, or in a pinch, a lighter or welding torch.</li>
		<li>Chem grenades make use of a variety of reactions that produce effects like smoke or foam rather than a new chemical.</li>
		</ul>
		</p>
		<h3>Reactions</h3>
		<table border = '1px'>
		<tr><td><b>Product name</b></td><td><b>Product amount</b></td><td><b>Required reagents</b></td><td><b>Catalysts</b></td><td><b>Inhibitors</b></td><td><b>Min temperature</b></td><td><b>Max temperature</b></td><td><b>Notes</b></td></tr>"}

	var/list/entries_to_register = list()
	for(var/reactiontype in SSmaterials.chemical_reactions)
		var/datum/chemical_reaction/reaction = SSmaterials.chemical_reactions[reactiontype]
		if(!reaction || !reaction.name || reaction.hidden_from_codex || istype(reaction, /datum/chemical_reaction/recipe))
			continue // Food recipes are handled in category_recipes.dm.
		var/mechanics_text = "This reaction requires the following reagents:<br>"
		if(reaction.mechanics_text)
			mechanics_text = "[reaction.mechanics_text]<br>[mechanics_text]"
		var/list/reactant_values = list()
		for(var/reactant_id in reaction.required_reagents)
			var/decl/material/reactant = GET_DECL(reactant_id)
			var/reactant_name = "<span codexlink='[reactant.name] (substance)'>[reactant.name]</span>"
			reactant_values += "[reaction.required_reagents[reactant_id]]u [reactant_name]"
		mechanics_text += " [jointext(reactant_values, " + ")]"
		var/list/inhibitors = list()

		for(var/inhibitor_id in reaction.inhibitors)
			var/decl/material/inhibitor = GET_DECL(inhibitor_id)
			var/inhibitor_name = "<span codexlink='[inhibitor.name] (substance)'>[inhibitor.name]</span>"
			inhibitors += inhibitor_name
		if(length(inhibitors))
			mechanics_text += " (inhibitors: [jointext(inhibitors, ", ")])"

		var/list/catalysts = list()
		for(var/catalyst_id in reaction.catalysts)
			var/decl/material/catalyst = GET_DECL(catalyst_id)
			var/catalyst_name = "<span codexlink='[catalyst.name] (substance)'>[catalyst.name]</span>"
			catalysts += "[reaction.catalysts[catalyst_id]]u [catalyst_name]"
		if(length(catalysts))
			mechanics_text += " (catalysts: [jointext(catalysts, ", ")])"

		var/produces
		if(reaction.result && reaction.result_amount)
			var/decl/material/product = GET_DECL(reaction.result)
			produces = product.name
			mechanics_text += "<br>It will produce [reaction.result_amount]u [produces]."
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

		entries_to_register += new /datum/codex_entry(                                   \
		 _display_name =       "[reaction_name] (reaction)",                             \
		 _associated_strings = list(lowertext(reaction.name), lowertext(reaction_name)), \
		 _lore_text =          reaction.lore_text,                                       \
		 _mechanics_text =     mechanics_text                                            \
		)
	guide_html += "</table>"

	for(var/datum/codex_entry/entry in entries_to_register)
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name

	. = ..()