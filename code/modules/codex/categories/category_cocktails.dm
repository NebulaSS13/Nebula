/decl/codex_category/cocktails
	name = "Cocktails"
	desc = "Various mixes of drinks, alcoholic and otherwise, that can be made by a skilled bartender."
	guide_name = "Bartending"

/decl/codex_category/cocktails/Populate()

	var/list/entries_to_register = list()
	var/list/cocktails = decls_repository.get_decls_of_subtype(/decl/cocktail)
	guide_html = "<h1>Mixology 101</h1><p>Here's a guide for mixing decent cocktails.</p>"
	for(var/ctype in cocktails)
		var/decl/cocktail/cocktail = cocktails[ctype]
		if(cocktail.hidden_from_codex)
			continue

		var/mechanics_text = "Cocktails will change the name of bartending glasses when mixed properly.<br><br>"
		mechanics_text += "This cocktail is mixed with the following ingredients:<br>"
		var/list/ingredients = list()
		for(var/rtype in cocktail.display_ratios)
			// Rather than normalising fractional values using the lowest
			// common divisor, we instead let cocktails use user-readable values
			// which we normalize internally for calculations.
			var/decl/material/mixer = GET_DECL(rtype)
			var/minimum_amount = cocktail.display_ratios[rtype]
			var/ingredient = "<span codexlink='[mixer.codex_name || mixer.name] (substance)'>[mixer.use_name]</span>"
			if(minimum_amount)
				ingredient = "[minimum_amount] part\s [ingredient]"
			else
				ingredient += " to taste"
			ingredients += ingredient

		guide_html += "<h3>[capitalize(cocktail.name)]</h3>Mix [english_list(ingredients)] in a glass."
		mechanics_text += "<ul><li>[jointext(ingredients, "</li><li>")]</li></ul>"

		entries_to_register += new /datum/codex_entry(         \
		 _display_name =       "[cocktail.name] (cocktail)",   \
		 _lore_text =          cocktail.description,           \
		 _mechanics_text =     mechanics_text,                 \
		)

	for(var/datum/codex_entry/entry in entries_to_register)
		items |= entry.name

	. = ..()