/decl/recipe/pizzamargherita
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
		/obj/item/chems/food/cheesewedge = 3,
	)
	result = /obj/item/chems/food/sliceable/pizza/margherita

/decl/recipe/meatpizza
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
		/obj/item/chems/food/cutlet = 2,
		/obj/item/chems/food/cheesewedge
	)
	result = /obj/item/chems/food/sliceable/pizza/meatpizza

/decl/recipe/mushroompizza
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
		/obj/item/chems/food/cheesewedge
	)
	result = /obj/item/chems/food/sliceable/pizza/mushroompizza

/decl/recipe/vegetablepizza
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
		/obj/item/chems/food/cheesewedge
	)
	result = /obj/item/chems/food/sliceable/pizza/vegetablepizza

/decl/recipe/amanita_pie
	reagents = list(/decl/material/liquid/amatoxin = 5)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	result = /obj/item/chems/food/amanita_pie

/decl/recipe/plump_pie
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	result = /obj/item/chems/food/plump_pie

/decl/recipe/applepie
	fruit = list("apple" = 1)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	result = /obj/item/chems/food/applepie

/decl/recipe/pumpkinpie
	fruit = list("pumpkin" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/chems/food/sliceable/pumpkinpie

/decl/recipe/meatpie
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
		/obj/item/chems/food/cutlet
	)
	result = /obj/item/chems/food/meatpie

/decl/recipe/tofupie
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
		/obj/item/chems/food/tofu,
	)
	result = /obj/item/chems/food/tofupie

/decl/recipe/xemeatpie
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
		/obj/item/chems/food/xenomeat,
	)
	result = /obj/item/chems/food/xemeatpie

/decl/recipe/bananapie
	fruit = list("banana" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	result = /obj/item/chems/food/bananapie

/decl/recipe/cherrypie
	fruit = list("cherries" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 10)
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
	)
	result = /obj/item/chems/food/cherrypie

/decl/recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
		/obj/item/chems/food/sliceable/flatdough,
	)
	result = /obj/item/chems/food/berryclafoutis

/decl/recipe/chaosdonut
	reagents = list(/decl/material/liquid/frostoil = 5, /decl/material/liquid/capsaicin = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/donut/chaos

/decl/recipe/donut
	display_name = "Plain Donut"
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/donut

/decl/recipe/donut/jelly
	display_name = "Berry Jelly Donut"
	reagents = list(/decl/material/liquid/drink/juice/berry = 5, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/donut/jelly

/decl/recipe/donut/jelly/cherry
	display_name = "Cherry Jelly Donut"
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5, /decl/material/liquid/nutriment/sugar = 5)

/decl/recipe/meatbread
	display_name = "plain meatbread loaf"
	items = list(
		/obj/item/chems/food/dough = 2,
		/obj/item/chems/food/cutlet = 2,
		/obj/item/chems/food/cheesewedge = 2,
	)
	result = /obj/item/chems/food/sliceable/meatbread

/decl/recipe/xenomeatbread
	items = list(
		/obj/item/chems/food/dough = 2,
		/obj/item/chems/food/xenomeat = 2,
		/obj/item/chems/food/cheesewedge = 2,
	)
	result = /obj/item/chems/food/sliceable/xenomeatbread

/decl/recipe/bananabread
	fruit = list("banana" = 2)
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough = 2,
	)
	result = /obj/item/chems/food/sliceable/bananabread

/decl/recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/chems/food/soylenviridians

/decl/recipe/soylentgreen
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/meat/human = 2
	)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/chems/food/soylentgreen

/decl/recipe/tofubread
	items = list(
		/obj/item/chems/food/dough = 3,
		/obj/item/chems/food/tofu = 3,
		/obj/item/chems/food/cheesewedge = 3,
	)
	result = /obj/item/chems/food/sliceable/tofubread

/decl/recipe/loadedbakedpotato
	fruit = list("potato" = 1)
	items = list(/obj/item/chems/food/cheesewedge)
	result = /obj/item/chems/food/loadedbakedpotato

/decl/recipe/cheesyfries
	items = list(
		/obj/item/chems/food/fries,
		/obj/item/chems/food/cheesewedge,
	)
	result = /obj/item/chems/food/cheesyfries

/decl/recipe/cookie
	display_name = "plain cookie"
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 5, /decl/material/liquid/nutriment/coco = 5)
	reagent_mix = REAGENT_REPLACE // no raw batter
	result = /obj/item/chems/food/cookie

/decl/recipe/fortunecookie
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/chems/food/fortunecookie

/decl/recipe/fortunecookie/produce_result(obj/container)
	var/obj/item/paper/paper = locate() in container
	paper.forceMove(null) //prevent deletion
	var/obj/item/chems/food/fortunecookie/being_cooked = ..(container)
	paper.forceMove(being_cooked)
	being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
	return being_cooked

/decl/recipe/fortunecookie/check_items(var/obj/container)
	. = ..()
	if(.)
		var/obj/item/paper/paper = locate() in container
		if(!paper || !paper.info)
			return FALSE

/decl/recipe/muffin
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 10)
	result = /obj/item/chems/food/muffin

/decl/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/chems/food/cheesewedge = 2
		)
	result = /obj/item/chems/food/eggplantparm

/decl/recipe/enchiladas
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/enchiladas

/decl/recipe/creamcheesebread
	items = list(
		/obj/item/chems/food/dough = 2,
		/obj/item/chems/food/cheesewedge = 2,
	)
	result = /obj/item/chems/food/sliceable/creamcheesebread

/decl/recipe/monkeysdelight
	fruit = list("banana" = 1)
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1, /decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/monkeycube
	)
	result = /obj/item/chems/food/monkeysdelight

/decl/recipe/baguette
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/dough = 2,
	)
	result = /obj/item/chems/food/baguette

/decl/recipe/bread
	display_name = "loaf of bread"
	items = list(
		/obj/item/chems/food/dough = 2,
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg/flour
	result = /obj/item/chems/food/sliceable/bread

/decl/recipe/jelliedtoast
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread,
	)
	result = /obj/item/chems/food/jelliedtoast/cherry

/decl/recipe/rofflewaffles
	reagents = list(/decl/material/liquid/psychotropics = 5, /decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/rofflewaffles

/decl/recipe/poppypretzel
	fruit = list("poppy" = 1)
	items = list(/obj/item/chems/food/dough)
	result = /obj/item/chems/food/poppypretzel

/decl/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/plumphelmetbiscuit

/decl/recipe/plumphelmetbiscuitvegan
	display_name = "Vegan Plump Biscuit"
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	result = /obj/item/chems/food/plumphelmetbiscuit

/decl/recipe/appletart
	fruit = list("goldapple" = 1)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/chems/food/appletart

/decl/recipe/cracker
	reagents = list(/decl/material/solid/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/doughslice
	)
	result = /obj/item/chems/food/cracker

/decl/recipe/tofurkey
	items = list(
		/obj/item/chems/food/tofu = 2,
		/obj/item/chems/food/stuffing,
	)
	result = /obj/item/chems/food/tofurkey

/decl/recipe/bun
	display_name = "plain bun"
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/bun

/decl/recipe/flatbread
	items = list(
		/obj/item/chems/food/sliceable/flatdough
	)
	result = /obj/item/chems/food/flatbread

/decl/recipe/cake
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 60)
	reagent_mix = REAGENT_REPLACE // no raw batter
	result = /obj/item/chems/food/sliceable/plaincake

/decl/recipe/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/chems/food/sliceable/carrotcake

/decl/recipe/cake/cheese
	items = list(
		/obj/item/chems/food/cheesewedge = 2
	)
	result = /obj/item/chems/food/sliceable/cheesecake

/decl/recipe/cake/orange
	fruit = list("orange" = 1)
	result = /obj/item/chems/food/sliceable/orangecake

/decl/recipe/cake/lime
	fruit = list("lime" = 1)
	result = /obj/item/chems/food/sliceable/limecake

/decl/recipe/cake/lemon
	fruit = list("lemon" = 1)
	result = /obj/item/chems/food/sliceable/lemoncake

/decl/recipe/cake/chocolate
	items = list(/obj/item/chems/food/chocolatebar)
	result = /obj/item/chems/food/sliceable/chocolatecake

/decl/recipe/cake/birthday
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 60, /decl/material/liquid/nutriment/sprinkles = 10)
	result = /obj/item/chems/food/sliceable/birthdaycake

/decl/recipe/cake/apple
	fruit = list("apple" = 2)
	result = /obj/item/chems/food/sliceable/applecake

/decl/recipe/cake/brain
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/chems/food/sliceable/braincake
