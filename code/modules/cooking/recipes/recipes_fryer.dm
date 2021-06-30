/decl/recipe/cubancarp
	appliance = FRYER
	fruit = list("chili" = 1)
	coating = /decl/material/liquid/nutriment/batter
	items = list(
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/cubancarp

/decl/recipe/fishandchips
	appliance = FRYER
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishandchips

/decl/recipe/katsucurry
	appliance = FRYER
	fruit = list("apple" = 1, "carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10, /decl/material/liquid/nutriment/flour = 5)
	items = list(
		/obj/item/chems/food/snacks/meat/chicken
	)
	result = /obj/item/chems/food/snacks/katsucurry

/decl/recipe/fishfingers
	appliance = FRYER
	items = list(
		/obj/item/chems/food/snacks/fish
	)
	coating = /decl/material/liquid/nutriment/batter
	result = /obj/item/chems/food/snacks/fishfingers

/decl/recipe/fries
	appliance = FRYER
	items = list(
		/obj/item/chems/food/snacks/rawsticks
	)
	result = /obj/item/chems/food/snacks/fries

/decl/recipe/onionrings
	appliance = FRYER
	fruit = list("onion" = 1)
	coating = /decl/material/liquid/nutriment/batter
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/snacks/onionrings