/decl/codex_category/recipes
	name = "Recipes"
	desc = "Recipes for a variety of different kinds of foods and condiments."
	guide_name = "Cooking"
	guide_strings = list("chef", "cooking", "recipes")

/decl/codex_category/recipes/Initialize()

	var/list/entries_to_register = list()

	guide_html = {"
		<h1>Chef recipes</h1>
		Here is a guide on food recipes and also how to not poison your customers accidentally.

		<h3>Basics:</h3>
		<ul>
		<li>Mix an egg and some flour along with some water to make dough.</li>
		<li>Bake that to make a bun or flatten and cut it.</li>
		<li>Cut up a meat slab with a sharp knife to make cutlets.</li>
		<li>Mix flour and protein (ground meat) to make meatballs.</li>
		</ul>"}

	for(var/reactiontype in subtypesof(/datum/chemical_reaction/recipe))
		var/datum/chemical_reaction/recipe/food = SSmaterials.chemical_reactions[reactiontype]
		if(!food || !food.name || food.hidden_from_codex)
			continue

		var/mechanics_text
		var/lore_text
		var/product_name
		var/category_name
		if(istype(food, /datum/chemical_reaction/recipe/food))
			var/datum/chemical_reaction/recipe/food/food_ref = food
			var/obj/item/product = food_ref.obj_result
			if(!product)
				continue
			category_name = "mix recipe"
			product_name = initial(product.name)
			lore_text = initial(product.desc)
			mechanics_text = "This recipe produces \a [initial(product.name)].<br>It should be performed in a mixing bowl or beaker, and requires the following ingredients:"
		else
			var/decl/material/product = food.result
			if(!product)
				continue
			product_name = initial(product.name)
			lore_text = initial(product.lore_text)
			if(ispath(food.result, /decl/material/liquid/drink) || ispath(food.result, /decl/material/liquid/ethanol))
				category_name = "drink recipe"
				mechanics_text = "This recipe produces [food.result_amount]u [initial(product.name)].<br>It should be performed in a glass or shaker, and requires the following ingredients:"
			else
				category_name = "condiment recipe"
				mechanics_text = "This recipe produces [food.result_amount]u [initial(product.name)].<br>It should be performed in a mixing bowl or beaker, and requires the following ingredients:"

		var/list/reactant_values = list()
		for(var/reactant_id in food.required_reagents)
			var/decl/material/reactant = reactant_id
			reactant_values += "[food.required_reagents[reactant_id]]u [lowertext(initial(reactant.name))]"
		mechanics_text += " [jointext(reactant_values, " + ")]"
		var/list/catalysts = list()
		for(var/catalyst_id in food.catalysts)
			var/decl/material/catalyst = catalyst_id
			catalysts += "[food.catalysts[catalyst_id]]u [lowertext(initial(catalyst.name))]"
		if(catalysts.len)
			mechanics_text += " [jointext(reactant_values, " + ")] (catalysts: [jointext(catalysts, ", ")])]"
		if(food.maximum_temperature != INFINITY)
			mechanics_text += "<br>The recipe will not succeed if the temperature is above [food.maximum_temperature]K."
		if(food.minimum_temperature > 0)
			mechanics_text += "<br>The recipe will not succeed if the temperature is below [food.minimum_temperature]K."

		entries_to_register += new /datum/codex_entry(                     \
		 _display_name =       "[lowertext(food.name)] ([category_name])", \
		 _associated_strings = list(                                       \
		 	lowertext(food.name),                                          \
			lowertext(product_name)),                                      \
		 _lore_text =          lore_text,                                  \
		 _mechanics_text =     mechanics_text,                             \
		)

	var/list/all_recipes = decls_repository.get_decls_of_subtype(/decl/recipe)
	for(var/rtype in all_recipes)
		var/decl/recipe/recipe = all_recipes[rtype]
		if(!istype(recipe) || recipe.hidden_from_codex || !recipe.result)
			continue

		var/mechanics_text = ""
		if(recipe.mechanics_text)
			mechanics_text = "[recipe.mechanics_text]<br><br>"
		mechanics_text += "This recipe requires the following ingredients:<br>"
		var/list/ingredients = list()
		for(var/thing in recipe.reagents)
			var/decl/material/thing_reagent = thing
			ingredients += "[recipe.reagents[thing]]u [initial(thing_reagent.name)]"
		for(var/thing in recipe.items)
			var/atom/thing_atom = thing
			ingredients += "\a [initial(thing_atom.name)]"
		for(var/thing in recipe.fruit)
			ingredients += "[recipe.fruit[thing]] [thing]\s"
		mechanics_text += "<ul><li>[jointext(ingredients, "</li><li>")]</li></ul>"
		var/atom/recipe_product = recipe.result
		mechanics_text += "<br>This recipe takes [CEILING(recipe.time/10)] second\s to cook in a microwave and creates \a [initial(recipe_product.name)]."
		var/lore_text = recipe.lore_text
		if(!lore_text)
			lore_text = initial(recipe_product.desc)

		var/recipe_name = recipe.display_name || sanitize(initial(recipe_product.name))
		guide_html += "<h3>[capitalize(recipe_name)]</h3>Place [english_list(ingredients)] into a microwave for [CEILING(recipe.time/10)] second\s."

		entries_to_register += new /datum/codex_entry(             \
		 _display_name =       "[recipe_name] (microwave recipe)", \
		 _associated_strings = list(lowertext(recipe_name)),       \
		 _lore_text =          lore_text,                          \
		 _mechanics_text =     mechanics_text,                     \
		 _antag_text =         recipe.antag_text                   \
		)

	for(var/datum/codex_entry/entry in entries_to_register)
		SScodex.add_entry_by_string(entry.name, entry)
		items |= entry.name

	. = ..()