/decl/recipe/soup/simple
	abstract_type      = /decl/recipe/soup/simple
	result             = /decl/material/liquid/nutriment/soup/simple
	reagents           = list(/decl/material/liquid/nutriment/soup/stock = 10)
	completion_message = "A savoury smell rises from the soup as the ingredients release their flavour into the broth."
	precursor_type     = /decl/material/liquid/nutriment/soup/stock
	complexity         = 5 // Setting high by default so it takes priority over stew.

/decl/recipe/soup/simple/meatball
	display_name   = "meatball soup"
	items          = list(/obj/item/food/meatball = 1)

/decl/recipe/soup/simple/meat
	display_name   = "simple meat soup"
	items          = list(/obj/item/food/butchery/chopped = 1)

/decl/recipe/soup/simple/veg
	display_name   = "simple vegetable soup"
	items          = list(/obj/item/food/processed_grown/chopped = 1)

/decl/recipe/soup/simple/blood
	display_name       = "blood soup"
	reagents           = list(/decl/material/liquid/blood = 10)
	completion_message = "The blood thickens and partially congeals as it cooks."
	precursor_type     = null

/decl/recipe/soup/simple/blood/get_result_data(atom/container, list/used_ingredients)
	. = list(
		DATA_INGREDIENT_LIST  = list("blood" = 1),
		DATA_INGREDIENT_FLAGS = ALLERGEN_MEAT,
		DATA_TASTE            = list("iron and copper" = 5),
//		DATA_MASK_NAME          = "tomato soup" // Maybe?
	)

/decl/recipe/soup/simple/milk
	abstract_type      = /decl/recipe/soup/simple/milk
	reagents           = list(/decl/material/liquid/drink/milk = 10)
	precursor_type     = null

/decl/recipe/soup/simple/milk/get_result_data(atom/container, list/used_ingredients)
	. = ..()
	// Consider prefixing 'cream of' for milk soups?
	LAZYINITLIST(.)
	var/cream = LAZYACCESS(.[DATA_TASTE], "cream")
	LAZYSET(.[DATA_TASTE], "cream", cream + 1)
	LAZYDISTINCTADD(.[DATA_INGREDIENT_FLAGS], ALLERGEN_DAIRY)

/decl/recipe/soup/simple/milk/meat
	display_name   = "simple meat milk soup"
	items          = list(/obj/item/food/butchery/chopped = 1)

/decl/recipe/soup/simple/milk/veg
	display_name   = "simple vegetable milk soup"
	items          = list(/obj/item/food/processed_grown/chopped = 1)

/decl/recipe/soup/simple/milk/cream
	abstract_type      = /decl/recipe/soup/simple/milk/cream
	reagents           = list(/decl/material/liquid/drink/milk/cream = 10)

/decl/recipe/soup/simple/milk/cream/meat
	display_name   = "simple meat cream soup"
	items          = list(/obj/item/food/butchery/chopped = 1)

/decl/recipe/soup/simple/milk/cream/veg
	display_name   = "simple vegetable cream soup"
	items          = list(/obj/item/food/processed_grown/chopped = 1)
