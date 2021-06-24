/decl/recipe/cutlet
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/rawcutlet
	)
	result = /obj/item/chems/food/snacks/cutlet

/decl/recipe/meatball
	appliance = SKILLET | SAUCEPAN
	items = list(
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/meatball

/decl/recipe/bacon
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/rawbacon
	)
	result = /obj/item/chems/food/snacks/bacon

/decl/recipe/bacon_oven
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/spreads
	)
	result = /obj/item/chems/food/snacks/bacon/oven
	result_quantity = 6

//Bacon
/decl/recipe/bacon_pan
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/rawbacon,
		/obj/item/chems/food/snacks/spreads
	)
	result = /obj/item/chems/food/snacks/bacon/pan
	result_quantity = 6

/decl/recipe/meatsteak
	appliance = SKILLET
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(/obj/item/chems/food/snacks/meat)
	result = /obj/item/chems/food/snacks/meatsteak

/decl/recipe/syntisteak
	appliance = SKILLET
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(/obj/item/chems/food/snacks/meat/syntiflesh)
	result = /obj/item/chems/food/snacks/meatsteak

/decl/recipe/sausage
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/sausage
	result_quantity = 2

/decl/recipe/nugget
	appliance = FRYER
	reagents = list(/decl/reagent/nutriment/flour = 5)
	items = list(
		/obj/item/chems/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/chems/food/snacks/nugget

/decl/recipe/fishandchips
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishandchips

/decl/recipe/lasagna
	appliance = OVEN
	fruit = list("tomato" = 2, "eggplant" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat
	)
	result = /obj/item/chems/food/snacks/lasagna
	reagent_mix = RECIPE_REAGENT_REPLACE
