/decl/recipe/soup/curry
	abstract_type      = /decl/recipe/soup/curry
	result             = /decl/material/liquid/nutriment/soup/curry
	completion_message = "The sauce thickens as the curry cooks down."
	// It's silly to distinguish this from other recipes only via rice, but
	// we don't have curry powder or other spices to include here. TODO.
	reagents           = list(
		/decl/material/liquid/water          = 5,
		/decl/material/liquid/nutriment/rice = 5
	)

/decl/recipe/soup/curry/meat
	display_name  = "meat curry"
	items         = list(/obj/item/food/butchery/chopped = 2)

/decl/recipe/soup/curry/veg
	display_name = "vegetarian curry"
	items        = list(/obj/item/food/processed_grown/chopped = 2)

/decl/recipe/soup/curry/mixed
	display_name = "mixed curry"
	items        = list(
		/obj/item/food/butchery/chopped = 1,
		/obj/item/food/processed_grown/chopped = 1
	)
	complexity   = 3 // So it takes precedence over pure meat or pure veggie curry.
