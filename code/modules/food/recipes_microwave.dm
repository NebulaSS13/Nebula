
// see code/datums/recipe.dm


/* No telebacon. just no...
/decl/recipe/telebacon
	items = list(
		/obj/item/chems/food/meat,
		/obj/item/assembly/signaler
	)
	result = /obj/item/chems/food/telebacon

I said no!
/decl/recipe/syntitelebacon
	items = list(
		/obj/item/chems/food/meat/syntiflesh,
		/obj/item/assembly/signaler
	)
	result = /obj/item/chems/food/telebacon
*/

/decl/recipe/friedegg
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/friedegg

/decl/recipe/boiledegg
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg or water
	result = /obj/item/chems/food/boiledegg

/decl/recipe/classichotdog
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/holder/corgi
	)
	result = /obj/item/chems/food/classichotdog

/decl/recipe/jellydonut
	reagents = list(/decl/material/liquid/drink/juice/berry = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/donut/jelly

/decl/recipe/jellydonut/cherry
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/donut/cherryjelly

/decl/recipe/donut
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/donut/normal

/decl/recipe/meatburger
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/chems/food/cutlet
	)
	result = /obj/item/chems/food/meatburger

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
	items = list(
		/obj/item/chems/food/bun,
		/obj/item/chems/food/sausage
	)
	result = /obj/item/chems/food/hotdog

/decl/recipe/waffles
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/waffles

/decl/recipe/pancakesblu
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	fruit = list("blueberries" = 2)
	result = /obj/item/chems/food/pancakesblu

/decl/recipe/pancakes
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	result = /obj/item/chems/food/pancakes

/decl/recipe/donkpocket
	items = list(
		/obj/item/chems/food/doughslice,
		/obj/item/chems/food/meatball
	)
	result = /obj/item/chems/food/donkpocket //SPECIAL

/decl/recipe/donkpocket/proc/warm_up(var/obj/item/chems/food/donkpocket/being_cooked)
	being_cooked.heat()

/decl/recipe/donkpocket/make_food(var/obj/container)
	. = ..(container)
	for(var/obj/item/chems/food/donkpocket/being_cooked in .)
		warm_up(being_cooked)

/decl/recipe/donkpocket/rawmeatball
	items = list(
		/obj/item/chems/food/doughslice,
		/obj/item/chems/food/rawmeatball
	)

/decl/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/chems/food/donkpocket
	)
	result = /obj/item/chems/food/donkpocket //SPECIAL

/decl/recipe/donkpocket/warm/check_items(obj/container)
	. = ..()
	if(!.)
		return FALSE
	for(var/obj/item/chems/food/donkpocket/being_cooked in container.get_contained_external_atoms())
		if(!being_cooked.warm)
			return TRUE
	return FALSE

/decl/recipe/donkpocket/warm/make_food(var/obj/container)
	for(var/obj/item/chems/food/donkpocket/being_cooked in container.get_contained_external_atoms())
		if(!being_cooked.warm)
			warm_up(being_cooked)
			return list(being_cooked)

/decl/recipe/meatbread
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

/decl/recipe/omelette
	items = list(
		/obj/item/chems/food/egg = 2,
		/obj/item/chems/food/cheesewedge,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/omelette

/decl/recipe/muffin
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 10)
	result = /obj/item/chems/food/muffin

/decl/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/chems/food/cheesewedge = 2
		)
	result = /obj/item/chems/food/eggplantparm

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

/decl/recipe/meatkabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/cutlet = 2
	)
	result = /obj/item/chems/food/meatkabob

/decl/recipe/tofukabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/tofu = 2,
	)
	result = /obj/item/chems/food/tofukabob

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

/decl/recipe/cubancarp
	fruit = list("chili" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	items = list(
		/obj/item/chems/food/fish
	)
	result = /obj/item/chems/food/cubancarp

/decl/recipe/popcorn
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 5)
	fruit = list("corn" = 1)
	result = /obj/item/chems/food/popcorn

/decl/recipe/cookie
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

/decl/recipe/fortunecookie/make_food(obj/container)
	var/obj/item/paper/paper = locate() in container
	paper.loc = null //prevent deletion
	var/obj/item/chems/food/fortunecookie/being_cooked = ..(container)
	paper.loc = being_cooked
	being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
	return being_cooked

/decl/recipe/fortunecookie/check_items(var/obj/container)
	. = ..()
	if(.)
		var/obj/item/paper/paper = locate() in container
		if(!paper || !paper.info)
			return FALSE

/decl/recipe/plainsteak
	items = list(/obj/item/chems/food/meat)
	result = /obj/item/chems/food/plainsteak

/decl/recipe/meatsteak
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/meatsteak

/decl/recipe/loadedsteak
	reagents = list(/decl/material/liquid/nutriment/garlicsauce = 5)
	fruit = list("onion" = 1, "mushroom" = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/loadedsteak

/decl/recipe/syntisteak
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/meat/syntiflesh)
	result = /obj/item/chems/food/meatsteak/synthetic

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

/decl/recipe/spacylibertyduff
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/psychotropics = 5)
	result = /obj/item/chems/food/spacylibertyduff

/decl/recipe/amanitajelly
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/amatoxin = 5)
	result = /obj/item/chems/food/amanitajelly

/decl/recipe/amanitajelly/make_food(var/obj/container)
	var/obj/item/chems/food/amanitajelly/being_cooked = ..(container)
	being_cooked.reagents.clear_reagent(/decl/material/liquid/amatoxin)
	return being_cooked

/decl/recipe/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/meatball)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result = /obj/item/chems/food/meatballsoup

/decl/recipe/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result = /obj/item/chems/food/vegetablesoup

/decl/recipe/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // Remove extra water and egg
	result = /obj/item/chems/food/nettlesoup

/decl/recipe/wishsoup
	reagents = list(/decl/material/liquid/water = 20)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result= /obj/item/chems/food/wishsoup

/decl/recipe/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/hotchili

/decl/recipe/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/coldchili

/decl/recipe/amanita_pie
	reagents = list(/decl/material/liquid/amatoxin = 5)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	result = /obj/item/chems/food/amanita_pie

/decl/recipe/plump_pie
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	result = /obj/item/chems/food/plump_pie

/decl/recipe/spellburger
	items = list(
		/obj/item/chems/food/meatburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/chems/food/spellburger

/decl/recipe/bigbiteburger
	items = list(
		/obj/item/chems/food/meatburger,
		/obj/item/chems/food/meat = 2,
		/obj/item/chems/food/egg,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/bigbiteburger

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
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1, /decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/monkeycube
	)
	result = /obj/item/chems/food/monkeysdelight

/decl/recipe/baguette
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/dough = 2,
	)
	result = /obj/item/chems/food/baguette

/decl/recipe/fishandchips
	items = list(
		/obj/item/chems/food/fries,
		/obj/item/chems/food/fish
	)
	result = /obj/item/chems/food/fishandchips

/decl/recipe/bread
	items = list(
		/obj/item/chems/food/dough = 2,
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg/flour
	result = /obj/item/chems/food/sliceable/bread

/decl/recipe/sandwich
	items = list(
		/obj/item/chems/food/meatsteak,
		/obj/item/chems/food/slice/bread = 2,
		/obj/item/chems/food/cheesewedge,
	)
	result = /obj/item/chems/food/sandwich

/decl/recipe/toastedsandwich
	items = list(
		/obj/item/chems/food/sandwich
	)
	result = /obj/item/chems/food/toastedsandwich

/decl/recipe/grilledcheese
	items = list(
		/obj/item/chems/food/slice/bread = 2,
		/obj/item/chems/food/cheesewedge,
	)
	result = /obj/item/chems/food/grilledcheese

/decl/recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/tomatosoup

/decl/recipe/rofflewaffles
	reagents = list(/decl/material/liquid/psychotropics = 5, /decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/rofflewaffles

/decl/recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/meat)
	result = /obj/item/chems/food/stew

/decl/recipe/jelliedtoast
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread,
	)
	result = /obj/item/chems/food/jelliedtoast/cherry

/decl/recipe/milosoup
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/soydope = 2,
		/obj/item/chems/food/tofu = 2,
	)
	result = /obj/item/chems/food/milosoup

/decl/recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/soydope = 2
	)
	result = /obj/item/chems/food/stewedsoymeat

/decl/recipe/boiledspagetti
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
	)
	result = /obj/item/chems/food/boiledspagetti

/decl/recipe/boiledrice
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/boiledrice

/decl/recipe/chazuke
	reagents = list(/decl/material/liquid/nutriment/rice/chazuke = 10)
	result = /obj/item/chems/food/boiledrice/chazuke

/decl/recipe/katsucurry
	fruit = list("apple" = 1, "carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10, /decl/material/liquid/nutriment/flour = 5)
	items = list(
		/obj/item/chems/food/meat/chicken
	)
	result = /obj/item/chems/food/katsucurry

/decl/recipe/ricepudding
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/ricepudding

/decl/recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/spagetti)
	result = /obj/item/chems/food/pastatomato

/decl/recipe/poppypretzel
	fruit = list("poppy" = 1)
	items = list(/obj/item/chems/food/dough)
	result = /obj/item/chems/food/poppypretzel

/decl/recipe/meatballspagetti
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/chems/food/meatball = 2,
	)
	result = /obj/item/chems/food/meatballspagetti

/decl/recipe/spesslaw
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/chems/food/meatball = 4,
	)
	result = /obj/item/chems/food/spesslaw

/decl/recipe/nanopasta
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
		/obj/item/stack/nanopaste
	)
	result = /obj/item/chems/food/nanopasta

/decl/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 5, /decl/material/solid/blackpepper = 5)
	items = list(
		/obj/item/chems/food/bigbiteburger,
		/obj/item/chems/food/dough,
		/obj/item/chems/food/meat,
		/obj/item/chems/food/cheesewedge,
		/obj/item/chems/food/boiledegg,
	)
	result = /obj/item/chems/food/superbiteburger

/decl/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/candiedapple

/decl/recipe/applepie
	fruit = list("apple" = 1)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	result = /obj/item/chems/food/applepie

/decl/recipe/jellyburger
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/bun
	)
	result = /obj/item/chems/food/jellyburger/cherry

/decl/recipe/twobread
	reagents = list(/decl/material/liquid/ethanol/wine = 5)
	items = list(
		/obj/item/chems/food/slice/bread = 2,
	)
	result = /obj/item/chems/food/twobread

/decl/recipe/threebread
	items = list(
		/obj/item/chems/food/twobread,
		/obj/item/chems/food/slice/bread,
	)
	result = /obj/item/chems/food/threebread

/decl/recipe/cherrysandwich
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread = 2,
	)
	result = /obj/item/chems/food/jellysandwich/cherry

/decl/recipe/bloodsoup
	reagents = list(/decl/material/liquid/blood = 30)
	result = /obj/item/chems/food/bloodsoup

/decl/recipe/chocolateegg
	items = list(
		/obj/item/chems/food/egg,
		/obj/item/chems/food/chocolatebar,
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/chocolateegg

/decl/recipe/sausage
	items = list(
		/obj/item/chems/food/rawmeatball,
		/obj/item/chems/food/rawcutlet,
	)
	result = /obj/item/chems/food/sausage

/decl/recipe/fatsausage
	reagents = list(/decl/material/solid/blackpepper = 2)
	items = list(
		/obj/item/chems/food/rawmeatball,
		/obj/item/chems/food/rawcutlet,
	)
	result = /obj/item/chems/food/fatsausage

/decl/recipe/fishfingers
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/egg,
		/obj/item/chems/food/fish
	)
	reagent_mix = REAGENT_REPLACE // no raw egg/fish
	result = /obj/item/chems/food/fishfingers

/decl/recipe/mysterysoup
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/badrecipe,
		/obj/item/chems/food/tofu,
		/obj/item/chems/food/egg,
		/obj/item/chems/food/cheesewedge,
	)
	reagent_mix = REAGENT_REPLACE // Has its own special products
	result = /obj/item/chems/food/mysterysoup

/decl/recipe/pumpkinpie
	fruit = list("pumpkin" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/chems/food/sliceable/pumpkinpie

/decl/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/plumphelmetbiscuit

/decl/recipe/plumphelmetbiscuitvegan
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	result = /obj/item/chems/food/plumphelmetbiscuit

/decl/recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/drink/milk = 10)
	reagent_mix = REAGENT_REPLACE // get that milk outta here
	result = /obj/item/chems/food/mushroomsoup

/decl/recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/soysauce = 5)
	items = list(
		/obj/item/chems/food/egg = 2
	)
	reagent_mix = REAGENT_REPLACE // no raw egg
	result = /obj/item/chems/food/chawanmushi

/decl/recipe/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/beetsoup

/decl/recipe/appletart
	fruit = list("goldapple" = 1)
	items = list(/obj/item/chems/food/sliceable/flatdough)
	reagent_mix = REAGENT_REPLACE // no raw flour
	result = /obj/item/chems/food/appletart

/decl/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/chems/food/tossedsalad

/decl/recipe/aesirsalad
	fruit = list("goldapple" = 1, "biteleafdeus" = 1)
	result = /obj/item/chems/food/aesirsalad

/decl/recipe/validsalad
	fruit = list("potato" = 1, "biteleaf" = 3)
	items = list(/obj/item/chems/food/meatball)
	result = /obj/item/chems/food/validsalad

/decl/recipe/cracker
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/doughslice
	)
	result = /obj/item/chems/food/cracker

/decl/recipe/stuffing
	reagents = list(/decl/material/liquid/water = 10, /decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/sliceable/bread,
	)
	result = /obj/item/chems/food/stuffing

/decl/recipe/tofurkey
	items = list(
		/obj/item/chems/food/tofu = 2,
		/obj/item/chems/food/stuffing,
	)
	result = /obj/item/chems/food/tofurkey

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/decl/recipe/taco
	items = list(
		/obj/item/chems/food/doughslice,
		/obj/item/chems/food/cutlet,
		/obj/item/chems/food/cheesewedge
	)
	result = /obj/item/chems/food/taco

/decl/recipe/bun
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/bun

/decl/recipe/flatbread
	items = list(
		/obj/item/chems/food/sliceable/flatdough
	)
	result = /obj/item/chems/food/flatbread

/decl/recipe/meatball
	items = list(
		/obj/item/chems/food/rawmeatball
	)
	result = /obj/item/chems/food/meatball

/decl/recipe/cutlet
	items = list(
		/obj/item/chems/food/rawcutlet
	)
	result = /obj/item/chems/food/cutlet

/decl/recipe/fries
	items = list(
		/obj/item/chems/food/rawsticks
	)
	result = /obj/item/chems/food/fries

/decl/recipe/onionrings
	fruit = list("onion" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/onionrings

/decl/recipe/mint
	reagents = list(/decl/material/liquid/nutriment/sugar = 5, /decl/material/liquid/frostoil = 5)
	result = /obj/item/chems/food/mint

// Cakes.
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

/decl/recipe/cake/chocolatebar
	reagents = list(/decl/material/liquid/drink/milk/chocolate = 10, /decl/material/liquid/nutriment/coco = 5, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/chocolatebar

/decl/recipe/boiledspiderleg
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spider
	)
	result = /obj/item/chems/food/spider/cooked

/decl/recipe/pelmen
	items = list(
		/obj/item/chems/food/doughslice = 2,
		/obj/item/chems/food/rawmeatball
	)
	result = /obj/item/chems/food/pelmen

/decl/recipe/pelmeni_boiled
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/pelmen = 5
	)
	result = /obj/item/chems/food/pelmeni_boiled
