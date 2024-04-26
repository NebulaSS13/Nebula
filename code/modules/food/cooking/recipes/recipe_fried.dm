/decl/recipe/fried
	abstract_type = /decl/recipe/fried
	//cooking_heat_type = COOKING_HEAT_DIRECT
	//cooking_medium_type = /decl/material/liquid/oil

/decl/recipe/fried/waffles
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/waffles

/decl/recipe/fried/pancakesblu
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	fruit = list("blueberries" = 2)
	result = /obj/item/chems/food/pancakesblu

/decl/recipe/fried/pancakes
	display_name = "plain pancakes"
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	result = /obj/item/chems/food/pancakes

/decl/recipe/fried/friedegg
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/friedegg

/decl/recipe/fried/omelette
	items = list(
		/obj/item/chems/food/egg = 2,
		/obj/item/chems/food/cheesewedge,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/omelette

/decl/recipe/fried/cubancarp
	fruit = list("chili" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	items = list(
		/obj/item/chems/food/butchery/meat/fish
	)
	result = /obj/item/chems/food/cubancarp

/decl/recipe/fried/fishandchips
	items = list(
		/obj/item/chems/food/fries,
		/obj/item/chems/food/butchery/meat/fish
	)
	result = /obj/item/chems/food/fishandchips

/decl/recipe/fried/onionrings
	fruit = list("onion" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/onionrings

/decl/recipe/fried/fries
	display_name = "potato chips"
	fruit = list("potato sticks" = 1)
	result = /obj/item/chems/food/fries
