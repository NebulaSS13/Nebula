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
	var/list/used_items = used_ingredients[RECIPE_COMPONENT_ITEMS]

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
		var/precursor_allergen_flags = LAZYACCESS(precursor_data, DATA_INGREDIENT_FLAGS)
		if(precursor_allergen_flags)
			allergen_flags |= precursor_allergen_flags

	if(length(taste_strings))
		.[DATA_TASTE] = taste_strings
	if(length(ingredients))
		.[DATA_INGREDIENT_LIST] = ingredients
	if(allergen_flags)
		.[DATA_INGREDIENT_FLAGS] = allergen_flags
