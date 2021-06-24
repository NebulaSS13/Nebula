// Breads
//================================
/decl/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/bun

/decl/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough
	)
	reagents = list(/decl/reagent/sodiumchloride = 1)
	result = /obj/item/chems/food/snacks/sliceable/bread

/decl/recipe/baguette
	appliance = OVEN
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/baguette


/decl/recipe/tofubread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/tofubread


/decl/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/creamcheesebread

/decl/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough
	)
	result = /obj/item/chems/food/snacks/flatbread

/decl/recipe/meatbread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/meatbread

/decl/recipe/syntibread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/meatbread

/decl/recipe/xenomeatbread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/xenomeat,
		/obj/item/chems/food/snacks/xenomeat,
		/obj/item/chems/food/snacks/xenomeat,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/xenomeatbread

/decl/recipe/bananabread
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/sugar = 15)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/sliceable/bananabread

/decl/recipe/croissant
	appliance = OVEN
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/water = 5, /decl/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/chems/food/snacks/dough)
	result = /obj/item/chems/food/snacks/croissant

/decl/recipe/poppypretzel
	appliance = OVEN
	fruit = list("poppy" = 1)
	items = list(/obj/item/chems/food/snacks/dough)
	result = /obj/item/chems/food/snacks/poppypretzel
	result_quantity = 2

/decl/recipe/cracker
	appliance = OVEN
	reagents = list(/decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/doughslice
	)
	result = /obj/item/chems/food/snacks/cracker
//================================
// Toasts and Toasted Sandwiches
//================================
/decl/recipe/slimetoast
	appliance = SKILLET
	reagents = list(/decl/reagent/slimejelly = 5)
	items = list(
		/obj/item/chems/food/snacks/breadslice
	)
	result = /obj/item/chems/food/snacks/jelliedtoast/slime

/decl/recipe/jelliedtoast
	appliance = SKILLET
	reagents = list(/decl/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/breadslice
	)
	result = /obj/item/chems/food/snacks/jelliedtoast/cherry

/decl/recipe/toastedsandwich
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/sandwich
	)
	result = /obj/item/chems/food/snacks/toastedsandwich

/decl/recipe/grilledcheese
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/breadslice,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/grilledcheese
