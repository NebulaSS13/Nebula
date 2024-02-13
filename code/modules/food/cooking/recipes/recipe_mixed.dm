
/decl/recipe/sausage
	display_name = "plain sausage"
	items = list(
		/obj/item/chems/food/rawmeatball,
		/obj/item/chems/food/rawcutlet,
	)
	result = /obj/item/chems/food/sausage

/decl/recipe/fatsausage
	reagents = list(/decl/material/solid/blackpepper = 2)
	items = list(
		/obj/item/chems/food/rawmeatball,
		/obj/item/chems/food/rawcutlet,
	)
	result = /obj/item/chems/food/fatsausage

/decl/recipe/stuffing
	reagents = list(/decl/material/liquid/water = 10, /decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/sliceable/bread,
	)
	result = /obj/item/chems/food/stuffing

/decl/recipe/mint
	reagents = list(/decl/material/liquid/nutriment/sugar = 5, /decl/material/liquid/frostoil = 5)
	result = /obj/item/chems/food/mint

/decl/recipe/chocolatebar
	reagents = list(/decl/material/liquid/drink/milk/chocolate = 10, /decl/material/liquid/nutriment/coco = 5, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/chocolatebar

/decl/recipe/chocolateegg
	items = list(
		/obj/item/chems/food/egg,
		/obj/item/chems/food/chocolatebar,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/chocolateegg

/decl/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/candiedapple

/decl/recipe/cherrysandwich
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread = 2,
	)
	result = /obj/item/chems/food/jellysandwich/cherry
