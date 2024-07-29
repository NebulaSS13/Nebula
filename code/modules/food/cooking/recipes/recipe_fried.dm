/decl/recipe/fried
	abstract_type = /decl/recipe/fried
	//cooking_heat_type = COOKING_HEAT_DIRECT
	//cooking_medium_type = /decl/material/liquid/oil
	container_categories = list(
		RECIPE_CATEGORY_MICROWAVE,
		RECIPE_CATEGORY_SKILLET
	)

/decl/recipe/fried/waffles
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/food/waffles
	completion_message = "The waffles firm up and brown as the batter is cooked through."

/decl/recipe/fried/pancakesblu
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	fruit = list("blueberries" = 2)
	result = /obj/item/food/pancakesblu
	completion_message = "The pancakes firm up and brown as the batter is cooked through."

/decl/recipe/fried/pancakes
	display_name = "plain pancakes"
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	result = /obj/item/food/pancakes
	completion_message = "The pancakes firm up and brown as the batter is cooked through."

/decl/recipe/fried/friedegg
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/food/friedegg
	completion_message = "The egg spits and sizzles as it cooks through."

/decl/recipe/fried/omelette
	items = list(
		/obj/item/food/egg = 2,
		/obj/item/food/cheesewedge,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/food/omelette
	completion_message = "The omelette firms up as it cooks through."

/decl/recipe/fried/cubancarp
	fruit = list("chili" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	items = list(
		/obj/item/food/butchery/meat/fish
	)
	result = /obj/item/food/cubancarp
	completion_message = "The batter darkens to a rich golden brown as the fish is cooked through."

/decl/recipe/fried/fishandchips
	items = list(
		/obj/item/food/fries,
		/obj/item/food/butchery/meat/fish
	)
	result = /obj/item/food/fishandchips
	completion_message = "The batter darkens to a rich golden brown as the fish is cooked through."

/decl/recipe/fried/onionrings
	fruit = list("onion" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/food/onionrings
	completion_message = "The batter darkens to a rich golden brown as the onion rings are cooked through."

/decl/recipe/fried/fries
	display_name = "potato chips"
	fruit = list("potato sticks" = 1)
	result = /obj/item/food/fries
	completion_message = "The potato sizzles as as the chips are cooked through."
