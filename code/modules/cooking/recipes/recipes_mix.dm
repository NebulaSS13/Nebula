/decl/recipe/superbiteburger
	appliance = MIX|MICROWAVE
	fruit = list("tomato" = 1)
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 5, /decl/material/solid/blackpepper = 5)
	items = list(
		/obj/item/chems/food/snacks/bigbiteburger,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/boiledegg,
	)
	result = /obj/item/chems/food/snacks/superbiteburger

/decl/recipe/jellyburger
	appliance = MIX|MICROWAVE
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/jellyburger/cherry

/decl/recipe/twobread
	appliance = MIX|MICROWAVE // it's tradition, see
	reagents = list(/decl/material/liquid/ethanol/wine = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/twobread

/decl/recipe/threebread
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/twobread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/threebread

/decl/recipe/cherrysandwich
	appliance = MIX
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jellysandwich/cherry

/decl/recipe/tossedsalad
	appliance = MIX
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/chems/food/snacks/tossedsalad

/decl/recipe/aesirsalad
	appliance = MIX
	fruit = list("goldapple" = 1, "biteleafdeus" = 1)
	result = /obj/item/chems/food/snacks/aesirsalad

/decl/recipe/validsalad
	appliance = MIX
	fruit = list("potato" = 1, "biteleaf" = 3)
	items = list(/obj/item/chems/food/snacks/meatball)
	result = /obj/item/chems/food/snacks/validsalad

/decl/recipe/classichotdog
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/holder/corgi
	)
	result = /obj/item/chems/food/snacks/classichotdog

/decl/recipe/meatburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatburger

/decl/recipe/brainburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/chems/food/snacks/brainburger

/decl/recipe/roburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/chems/food/snacks/roburger

/decl/recipe/xenoburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/xenomeat
	)
	result = /obj/item/chems/food/snacks/xenoburger

/decl/recipe/fishburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishburger

/decl/recipe/tofuburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/tofu
	)
	result = /obj/item/chems/food/snacks/tofuburger

/decl/recipe/ghostburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/chems/food/snacks/ghostburger

/decl/recipe/clownburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/chems/food/snacks/clownburger

/decl/recipe/mimeburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/chems/food/snacks/mimeburger

/decl/recipe/bunbun
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/bunbun

/decl/recipe/hotdog
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/sausage
	)
	result = /obj/item/chems/food/snacks/hotdog

/decl/recipe/meatkabob
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatkabob

/decl/recipe/tofukabob
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/tofukabob

/decl/recipe/spellburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/meatburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/chems/food/snacks/spellburger

/decl/recipe/bigbiteburger
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/meatburger,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/egg,
	)
	result = /obj/item/chems/food/snacks/bigbiteburger

/decl/recipe/sandwich
	appliance = MICROWAVE|MIX
	items = list(
		/obj/item/chems/food/snacks/meatsteak,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sandwich

/decl/recipe/chazuke
	appliance = MIX|MICROWAVE|SAUCEPAN|POT // just stir it in a bowl, or heat it
	reagents = list(/decl/material/liquid/nutriment/rice/chazuke = 10)
	result = /obj/item/chems/food/snacks/boiledrice/chazuke

/decl/recipe/taco
	appliance = MIX|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/taco

/decl/recipe/pelmen
	appliance = MIX // uncooked
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/pelmen