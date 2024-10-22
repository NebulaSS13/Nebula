/decl/recipe/soup/stew
	abstract_type      = /decl/recipe/soup/stew
	precursor_type     = /decl/material/liquid/nutriment/soup/simple
	reagents           = list(/decl/material/liquid/nutriment/soup/simple = 10)
	result             = /decl/material/liquid/nutriment/soup/stew
	completion_message = "A savoury smell rises from the soup as the ingredients release their flavour into the broth."

/decl/recipe/soup/stew/mixed
	display_name = "mixed stew"
	items = list(
		/obj/item/food/butchery/chopped = 1,
		/obj/item/food/processed_grown/chopped = 1
	)
	complexity = 7

/decl/recipe/soup/stew/meat
	display_name = "meat stew"
	items = list(
		/obj/item/food/butchery/chopped = 2
	)

/decl/recipe/soup/stew/veg
	display_name = "vegetable stew"
	items = list(
		/obj/item/food/processed_grown/chopped = 2
	)
