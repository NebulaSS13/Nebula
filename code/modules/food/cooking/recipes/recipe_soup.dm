/*
  Soups to readd when we have ingredients:
	- Dashi stock (dried seaweed, fish flakes).
	- Miso soup (miso paste, tofu and veg in dashi stock).
	- Proper chicken katsu (crumbed chicken object added to curry).
	- Curry on rice.
  Soups to add when someone can be bothered:
	- Egg drop soup: regular soup + 3u egg, uses egg overlay.
	- Proper curry spices, coconut milk, for curry making.
	- Cheese soups - will need ALLERGEN_CHEESE to be checked alongside ALLERGEN_DAIRY.
*/

/decl/recipe/soup
	abstract_type = /decl/recipe/soup
	reagent_mix = REAGENT_REPLACE
	container_categories = list(RECIPE_CATEGORY_POT)
	minimum_temperature = 100 CELSIUS
	result_quantity = 10
	can_bulk_cook = TRUE
	var/precursor_type

/decl/recipe/soup/get_result_data(atom/container, list/used_ingredients)

	. = list()
	var/allergen_flags = ALLERGEN_NONE
	var/list/taste_strings = list()
	var/list/ingredients = list()
	var/list/used_items = used_ingredients["items"]

	if(length(used_items))

		for(var/obj/item/ingredient in used_items)
			var/obj/item/food/food = ingredient
			var/list/food_tastes = food.reagents.get_taste_list()
			if(istype(food))
				for(var/taste in food_tastes)
					taste_strings[taste] = max(taste_strings[taste], food_tastes[taste])
				allergen_flags |= food.allergen_flags

		if(locate(/obj/item/food/grown) in used_items)
			for(var/obj/item/food/grown/veg in used_items)
				if(veg.seed)
					ingredients[veg.seed.product_name]++

		if(locate(/obj/item/food/processed_grown) in used_items)
			for(var/obj/item/food/processed_grown/veg in used_items)
				if(veg.seed)
					ingredients[veg.seed.product_name]++

		if(locate(/obj/item/food/butchery) in used_items)
			for(var/obj/item/food/butchery/meat in used_items)
				if(meat.meat_name)
					ingredients[meat.meat_name]++

	if(precursor_type)
		var/list/precursor_data = LAZYACCESS(container.reagents?.reagent_data, precursor_type)
		var/list/precursor_taste = LAZYACCESS(precursor_data, DATA_TASTE)
		if(length(precursor_taste))
			for(var/taste in precursor_taste)
				taste_strings[taste] += precursor_taste[taste]
		var/list/precursor_ingredients = LAZYACCESS(precursor_data, DATA_INGREDIENT_LIST)
		if(length(precursor_ingredients))
			for(var/ingredient in precursor_ingredients)
				ingredients[ingredient] += precursor_ingredients[ingredient]
		var/precursor_allergen_flags = LAZYACCESS(precursor_data, DATA_ALLERGENS)
		if(precursor_allergen_flags)
			allergen_flags |= precursor_allergen_flags

	if(length(taste_strings))
		.[DATA_TASTE] = taste_strings
	if(length(ingredients))
		.[DATA_INGREDIENT_LIST] = ingredients
	if(allergen_flags)
		.[DATA_ALLERGENS] = allergen_flags

/decl/recipe/soup/stock
	abstract_type = /decl/recipe/soup/stock
	result_quantity = 10
	result = /decl/material/liquid/nutriment/soup/stock
	reagents = list(
		/decl/material/solid/sodiumchloride = 1,
		/decl/material/liquid/water = 10
	)
	minimum_temperature = 100 CELSIUS
	complexity = 10 // Setting high by default so it takes priority over simple soup.

/decl/recipe/soup/stock/meat
	display_name = "meat stock"
	items = list(/obj/item/food/butchery)
	completion_message = "The liquid darkens to a rich brown as the meat dissolves."

/decl/recipe/soup/stock/vegetable
	display_name = "vegetable stock"
	items = list(/obj/item/food/grown)
	completion_message = "The liquid darkens to a rich brown as the vegetables dissolve."

/decl/recipe/soup/stock/bone
	display_name = "bone broth"
	items = list(/obj/item/stack/material/bone = 1)
	completion_message = "The liquid darkens to a rich brown as the marrow dissolves."

/decl/recipe/soup/stock/bone/get_result_data(atom/container, list/used_ingredients)
	. = list()
	.[DATA_INGREDIENT_LIST] = list("marrow" = 1)
	.[DATA_ALLERGENS] = ALLERGEN_MEAT
	.[DATA_TASTE] = list("rich marrow" = 5)

/decl/recipe/soup/simple
	abstract_type = /decl/recipe/soup/simple
	reagents = list(
		/decl/material/liquid/nutriment/soup/stock = 10
	)
	result = /decl/material/liquid/nutriment/soup/simple
	result_quantity = 10
	completion_message = "A savoury smell rises from the soup as the ingredients release their flavour into the broth."
	precursor_type = /decl/material/liquid/nutriment/soup/stock
	complexity = 5 // Setting high by default so it takes priority over stew.

/decl/recipe/soup/simple/meat
	display_name = "simple meat soup"
	items = list(
		/obj/item/food/butchery/chopped = 1
	)

/decl/recipe/soup/simple/veg
	display_name = "simple vegetable soup"
	items = list(
		/obj/item/food/processed_grown/chopped = 1
	)

/decl/recipe/soup/simple/stew
	abstract_type = /decl/recipe/soup/simple/stew
	precursor_type = /decl/material/liquid/nutriment/soup/simple
	reagents = list(
		/decl/material/liquid/nutriment/soup/simple = 10
	)
	result_quantity = 10
	result = /decl/material/liquid/nutriment/soup/stew
	complexity = 0 // Have to reset it because it inherits from soup.

/decl/recipe/soup/simple/stew/mixed
	display_name = "mixed stew"
	items = list(
		/obj/item/food/butchery/chopped = 1,
		/obj/item/food/processed_grown/chopped = 1
	)

/decl/recipe/soup/simple/stew/meat
	display_name = "meat stew"
	items = list(
		/obj/item/food/butchery/chopped = 2
	)

/decl/recipe/soup/simple/stew/veg
	display_name = "vegetable stew"
	items = list(
		/obj/item/food/processed_grown/chopped = 2
	)
