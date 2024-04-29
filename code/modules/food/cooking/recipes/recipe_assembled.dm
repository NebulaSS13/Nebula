// TODO: make all of these into handcrafted items
/decl/recipe/sandwich
	display_name = "plain sandwich"
	items = list(
		/obj/item/chems/food/meatsteak,
		/obj/item/chems/food/slice/bread = 2,
		/obj/item/chems/food/cheesewedge,
	)
	result = /obj/item/chems/food/sandwich

/decl/recipe/bigbiteburger
	items = list(
		/obj/item/chems/food/burger,
		/obj/item/chems/food/butchery/meat = 2,
		/obj/item/chems/food/egg,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/bigbiteburger

/decl/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list(/decl/material/solid/sodiumchloride = 5, /decl/material/solid/blackpepper = 5)
	items = list(
		/obj/item/chems/food/bigbiteburger,
		/obj/item/chems/food/dough,
		/obj/item/chems/food/butchery/meat,
		/obj/item/chems/food/cheesewedge,
		/obj/item/chems/food/boiledegg,
	)
	result = /obj/item/chems/food/superbiteburger

/decl/recipe/twobread
	reagents = list(/decl/material/liquid/ethanol/wine = 5)
	items = list(
		/obj/item/chems/food/slice/bread = 2,
	)
	result = /obj/item/chems/food/twobread

/decl/recipe/taco
	items = list(
		/obj/item/chems/food/doughslice,
		/obj/item/chems/food/butchery/cutlet,
		/obj/item/chems/food/cheesewedge
	)
	result = /obj/item/chems/food/taco
