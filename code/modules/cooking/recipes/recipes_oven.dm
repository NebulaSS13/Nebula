
/decl/recipe/donkpocket
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/meatball
	)
	result = /obj/item/chems/food/snacks/donkpocket //SPECIAL

/decl/recipe/donkpocket/proc/warm_up(var/obj/item/chems/food/snacks/donkpocket/being_cooked)
	being_cooked.heat()

/decl/recipe/donkpocket/make_food(var/obj/container)
	var/obj/item/chems/food/snacks/donkpocket/being_cooked = ..(container)
	warm_up(being_cooked)
	return being_cooked

/decl/recipe/donkpocket/rawmeat
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/rawmeatball
	)

/decl/recipe/donkpocket/warm
	appliance = OVEN | MICROWAVE
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/chems/food/snacks/donkpocket
	)
	result = /obj/item/chems/food/snacks/donkpocket //SPECIAL

/decl/recipe/donkpocket/warm/make_food(var/obj/container)
	var/obj/item/chems/food/snacks/donkpocket/being_cooked = locate() in container
	if(being_cooked && !being_cooked.warm)
		warm_up(being_cooked)
	return being_cooked

/decl/recipe/meatbread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/meatbread

/decl/recipe/xenomeatbread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/xenomeat,
		/obj/item/chems/food/snacks/xenomeat,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/xenomeatbread

/decl/recipe/bananabread
	appliance = OVEN
	fruit = list("banana" = 2)
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
	)
	result = /obj/item/chems/food/snacks/sliceable/bananabread

/decl/recipe/muffin
	appliance = OVEN
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 10)
	result = /obj/item/chems/food/snacks/muffin

/decl/recipe/eggplantparm
	appliance = OVEN
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
		)
	result = /obj/item/chems/food/snacks/eggplantparm

/decl/recipe/pizzamargherita
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/margherita

/decl/recipe/meatpizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/meatpizza

/decl/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/mushroompizza

/decl/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza

/decl/recipe/spacylibertyduff
	appliance = OVEN
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/psychotropics = 5)
	result = /obj/item/chems/food/snacks/spacylibertyduff

/decl/recipe/cookie
	appliance = OVEN
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 5, /decl/material/liquid/nutriment/coco = 5)

	result = /obj/item/chems/food/snacks/cookie

/decl/recipe/fortunecookie
	appliance = OVEN
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/chems/food/snacks/fortunecookie

/decl/recipe/fortunecookie/make_food(obj/container)
	var/obj/item/paper/paper = locate() in container
	paper.loc = null //prevent deletion
	var/obj/item/chems/food/snacks/fortunecookie/being_cooked = ..(container)
	paper.forceMove(being_cooked)
	being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
	return being_cooked

/decl/recipe/fortunecookie/check_items(var/obj/container)
	. = ..()
	if(.)
		var/obj/item/paper/paper = locate() in container
		if(!paper || !paper.info)
			return FALSE

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
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/tofubread

/decl/recipe/meatpie
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatpie

/decl/recipe/tofupie
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/tofupie

/decl/recipe/xemeatpie
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/xenomeat,
	)
	result = /obj/item/chems/food/snacks/xemeatpie

/decl/recipe/bananapie
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/bananapie

/decl/recipe/cherrypie
	appliance = OVEN
	fruit = list("cherries" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 10)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/chems/food/snacks/cherrypie

/decl/recipe/berryclafoutis
	appliance = OVEN
	fruit = list("berries" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/chems/food/snacks/berryclafoutis

/decl/recipe/chaosdonut
	appliance = OVEN
	reagents = list(/decl/material/liquid/frostoil = 5, /decl/material/liquid/capsaicin = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/chaos

/decl/recipe/amanita_pie
	appliance = OVEN
	reagents = list(/decl/material/liquid/amatoxin = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/amanita_pie

/decl/recipe/plump_pie
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/plump_pie

/decl/recipe/enchiladas
	appliance = OVEN|FRYER
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/enchiladas

/decl/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/creamcheesebread

/decl/recipe/monkeysdelight
	appliance = OVEN|MICROWAVE
	fruit = list("banana" = 1)
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1, /decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/monkeycube
	)
	result = /obj/item/chems/food/snacks/monkeysdelight

/decl/recipe/baguette
	appliance = OVEN
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
	)
	result = /obj/item/chems/food/snacks/baguette

/decl/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/bun

/decl/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough
	)
	result = /obj/item/chems/food/snacks/flatbread

/decl/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough
	)
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1)
	result = /obj/item/chems/food/snacks/sliceable/bread

/decl/recipe/poppypretzel
	appliance = OVEN
	fruit = list("poppy" = 1)
	items = list(/obj/item/chems/food/snacks/dough)
	result = /obj/item/chems/food/snacks/poppypretzel

/decl/recipe/applepie
	appliance = OVEN
	fruit = list("apple" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/applepie

/decl/recipe/pumpkinpie
	appliance = OVEN
	fruit = list("pumpkin" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/sliceable/pumpkinpie

/decl/recipe/plumphelmetbiscuit
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/snacks/plumphelmetbiscuit

/decl/recipe/plumphelmetbiscuitvegan
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/plumphelmetbiscuit

/decl/recipe/cracker
	appliance = OVEN
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/doughslice
	)
	result = /obj/item/chems/food/snacks/cracker

/decl/recipe/stuffing
	appliance = OVEN
	reagents = list(/decl/material/liquid/water = 10, /decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/bread,
	)
	result = /obj/item/chems/food/snacks/stuffing

/decl/recipe/tofurkey
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/stuffing,
	)
	result = /obj/item/chems/food/snacks/tofurkey

/decl/recipe/jellydonut
	appliance = OVEN
	reagents = list(/decl/material/liquid/drink/juice/berry = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/jelly

/decl/recipe/jellydonut/cherry
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/cherryjelly

/decl/recipe/donut
	appliance = OVEN
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/normal

/decl/recipe/appletart
	appliance = OVEN
	fruit = list("goldapple" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/appletart

// Cakes.
/decl/recipe/cake
	appliance = OVEN
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 60)
	result = /obj/item/chems/food/snacks/sliceable/plaincake

/decl/recipe/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/chems/food/snacks/sliceable/carrotcake

/decl/recipe/cake/cheese
	items = list(
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/cheesecake

/decl/recipe/cake/orange
	fruit = list("orange" = 1)
	result = /obj/item/chems/food/snacks/sliceable/orangecake

/decl/recipe/cake/lime
	fruit = list("lime" = 1)
	result = /obj/item/chems/food/snacks/sliceable/limecake

/decl/recipe/cake/lemon
	fruit = list("lemon" = 1)
	result = /obj/item/chems/food/snacks/sliceable/lemoncake

/decl/recipe/cake/chocolate
	items = list(/obj/item/chems/food/snacks/chocolatebar)
	result = /obj/item/chems/food/snacks/sliceable/chocolatecake

/decl/recipe/cake/birthday
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 60, /decl/material/liquid/nutriment/sprinkles = 10)
	result = /obj/item/chems/food/snacks/sliceable/birthdaycake

/decl/recipe/cake/apple
	fruit = list("apple" = 2)
	result = /obj/item/chems/food/snacks/sliceable/applecake

/decl/recipe/cake/brain
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/chems/food/snacks/sliceable/braincake

/decl/recipe/cake/chocolatebar
	reagents = list(/decl/material/liquid/drink/milk/chocolate = 10, /decl/material/liquid/nutriment/coco = 5, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/snacks/chocolatebar