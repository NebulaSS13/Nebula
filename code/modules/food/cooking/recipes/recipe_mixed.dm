/decl/recipe/chocolateegg
	items = list(
		/obj/item/food/egg,
		/obj/item/food/chocolatebar,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/food/chocolateegg

/decl/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/food/candiedapple

/decl/recipe/cherrysandwich
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/food/slice/bread = 2,
	)
	result = /obj/item/food/jellysandwich/cherry
