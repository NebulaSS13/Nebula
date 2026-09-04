/decl/codex_category/recipes
	name = "Recipes"
	desc = "Recipes for a variety of different kinds of foods and condiments."
	guide_name = "Cooking"

/decl/codex_category/recipes/Populate()

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

	var/list/all_recipe_reactions = decls_repository.get_decls_of_subtype(/decl/chemical_reaction/recipe)
	for(var/reactiontype in all_recipe_reactions)
		var/decl/chemical_reaction/recipe/food = all_recipe_reactions[reactiontype]
		if(!food || !food.name || food.hidden_from_codex)
			continue
		var/mechanics_text
		var/lore_text
		var/category_name
		if(istype(food, /decl/chemical_reaction/recipe/food))
			var/decl/chemical_reaction/recipe/food/food_ref = food
			var/obj/item/product = food_ref.obj_result
			if(!product)
				continue
			category_name = "mix recipe"
			var/product_name = initial(product.name)
			if(ispath(product, /atom/movable) && TYPE_IS_SPAWNABLE(product))
				product_name = atom_info_repository.get_name_for(product)
				lore_text = atom_info_repository.get_description_for(product)
			else
				lore_text = initial(product.desc)
			mechanics_text = "This recipe produces \a [product_name].<br>It should be performed in a mixing bowl or beaker, and requires the following ingredients:"
		else
			var/decl/material/product = GET_DECL(food.result)
			if(!product)
				continue
			lore_text = product.lore_text
			if(ispath(food.result, /decl/material/liquid/drink) || ispath(food.result, /decl/material/liquid/alcohol))
				category_name = "drink recipe"
				mechanics_text = "This recipe produces [food.result_amount]u <span codexlink='[product.codex_name || product.name] (substance)'>[product.name]</span>.<br>It should be performed in a glass or shaker, and requires the following ingredients:"
			else
				category_name = "condiment recipe"
				mechanics_text = "This recipe produces [food.result_amount]u <span codexlink='[product.codex_name || product.name] (substance)'>[product.name]</span>.<br>It should be performed in a mixing bowl or beaker, and requires the following ingredients:"

		var/list/reactant_values = list()
		for(var/reactant_id in food.required_reagents)
			var/decl/material/reactant = GET_DECL(reactant_id)
			reactant_values += "[food.required_reagents[reactant_id]]u <span codexlink='[reactant.codex_name || reactant.name] (substance)'>[reactant.name]</span>"
		mechanics_text += " [jointext(reactant_values, " + ")]"
		var/list/catalysts = list()
		for(var/catalyst_id in food.catalysts)
			var/decl/material/catalyst = GET_DECL(catalyst_id)
			catalysts += "[food.catalysts[catalyst_id]]u <span codexlink='[catalyst.codex_name || catalyst.name] (substance)'>[catalyst.name]</span>"
		if(catalysts.len)
			mechanics_text += " (catalysts: [jointext(catalysts, ", ")])]"
		if(food.maximum_temperature != INFINITY)
			mechanics_text += "<br>The recipe will not succeed if the temperature is above [food.maximum_temperature]K."
		if(food.minimum_temperature > 0)
			mechanics_text += "<br>The recipe will not succeed if the temperature is below [food.minimum_temperature]K."

		entries_to_register += new /datum/codex_entry(                  \
		 _display_name =       "[food.name] ([category_name])",         \
		 _associated_strings = list("[food.name] (chemical reaction)"), \
		 _lore_text =          lore_text,                               \
		 _mechanics_text =     mechanics_text,                          \
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
			var/decl/material/thing_reagent = GET_DECL(thing)
			ingredients += "[recipe.reagents[thing]]u <span codexlink='[thing_reagent.codex_name || thing_reagent.name] (substance)'>[thing_reagent.name]</span>"
		for(var/atom/thing as anything in recipe.items)
			var/count = recipe.items[thing]
			var/thing_name = initial(thing.name)
			if(ispath(thing, /atom/movable) && TYPE_IS_SPAWNABLE(thing))
				thing_name = atom_info_repository.get_name_for(thing)
			if(SScodex.get_entry_by_string(thing_name))
				thing_name = "<l>[thing_name]</l>"
			else
				var/datum/codex_entry/result_entry = SScodex.get_codex_entry(thing)
				if(result_entry)
					thing_name = "<span codexlink='[result_entry.name]'>[thing_name]</span>"
			ingredients += (count > 1) ? "[count]x [thing_name]" : "\a [thing_name]"
		for(var/thing in recipe.fruit)
			ingredients += "[recipe.fruit[thing]] [thing]\s"
		mechanics_text += "<ul><li>[jointext(ingredients, "</li><li>")]</li></ul>"

		var/list/cooking_methods = list()
		for(var/cooking_method in recipe.container_categories)
			cooking_methods += "\a [cooking_method]"

		var/atom/recipe_product = recipe.result
		var/product_name
		var/product_link
		var/lore_text = recipe.lore_text
		if(ispath(recipe_product, /atom/movable) && TYPE_IS_SPAWNABLE(recipe_product))
			product_name = atom_info_repository.get_name_for(recipe_product)
			lore_text ||= atom_info_repository.get_description_for(recipe_product)
		else if(ispath(recipe.result, /decl/material))
			var/decl/material/result_reagent = GET_DECL(recipe.result)
			product_name = result_reagent.use_name
			product_link = "some <span codexlink='[result_reagent.codex_name || result_reagent.name] (substance)'>[product_name]</span>"
			lore_text ||= result_reagent.lore_text
		else // some things can't be spawned by the atom info repository because they need extra args we can't pass
			product_name = initial(recipe_product.name)
			lore_text ||= initial(recipe_product.desc)
		product_link ||= "\a [product_name]"
		mechanics_text += "<br>This recipe takes [ceil(recipe.cooking_time/(1 SECOND))] second\s to cook in [english_list(cooking_methods, and_text = " or ")] and creates [product_link]."

		var/recipe_name = recipe.display_name || sanitize(product_name)
		guide_html += "<h3>[capitalize(recipe_name)]</h3>Cook [english_list(ingredients)] for [ceil(recipe.cooking_time/(1 SECOND))] second\s."

		entries_to_register += new /datum/codex_entry(           \
		 _display_name =       "[recipe_name] (cooking recipe)", \
		 _lore_text =          lore_text,                        \
		 _mechanics_text =     mechanics_text,                   \
		 _antag_text =         recipe.antag_text                 \
		)

	for(var/datum/codex_entry/entry in entries_to_register)
		items |= entry.name

	. = ..()