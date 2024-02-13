// TODO: make all of these into handcrafted items
/decl/recipe/classichotdog
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/holder/corgi
	)
	result = /obj/item/chems/food/classichotdog

/decl/recipe/plainburger
	display_name = "plain burger"
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/chems/food/cutlet
	)
	result = /obj/item/chems/food/burger

/decl/recipe/brainburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/chems/food/brainburger

/decl/recipe/roburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/chems/food/roburger

/decl/recipe/xenoburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/chems/food/xenomeat
	)
	result = /obj/item/chems/food/xenoburger

/decl/recipe/fishburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/chems/food/fish
	)
	result = /obj/item/chems/food/fishburger

/decl/recipe/tofuburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/chems/food/tofu
	)
	result = /obj/item/chems/food/tofuburger

/decl/recipe/ghostburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/chems/food/ghostburger

/decl/recipe/clownburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/chems/food/clownburger

/decl/recipe/mimeburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/chems/food/mimeburger

/decl/recipe/bunbun
	items = list(
		/obj/item/chems/food/bun = 2
	)
	result = /obj/item/chems/food/bunbun

/decl/recipe/hotdog
	display_name = "plain hotdog"
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/chems/food/sausage
	)
	result = /obj/item/chems/food/hotdog

/decl/recipe/sandwich
	display_name = "plain sandwich"
	items = list(
		/obj/item/chems/food/meatsteak,
		/obj/item/chems/food/slice/bread = 2,
		/obj/item/chems/food/cheesewedge,
	)
	result = /obj/item/chems/food/sandwich

/decl/recipe/spellburger
	items = list(
		/obj/item/chems/food/burger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/chems/food/spellburger

/decl/recipe/bigbiteburger
	items = list(
		/obj/item/chems/food/burger,
		/obj/item/chems/food/meat = 2,
		/obj/item/chems/food/egg,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/bigbiteburger

/decl/recipe/threebread
	items = list(
		/obj/item/chems/food/twobread,
		/obj/item/chems/food/slice/bread,
	)
	result = /obj/item/chems/food/threebread

/decl/recipe/jellyburger
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/bun
	)
	result = /obj/item/chems/food/jellyburger/cherry

/decl/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list(/decl/material/solid/sodiumchloride = 5, /decl/material/solid/blackpepper = 5)
	items = list(
		/obj/item/chems/food/bigbiteburger,
		/obj/item/chems/food/dough,
		/obj/item/chems/food/meat,
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
		/obj/item/chems/food/cutlet,
		/obj/item/chems/food/cheesewedge
	)
	result = /obj/item/chems/food/taco

/decl/recipe/pelmen
	items = list(
		/obj/item/chems/food/doughslice = 2,
		/obj/item/chems/food/rawmeatball
	)
	result = /obj/item/chems/food/pelmen
