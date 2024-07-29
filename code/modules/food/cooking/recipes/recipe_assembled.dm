// TODO: make all of these into handcrafted items
/decl/recipe/sandwich
	display_name = "plain sandwich"
	items = list(
		/obj/item/food/meatsteak,
		/obj/item/food/slice/bread = 2,
		/obj/item/food/cheesewedge,
	)
	result = /obj/item/food/sandwich

/decl/recipe/bigbiteburger
	items = list(
		/obj/item/food/burger,
		/obj/item/food/butchery/meat = 2,
		/obj/item/food/egg,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/food/bigbiteburger

/decl/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list(/decl/material/solid/sodiumchloride = 5, /decl/material/solid/blackpepper = 5)
	items = list(
		/obj/item/food/bigbiteburger,
		/obj/item/food/dough,
		/obj/item/food/butchery/meat,
		/obj/item/food/cheesewedge,
		/obj/item/food/boiledegg,
	)
	result = /obj/item/food/superbiteburger

/decl/recipe/twobread
	reagents = list(/decl/material/liquid/ethanol/wine = 5)
	items = list(
		/obj/item/food/slice/bread = 2,
	)
	result = /obj/item/food/twobread

/decl/recipe/taco
	items = list(
		/obj/item/food/doughslice,
		/obj/item/food/butchery/cutlet,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/taco
