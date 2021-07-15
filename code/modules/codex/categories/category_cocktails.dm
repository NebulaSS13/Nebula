/decl/codex_category/cocktails
	name = "Cocktails"
	desc = "Various mixes of drinks, alcoholic and otherwise, that can be made by a skilled bartender."
	guide_name = "Bartending"
	guide_strings = list("bartender", "cocktails", "bartending")

/decl/codex_category/cocktails/Initialize()

	var/list/entries_to_register = list()
	var/list/cocktails = decls_repository.get_decls_of_subtype(/decl/cocktail)
	guide_html = "<h1>Mixology 101</h1>Here's a guide for mixing decent cocktails."
	for(var/ctype in cocktails)
		var/decl/cocktail/cocktail = cocktails[ctype]
		if(cocktail.hidden_from_codex)
			continue

		var/mechanics_text = "Cocktails will change the name of bartending glasses when mixed properly.<br><br>"
		mechanics_text += "This cocktail is mixed with the following ingredients:<br>"        
		var/list/ingredients = list()
		for(var/rtype in cocktail.ratios)
			// If anyone can think of a good way to find the lowest common
			// divisor of these part values and make it a bit neater, please
			// feel free to change this block to use it.
			var/decl/material/mixer = GET_DECL(rtype) 
			var/ingredient = "[cocktail.ratios[rtype] >= 0.1 ? "[CEILING(cocktail.ratios[rtype] * 10)] part\s" : "a dash of"] [mixer.name]"
			ingredients += ingredient
		
		guide_html += "<h3>[capitalize(cocktail.name)]</h3>Mix [english_list(ingredients)] in a glass."
		mechanics_text += "<ul><li>[jointext(ingredients, "</li><li>")]</li></ul>"

		entries_to_register += new /datum/codex_entry(         \
		 _display_name =       "[cocktail.name] (cocktail)",   \
		 _associated_strings = list(lowertext(cocktail.name)), \
		 _lore_text =          cocktail.description,           \
		 _mechanics_text =     mechanics_text,                 \
		)

	for(var/datum/codex_entry/entry in entries_to_register)
		SScodex.add_entry_by_string(entry.name, entry)
		items |= entry.name

	. = ..()