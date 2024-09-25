/decl/recipe/soup/stock
	abstract_type      = /decl/recipe/soup/stock
	result             = /decl/material/liquid/nutriment/soup/stock
	complexity         = 10 // Setting high by default so it takes priority over simple soup.
	completion_message = "The liquid darkens to a rich brown as the meat dissolves."
	reagents           = list(
		/decl/material/solid/sodiumchloride = 1,
		/decl/material/liquid/water = 10
	)

/decl/recipe/soup/stock/meat
	display_name = "meat stock"
	items = list(/obj/item/food/butchery)

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
	.[DATA_INGREDIENT_LIST]  = list("marrow" = 1)
	.[DATA_INGREDIENT_FLAGS] = ALLERGEN_MEAT
	.[DATA_TASTE]            = list("rich marrow" = 5)
