/decl/recipe/soup/chili
	abstract_type      = /decl/recipe/soup/chili
	result             = /decl/material/liquid/nutriment/soup/chili
	reagents           = list(/decl/material/liquid/water = 5)
	completion_message = "The sauce thickens as the chili cooks down."
	complexity         = 3

/decl/recipe/soup/chili/hot
	display_name = "hot meat chili"
	fruit        = list("chili" = 1, "tomato chopped" = 1)
	items        = list(/obj/item/food/butchery/chopped = 1)

/decl/recipe/soup/chili/hot/vegetarian
	display_name = "hot vegetarian chili"
	items        = list(/obj/item/food/processed_grown/chopped = 2)
	complexity   = 0

/decl/recipe/soup/chili/cold
	display_name = "cold meat chili"
	fruit        = list("icechili" = 1, "tomato chopped" = 1)
	items        = list(/obj/item/food/butchery/chopped = 1)

/decl/recipe/soup/chili/cold/vegetarian
	display_name = "cold vegetarian chili"
	items        = list(/obj/item/food/processed_grown/chopped = 1)
	complexity   = 0
