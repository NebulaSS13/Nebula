/decl/recipe/baked
	abstract_type = /decl/recipe/baked
	//cooking_heat_type = COOKING_HEAT_INDIRECT

/decl/recipe/baked/pizzamargherita
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge = 3,
	)
	result = /obj/item/food/sliceable/pizza/margherita

/decl/recipe/baked/meatpizza
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/butchery/cutlet = 2,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/pizza/meatpizza

/decl/recipe/baked/mushroompizza
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/pizza/mushroompizza

/decl/recipe/baked/vegetablepizza
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/pizza/vegetablepizza

/decl/recipe/baked/amanita_pie
	reagents = list(/decl/material/liquid/amatoxin = 5)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/amanita_pie

/decl/recipe/baked/pumpkinpie
	fruit = list("pumpkin" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/food/sliceable/flatdough)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/food/sliceable/pumpkinpie

/decl/recipe/baked/bananapie
	fruit = list("banana" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/bananapie

/decl/recipe/baked/cherrypie
	fruit = list("cherries" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 10)
	items = list(
		/obj/item/food/sliceable/flatdough,
	)
	result = /obj/item/food/cherrypie

/decl/recipe/baked/chaosdonut
	reagents = list(/decl/material/liquid/frostoil = 5, /decl/material/liquid/capsaicin = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/food/dough
	)
	result = /obj/item/food/donut/chaos

/decl/recipe/baked/donut
	display_name = "plain donut"
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/food/dough
	)
	result = /obj/item/food/donut

/decl/recipe/baked/donut/jelly
	display_name = "berry jelly donut"
	reagents = list(/decl/material/liquid/drink/juice/berry = 5, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/food/donut/jelly

/decl/recipe/baked/donut/jelly/cherry
	display_name = "cherry jelly donut"
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5, /decl/material/liquid/nutriment/sugar = 5)

/decl/recipe/baked/meatbread
	display_name = "plain meatbread loaf"
	items = list(
		/obj/item/food/dough = 2,
		/obj/item/food/butchery/cutlet = 2,
		/obj/item/food/cheesewedge = 2,
	)
	result = /obj/item/food/sliceable/meatbread

/decl/recipe/baked/xenomeatbread
	items = list(
		/obj/item/food/dough = 2,
		/obj/item/food/xenomeat = 2,
		/obj/item/food/cheesewedge = 2,
	)
	result = /obj/item/food/sliceable/xenomeatbread

/decl/recipe/baked/bananabread
	fruit = list("banana" = 2)
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/food/dough = 2,
	)
	result = /obj/item/food/sliceable/bananabread

/decl/recipe/baked/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/food/soylenviridians

/decl/recipe/baked/soylentgreen
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/food/butchery/meat/human = 2
	)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/food/soylentgreen

/decl/recipe/baked/tofubread
	items = list(
		/obj/item/food/dough = 3,
		/obj/item/food/tofu = 3,
		/obj/item/food/cheesewedge = 3,
	)
	result = /obj/item/food/sliceable/tofubread

/decl/recipe/baked/cookie
	display_name = "plain cookie"
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 5, /decl/material/liquid/nutriment/coco = 5)
	reagent_mix = REAGENT_REPLACE // no raw batter
	result = /obj/item/food/cookie

/decl/recipe/baked/fortunecookie
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/food/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/food/fortunecookie

/decl/recipe/baked/fortunecookie/produce_result(obj/container)
	var/obj/item/paper/paper = locate() in container
	paper.forceMove(null) //prevent deletion
	var/obj/item/food/fortunecookie/being_cooked = ..(container)
	paper.forceMove(being_cooked)
	being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
	return being_cooked

/decl/recipe/baked/fortunecookie/check_items(var/obj/container)
	. = ..()
	if(.)
		var/obj/item/paper/paper = locate() in container
		if(!paper || !paper.info)
			return FALSE

/decl/recipe/baked/muffin
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 10)
	result = /obj/item/food/muffin

/decl/recipe/baked/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/food/cheesewedge = 2
		)
	result = /obj/item/food/eggplantparm

/decl/recipe/baked/enchiladas
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/food/butchery/cutlet)
	result = /obj/item/food/enchiladas

/decl/recipe/baked/creamcheesebread
	items = list(
		/obj/item/food/dough = 2,
		/obj/item/food/cheesewedge = 2,
	)
	result = /obj/item/food/sliceable/creamcheesebread

/decl/recipe/baked/monkeysdelight
	fruit = list("banana" = 1)
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1, /decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/food/monkeycube
	)
	result = /obj/item/food/monkeysdelight

/decl/recipe/baked/baguette
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/food/dough = 2,
	)
	result = /obj/item/food/baguette

/decl/recipe/baked/bread
	display_name = "loaf of bread"
	items = list(
		/obj/item/food/dough = 2,
		/obj/item/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg/flour
	result = /obj/item/food/sliceable/bread

/decl/recipe/baked/jelliedtoast
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/food/slice/bread,
	)
	result = /obj/item/food/jelliedtoast/cherry

/decl/recipe/baked/rofflewaffles
	reagents = list(/decl/material/liquid/psychotropics = 5, /decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/food/rofflewaffles

/decl/recipe/baked/poppypretzel
	fruit = list("poppy" = 1)
	items = list(/obj/item/food/dough)
	result = /obj/item/food/poppypretzel

/decl/recipe/baked/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/food/plumphelmetbiscuit

/decl/recipe/baked/plumphelmetbiscuitvegan
	display_name = "vegan plump biscuit"
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	result = /obj/item/food/plumphelmetbiscuit

/decl/recipe/baked/appletart
	fruit = list("goldapple" = 1)
	items = list(/obj/item/food/sliceable/flatdough)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/food/appletart

/decl/recipe/baked/cracker
	reagents = list(/decl/material/solid/sodiumchloride = 1)
	items = list(
		/obj/item/food/doughslice
	)
	result = /obj/item/food/cracker

/decl/recipe/baked/tofurkey
	items = list(
		/obj/item/food/tofu = 2,
		/obj/item/food/stuffing,
	)
	result = /obj/item/food/tofurkey

/decl/recipe/baked/bun
	display_name = "plain bun"
	items = list(
		/obj/item/food/dough
	)
	result = /obj/item/food/bun

/decl/recipe/baked/flatbread
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/flatbread

/decl/recipe/baked/cake
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 60)
	reagent_mix = REAGENT_REPLACE // no raw batter
	result = /obj/item/food/sliceable/plaincake

/decl/recipe/baked/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/food/sliceable/carrotcake

/decl/recipe/baked/cake/cheese
	items = list(
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/sliceable/cheesecake

/decl/recipe/baked/cake/orange
	fruit = list("orange" = 1)
	result = /obj/item/food/sliceable/orangecake

/decl/recipe/baked/cake/lime
	fruit = list("lime" = 1)
	result = /obj/item/food/sliceable/limecake

/decl/recipe/baked/cake/lemon
	fruit = list("lemon" = 1)
	result = /obj/item/food/sliceable/lemoncake

/decl/recipe/baked/cake/chocolate
	items = list(/obj/item/food/chocolatebar)
	result = /obj/item/food/sliceable/chocolatecake

/decl/recipe/baked/cake/birthday
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 60, /decl/material/liquid/nutriment/sprinkles = 10)
	result = /obj/item/food/sliceable/birthdaycake

/decl/recipe/baked/cake/apple
	fruit = list("apple" = 2)
	result = /obj/item/food/sliceable/applecake

/decl/recipe/baked/cake/brain
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/food/sliceable/braincake

// Stub recipes for cooking pies.
/decl/recipe/baked/meatpie
	items  = list(/obj/item/food/meatpie/raw)
	result = /obj/item/food/meatpie
/decl/recipe/baked/tofupie
	items  = list(/obj/item/food/tofupie/raw)
	result = /obj/item/food/tofupie
/decl/recipe/baked/xemeatpie
	items  = list(/obj/item/food/xemeatpie/raw)
	result = /obj/item/food/xemeatpie
/decl/recipe/baked/applepie
	items  = list(/obj/item/food/applepie/raw)
	result = /obj/item/food/applepie
/decl/recipe/baked/berryclafoutis
	items  = list(/obj/item/food/berryclafoutis/raw)
	result = /obj/item/food/berryclafoutis
/decl/recipe/baked/plump_pie
	items  = list(/obj/item/food/plump_pie/raw)
	result = /obj/item/food/plump_pie
/decl/recipe/baked/loadedbakedpotato
	items  = list(/obj/item/food/loadedbakedpotato/raw)
	result = /obj/item/food/loadedbakedpotato
/decl/recipe/baked/cheesyfries
	items  = list(/obj/item/food/cheesyfries/uncooked)
	result = /obj/item/food/cheesyfries
