/decl/recipe/soup
	abstract_type = /decl/recipe/soup
	reagent_mix = REAGENT_REPLACE
	container_categories = list(RECIPE_CATEGORY_POT)

/decl/recipe/soup/stock
	abstract_type = /decl/recipe/soup/stock
	result_quantity = 10
	result = /decl/material/liquid/nutriment/soup/stock
	reagents = list(
		/decl/material/solid/sodiumchloride = 1,
		/decl/material/liquid/water = 10
	)
	minimum_temperature = 100 CELSIUS

/decl/recipe/soup/get_result_data(atom/container, list/used_ingredients)

	. = list()
	var/soup_flags = SOUP_PLAIN
	var/list/taste_strings = list()
	var/list/ingredients = list()
	var/list/used_items = used_ingredients["items"]

	if(length(used_items))

		for(var/obj/item/chems/food/food in used_items)
			if(food.nutriment_type && food.nutriment_desc)
				for(var/taste in food.nutriment_desc)
					taste_strings[taste] += food.nutriment_desc[taste]

		if(locate(/obj/item/chems/food/grown) in used_items)
			soup_flags |= SOUP_VEGETARIAN
			for(var/obj/item/chems/food/grown/veg in used_items)
				ingredients[veg.name]++

		if(locate(/obj/item/chems/food/butchery) in used_items)
			soup_flags |= SOUP_CARNIVORE
			for(var/obj/item/chems/food/butchery/meat in used_items)
				if(meat.meat_name)
					ingredients[meat.meat_name]++

	if(length(taste_strings))
		.["taste"] = taste_strings
	if(length(ingredients))
		.["soup_ingredients"] = ingredients
	if(soup_flags)
		.["soup_flags"] = soup_flags

/decl/recipe/soup/stock/meat
	display_name = "meat stock"
	items = list(/obj/item/chems/food/butchery)
	completion_message = "The liquid darkens to a rich brown as the meat dissolves."

/decl/recipe/soup/stock/vegetable
	display_name = "vegetable stock"
	items = list(/obj/item/chems/food/grown)
	completion_message = "The liquid darkens to a rich brown as the vegetables dissolve."

/decl/recipe/soup/stock/bone
	display_name = "bone broth"
	items = list(/obj/item/stack/material/bone = 3)
	completion_message = "The liquid darkens to a rich brown as the marrow dissolves."

/decl/recipe/soup/stock/bone/get_result_data(atom/container, list/used_ingredients)
	. = list()
	.["soup_ingredients"] = list("marrow" = 1)
	.["soup_flags"] = SOUP_CARNIVORE

/decl/recipe/soup/simple
	abstract_type = /decl/recipe/soup/simple
	reagents = list(
		/decl/material/liquid/nutriment/soup/stock = 10
	)
	result = /decl/material/liquid/nutriment/soup/simple
	result_quantity = 15
	completion_message = "A savoury smell rises from the soup as the ingredients release their flavour into the broth."

/decl/recipe/soup/simple/get_result_data(atom/container, list/used_ingredients)

	. = ..()

	var/list/stock_data = LAZYACCESS(container.reagents?.reagent_data, /decl/material/liquid/nutriment/soup/stock)

	var/list/taste_strings = LAZYACCESS(stock_data, "taste")
	if(length(taste_strings))
		LAZYINITLIST(.["taste"])
		for(var/taste in taste_strings)
			.["taste"][taste] += taste_strings[taste]

	var/list/ingredients = LAZYACCESS(stock_data, "soup_ingredients")
	if(length(ingredients))
		LAZYINITLIST(.["soup_ingredients"])
		for(var/ingredient in ingredients)
			.["soup_ingredients"][ingredient] += ingredients[ingredient]

	var/soup_flags = LAZYACCESS(stock_data, "soup_flags")
	if(soup_flags)
		.["soup_flags"] = .["soup_flags"] | soup_flags

/decl/recipe/soup/simple/meat
	display_name = "simple meat soup"
	items = list(
		/obj/item/chems/food/butchery/chopped = 2
	)

/decl/recipe/soup/simple/veg
	display_name = "simple vegetable soup"
	items = list(
		/obj/item/chems/food/rawsticks = 2
	)

/decl/recipe/soup/simple/mixed
	display_name = "simple soup"
	items = list(
		/obj/item/chems/food/butchery/chopped = 1,
		/obj/item/chems/food/rawsticks = 1
	)
