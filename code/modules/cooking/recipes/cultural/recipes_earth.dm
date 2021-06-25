// Salads
//=========================
/decl/recipe/chips
	appliance = SKILLET | FRYER
	reagents = list(/decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/tortilla
	)
	result = /obj/item/chems/food/snacks/chipplate

/decl/recipe/nachos
	appliance = SKILLET // melt the cheese!
	items = list(
		/obj/item/chems/food/snacks/chipplate,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/chipplate/nachos

/decl/recipe/cheesyfries
	appliance = SKILLET | MIX // You can reheat it or mix it cold, like some sort of monster.
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/cheesyfries

/decl/recipe/salsa
	fruit = list("chili" = 1, "tomato" = 1, "lime" = 1)
	reagents = list(/decl/reagent/spacespice = 1, /decl/reagent/blackpepper = 1,/decl/reagent/sodiumchloride = 1)
	result = /obj/item/chems/food/snacks/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/decl/recipe/guac
	fruit = list("chili" = 1, "lime" = 1)
	reagents = list(/decl/reagent/spacespice = 1, /decl/reagent/blackpepper = 1,/decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/tofu
	)
	result = /obj/item/chems/food/snacks/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/decl/recipe/cheesesauce
	appliance = SKILLET | SAUCEPAN // melt the cheese
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list(/decl/reagent/spacespice = 1, /decl/reagent/blackpepper = 1,/decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/decl/recipe/redcurry
	appliance = SKILLET
	reagents = list(/decl/material/liquid/drink/milk/cream = 5, /decl/reagent/spacespice = 2, /decl/material/liquid/nutriment/rice = 5)
	items = list(
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/redcurry

/decl/recipe/greencurry
	appliance = SKILLET
	reagents = list(/decl/material/liquid/drink/milk/cream = 5, /decl/reagent/spacespice = 2, /decl/material/liquid/nutriment/rice = 5)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/greencurry

/decl/recipe/yellowcurry
	appliance = SKILLET
	reagents = list(/decl/material/liquid/drink/milk/cream = 5, /decl/reagent/spacespice = 2, /decl/material/liquid/nutriment/rice = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/yellowcurry

/decl/recipe/friedrice
	appliance = SKILLET | SAUCEPAN
	reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/rice = 10, /decl/material/liquid/nutriment/soysauce = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/friedrice

/decl/recipe/risotto
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/alcohol/wine = 5, /decl/material/liquid/nutriment/rice = 10, /decl/reagent/spacespice = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/chems/food/snacks/risotto

/decl/recipe/boiledrice
	appliance = SAUCEPAN | POT
	reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/snacks/boiledrice

/decl/recipe/ricepudding
	appliance = SAUCEPAN | POT
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/snacks/ricepudding

/decl/recipe/bibimbap
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list(/decl/material/liquid/nutriment/rice = 5, /decl/reagent/spacespice = 2)
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/bibimbap

/decl/recipe/boiledspagetti
	appliance = SAUCEPAN | POT
	reagents = list(/decl/material/liquid/water = 5)
	items = list(
		/obj/item/chems/food/snacks/spagetti
	)
	result = /obj/item/chems/food/snacks/boiledspagetti

/decl/recipe/pastatomato
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 5)
	items = list(/obj/item/chems/food/snacks/spagetti)
	result = /obj/item/chems/food/snacks/pastatomato

/decl/recipe/meatballspagetti
	appliance = SAUCEPAN | POT
	reagents = list(/decl/material/liquid/water = 5)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball
	)
	result = /obj/item/chems/food/snacks/meatballspagetti

/decl/recipe/spesslaw
	appliance = SAUCEPAN | POT
	reagents = list(/decl/material/liquid/water = 5)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball
	)
	result = /obj/item/chems/food/snacks/spesslaw

/decl/recipe/lomein
	appliance = SAUCEPAN | POT
	reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/soysauce = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/chems/food/snacks/spagetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/lomein

/decl/recipe/stewedsoymeat
	appliance = SAUCEPAN
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/soydope
	)
	result = /obj/item/chems/food/snacks/stewedsoymeat

// Toasts
//=========================
/decl/recipe/tofurkey
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/stuffing
	)
	result = /obj/item/chems/food/snacks/tofurkey

/decl/recipe/stuffing
	appliance = OVEN
	reagents = list(/decl/material/liquid/water = 5, /decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/bread
	)
	result = /obj/item/chems/food/snacks/stuffing

/decl/recipe/tortilla
	appliance = SKILLET
	reagents = list(/decl/material/liquid/nutriment/flour = 5,/decl/material/liquid/water = 5)
	result = /obj/item/chems/food/snacks/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water

//Calzones
//=========================
/decl/recipe/burrito
	items = list(
		/obj/item/chems/food/snacks/tortilla,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball
	)
	reagents = list(/decl/reagent/spacespice = 1)
	result = /obj/item/chems/food/snacks/burrito

/decl/recipe/burrito_vegan
	items = list(
		/obj/item/chems/food/snacks/tortilla,
		/obj/item/chems/food/snacks/tofu
	)
	result = /obj/item/chems/food/snacks/burrito_vegan

/decl/recipe/burrito_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/chems/food/snacks/burrito
	)
	result = /obj/item/chems/food/snacks/burrito_spicy

/decl/recipe/burrito_cheese
	items = list(
		/obj/item/chems/food/snacks/burrito,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/burrito_cheese

/decl/recipe/burrito_cheese_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/chems/food/snacks/burrito,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/burrito_cheese_spicy

/decl/recipe/burrito_hell
	fruit = list("chili" = 10)
	items = list(
		/obj/item/chems/food/snacks/burrito_spicy
	)
	result = /obj/item/chems/food/snacks/burrito_hell
	reagent_mix = RECIPE_REAGENT_REPLACE //Already hot sauce

/decl/recipe/burrito_mystery
	items = list(
		/obj/item/chems/food/snacks/burrito,
		/obj/item/chems/food/snacks/soup/mystery
	)
	result = /obj/item/chems/food/snacks/burrito_mystery

/decl/recipe/meatbun
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/spacespice = 1, /decl/material/liquid/water = 5)
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/chems/food/snacks/meatbun

/decl/recipe/custardbun
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/spacespice = 1, /decl/material/liquid/water = 5, /decl/material/liquid/nutriment/protein/egg = 3)
	items = list(
		/obj/item/chems/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/chems/food/snacks/custardbun

/decl/recipe/chickenmomo
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/spacespice = 2, /decl/material/liquid/water = 5)
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/chickenmomo

/decl/recipe/veggiemomo
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/spacespice = 2, /decl/material/liquid/water = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/chems/food/snacks/veggiemomo

// Sushi
//=========================
/decl/recipe/enchiladas_new
	appliance = OVEN
	fruit = list("chili" = 2)
	items = list(
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/tortilla
	)
	result = /obj/item/chems/food/snacks/enchiladas

// Tacos
//=========================

/decl/recipe/taco
	appliance = SKILLET | MIX
	items = list(
		/obj/item/chems/food/snacks/tortilla,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/taco
