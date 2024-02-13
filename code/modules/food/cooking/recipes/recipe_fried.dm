/decl/recipe/waffles
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/waffles

/decl/recipe/pancakesblu
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	fruit = list("blueberries" = 2)
	result = /obj/item/chems/food/pancakesblu

/decl/recipe/pancakes
	display_name = "plain pancakes"
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	result = /obj/item/chems/food/pancakes

/decl/recipe/friedegg
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/friedegg

/decl/recipe/omelette
	items = list(
		/obj/item/chems/food/egg = 2,
		/obj/item/chems/food/cheesewedge,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/omelette

/decl/recipe/cubancarp
	fruit = list("chili" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	items = list(
		/obj/item/chems/food/fish
	)
	result = /obj/item/chems/food/cubancarp

/decl/recipe/fishandchips
	items = list(
		/obj/item/chems/food/fries,
		/obj/item/chems/food/fish
	)
	result = /obj/item/chems/food/fishandchips

/decl/recipe/onionrings
	fruit = list("onion" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/onionrings

/decl/recipe/fries
	display_name = "potato chips"
	items = list(
		/obj/item/chems/food/rawsticks
	)
	result = /obj/item/chems/food/fries
