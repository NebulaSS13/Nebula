
// see code/datums/recipe.dm
/decl/recipe/hotdog
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/sausage
	)
	result = /obj/item/chems/food/snacks/hotdog

/decl/recipe/classichotdog
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/meat/corgi
	)
	result = /obj/item/chems/food/snacks/classichotdog

/decl/recipe/humanburger
	items = list(
		/obj/item/chems/food/snacks/meat/human,
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/human/burger

/decl/recipe/mouseburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/meat/rat
	)
	result = /obj/item/chems/food/snacks/burger/mouse

/decl/recipe/plainburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/meat //do not place this recipe before /decl/recipe/humanburger
	)
	result = /obj/item/chems/food/snacks/burger

/decl/recipe/brainburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/chems/food/snacks/burger/brain

/decl/recipe/xenoburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/xenomeat
	)
	result = /obj/item/chems/food/snacks/burger/xeno

/decl/recipe/fishburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/burger/fish

/decl/recipe/tofuburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/tofu
	)
	result = /obj/item/chems/food/snacks/burger/tofu

/decl/recipe/humankabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/chems/food/snacks/meat/human,
		/obj/item/chems/food/snacks/meat/human
	)
	result = /obj/item/chems/food/snacks/human/kabob

/decl/recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat
	)
	result = /obj/item/chems/food/snacks/monkeykabob

/decl/recipe/syntikabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/chems/food/snacks/meat/syntiflesh
	)
	result = /obj/item/chems/food/snacks/monkeykabob

/decl/recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu
	)
	result = /obj/item/chems/food/snacks/tofukabob

/decl/recipe/bigbiteburger
	items = list(
		/obj/item/chems/food/snacks/burger,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat
	)
	reagents = list(/decl/material/liquid/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/chems/food/snacks/burger/bigbite

/decl/recipe/sandwich
	items = list(
		/obj/item/chems/food/snacks/meatsteak,
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sandwich

/decl/recipe/bunbun
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/bunbun

/decl/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list(/decl/reagent/sodiumchloride = 5, /decl/reagent/blackpepper = 5)
	items = list(
		/obj/item/chems/food/snacks/burger/bigbite,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/boiledegg
	)
	result = /obj/item/chems/food/snacks/burger/superbite

/decl/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list(/decl/material/liquid/water = 5, /decl/reagent/sugar = 5)
	result = /obj/item/chems/food/snacks/candiedapple

/decl/recipe/slimeburger
	reagents = list(/decl/reagent/slimejelly = 5)
	items = list(
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/burger/jelly/slime

/decl/recipe/jellyburger
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/burger/jelly/cherry

/decl/recipe/twobread
	appliance = SKILLET | MIX
	reagents = list(/decl/reagent/alcohol/wine = 5)
	items = list(
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/breadslice
	)
	result = /obj/item/chems/food/snacks/twobread

/decl/recipe/slimesandwich
	reagents = list(/decl/reagent/slimejelly = 5)
	items = list(
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/breadslice
	)
	result = /obj/item/chems/food/snacks/jellysandwich/slime

/decl/recipe/cherrysandwich
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/breadslice
	)
	result = /obj/item/chems/food/snacks/jellysandwich/cherry

/decl/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/chems/food/snacks/salad/tossedsalad

/decl/recipe/aesirsalad
	fruit = list("goldapple" = 1, "ambrosiadeus" = 1)
	result = /obj/item/chems/food/snacks/salad/aesirsalad

/decl/recipe/validsalad
	fruit = list("potato" = 1, "ambrosia" = 3)
	items = list(/obj/item/chems/food/snacks/meatball)
	result = /obj/item/chems/food/snacks/salad/validsalad
	make_food(var/obj/container as obj)

		. = ..(container)
		for (var/obj/item/chems/food/snacks/salad/validsalad/being_cooked in .)
			being_cooked.reagents.del_reagent(/decl/reagent/toxin)

/*
/decl/recipe/neuralbroke
	items = list(/obj/item/organ/vaurca/neuralsocket)
	result = /obj/item/neuralbroke
*/

/////////////////////////////////////////////////////////////
//Synnono Meme Foods
//
//Most recipes replace reagents with RECIPE_REAGENT_REPLACE
//to simplify the end product and balance the amount of reagents
//in some foods. Many require the space spice reagent/condiment
//to reduce the risk of future recipe conflicts.
/////////////////////////////////////////////////////////////

/decl/recipe/bearburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/bearmeat
	)
	result = /obj/item/chems/food/snacks/burger/bear

/decl/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	items = list(
		/obj/item/chems/food/snacks/chickenkatsu,
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/chickenfillet

/decl/recipe/chilicheesefries
	appliance = SKILLET | SAUCEPAN | MIX // you can reheat it if you'd like
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/hotchili
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/chems/food/snacks/chilicheesefries

/decl/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list(/decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/meatsteak,
		/obj/item/chems/food/snacks/sliceable/flatdough
	)
	result = /obj/item/chems/food/snacks/donerkebab

/decl/recipe/sashimi
	reagents = list(/decl/material/liquid/nutriment/soysauce = 5)
	items = list(
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/sashimi


// Chip update

/decl/recipe/cheese_cracker
	items = list(
		/obj/item/chems/food/snacks/spreads,
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/cheesewedge
	)
	reagents = list(/decl/reagent/spacespice = 1)
	result = /obj/item/chems/food/snacks/cheese_cracker
	result_quantity = 4

/decl/recipe/baconburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/bacon,
		/obj/item/chems/food/snacks/bacon
	)
	result = /obj/item/chems/food/snacks/burger/bacon

/decl/recipe/blt
	fruit = list("tomato" = 1, "cabbage" = 1)
	items = list(
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/bacon,
		/obj/item/chems/food/snacks/bacon
	)
	result = /obj/item/chems/food/snacks/blt

/decl/recipe/fish_taco
	appliance = MIX | SKILLET
	fruit = list("chili" = 1, "lemon" = 1)
	items = list(
		/obj/item/chems/food/snacks/fish,
		/obj/item/chems/food/snacks/tortilla
	)
	result = /obj/item/chems/food/snacks/fish_taco

/decl/recipe/mashedpotato
	fruit = list("potato" = 1)
	result = /obj/item/chems/food/snacks/mashedpotato

/decl/recipe/icecreamsandwich
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/drink/ice = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/chems/food/snacks/icecream
	)
	result = /obj/item/chems/food/snacks/icecreamsandwich

/decl/recipe/banana_split
	fruit = list("banana" = 1)
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/drink/ice = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/chems/food/snacks/icecream
	)
	result = /obj/item/chems/food/snacks/banana_split

/decl/recipe/lardwich
	items = list(
		/obj/item/chems/food/snacks/flatbread,
		/obj/item/chems/food/snacks/flatbread,
		/obj/item/chems/food/snacks/spreads/lard
	)
	result = /obj/item/chems/food/snacks/lardwich
	reagent_mix = RECIPE_REAGENT_REPLACE
