
// see code/datums/recipe.dm


/* No telebacon. just no...
/datum/recipe/telebacon
	items = list(
		/obj/item/chems/food/snacks/meat,
		/obj/item/assembly/signaler
	)
	result = /obj/item/chems/food/snacks/telebacon

I said no!
/datum/recipe/syntitelebacon
	items = list(
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/assembly/signaler
	)
	result = /obj/item/chems/food/snacks/telebacon
*/

/datum/recipe/friedegg
	reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/friedegg

/datum/recipe/friedegg2
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg,
	)
	result = /obj/item/chems/food/snacks/friedegg

/datum/recipe/boiledegg
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/boiledegg

/datum/recipe/classichotdog
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/holder/corgi
	)
	result = /obj/item/chems/food/snacks/classichotdog

/datum/recipe/jellydonut
	reagents = list(/datum/reagent/drink/juice/berry = 5, /datum/reagent/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/jelly

/datum/recipe/jellydonut/slime
	reagents = list(/datum/reagent/toxin/slimejelly = 5, /datum/reagent/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/slimejelly

/datum/recipe/jellydonut/cherry
	reagents = list(/datum/reagent/nutriment/cherryjelly = 5, /datum/reagent/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/cherryjelly

/datum/recipe/donut
	reagents = list(/datum/reagent/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/normal

/datum/recipe/meatburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatburger

/datum/recipe/brainburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/chems/food/snacks/brainburger

/datum/recipe/roburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/chems/food/snacks/roburger

/datum/recipe/xenoburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/xenomeat
	)
	result = /obj/item/chems/food/snacks/xenoburger

/datum/recipe/fishburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishburger

/datum/recipe/tofuburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/tofu
	)
	result = /obj/item/chems/food/snacks/tofuburger

/datum/recipe/ghostburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/chems/food/snacks/ghostburger

/datum/recipe/clownburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/chems/food/snacks/clownburger

/datum/recipe/mimeburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/chems/food/snacks/mimeburger

/datum/recipe/bunbun
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/bunbun

/datum/recipe/hotdog
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/sausage
	)
	result = /obj/item/chems/food/snacks/hotdog

/datum/recipe/waffles
	reagents = list(/datum/reagent/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/snacks/waffles

/datum/recipe/pancakesblu
	reagents = list(/datum/reagent/nutriment/batter = 20)
	fruit = list("blueberries" = 2)
	result = /obj/item/chems/food/snacks/pancakesblu

/datum/recipe/pancakes
	reagents = list(/datum/reagent/nutriment/batter = 20)
	result = /obj/item/chems/food/snacks/pancakes

/datum/recipe/donkpocket
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/meatball
	)
	result = /obj/item/chems/food/snacks/donkpocket //SPECIAL
	proc/warm_up(var/obj/item/chems/food/snacks/donkpocket/being_cooked)
		being_cooked.heat()
	make_food(var/obj/container as obj)
		var/obj/item/chems/food/snacks/donkpocket/being_cooked = ..(container)
		warm_up(being_cooked)
		return being_cooked

/datum/recipe/donkpocket2
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/donkpocket //SPECIAL

/datum/recipe/donkpocket2/proc/warm_up(var/obj/item/chems/food/snacks/donkpocket/being_cooked)
	being_cooked.heat()

/datum/recipe/donkpocket2/make_food(var/obj/container)
	var/obj/item/chems/food/snacks/donkpocket/being_cooked = ..(container)
	warm_up(being_cooked)
	return being_cooked

/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/chems/food/snacks/donkpocket
	)
	result = /obj/item/chems/food/snacks/donkpocket //SPECIAL
	make_food(var/obj/container as obj)
		var/obj/item/chems/food/snacks/donkpocket/being_cooked = locate() in container
		if(being_cooked && !being_cooked.warm)
			warm_up(being_cooked)
		return being_cooked

/datum/recipe/meatbread
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/meatbread

/datum/recipe/xenomeatbread
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/xenomeat,
		/obj/item/chems/food/snacks/xenomeat,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/xenomeatbread

/datum/recipe/bananabread
	fruit = list("banana" = 2)
	reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
	)
	result = /obj/item/chems/food/snacks/sliceable/bananabread

/datum/recipe/omelette
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/omelette

/datum/recipe/muffin
	reagents = list(/datum/reagent/nutriment/batter/cakebatter = 10)
	result = /obj/item/chems/food/snacks/muffin

/datum/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
		)
	result = /obj/item/chems/food/snacks/eggplantparm

/datum/recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list(/datum/reagent/nutriment/flour = 10)
	result = /obj/item/chems/food/snacks/soylenviridians

/datum/recipe/soylentgreen
	reagents = list(/datum/reagent/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/meat/human,
		/obj/item/chems/food/snacks/meat/human
	)
	result = /obj/item/chems/food/snacks/soylentgreen

/datum/recipe/meatpie
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatpie

/datum/recipe/tofupie
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/tofupie

/datum/recipe/xemeatpie
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/xenomeat,
	)
	result = /obj/item/chems/food/snacks/xemeatpie

/datum/recipe/bananapie
	fruit = list("banana" = 1)
	reagents = list(/datum/reagent/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/bananapie

/datum/recipe/cherrypie
	fruit = list("cherries" = 1)
	reagents = list(/datum/reagent/nutriment/sugar = 10)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/chems/food/snacks/cherrypie

/datum/recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/chems/food/snacks/berryclafoutis

/datum/recipe/chaosdonut
	reagents = list(/datum/reagent/frostoil = 5, /datum/reagent/capsaicin = 5, /datum/reagent/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/chaos

/datum/recipe/meatkabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatkabob

/datum/recipe/tofukabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/tofukabob

/datum/recipe/tofubread
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

/datum/recipe/loadedbakedpotato
	fruit = list("potato" = 1)
	items = list(/obj/item/chems/food/snacks/cheesewedge)
	result = /obj/item/chems/food/snacks/loadedbakedpotato

/datum/recipe/cheesyfries
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/cheesyfries

/datum/recipe/cubancarp
	fruit = list("chili" = 1)
	reagents = list(/datum/reagent/nutriment/batter = 10)
	items = list(
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/cubancarp

/datum/recipe/popcorn
	reagents = list(/datum/reagent/sodiumchloride = 5)
	fruit = list("corn" = 1)
	result = /obj/item/chems/food/snacks/popcorn

/datum/recipe/cookie
	reagents = list(/datum/reagent/nutriment/batter/cakebatter = 5, /datum/reagent/nutriment/coco = 5)

	result = /obj/item/chems/food/snacks/cookie

/datum/recipe/fortunecookie
	reagents = list(/datum/reagent/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/chems/food/snacks/fortunecookie
	make_food(var/obj/container as obj)
		var/obj/item/paper/paper = locate() in container
		paper.loc = null //prevent deletion
		var/obj/item/chems/food/snacks/fortunecookie/being_cooked = ..(container)
		paper.loc = being_cooked
		being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
		return being_cooked
	check_items(var/obj/container as obj)
		. = ..()
		if (.)
			var/obj/item/paper/paper = locate() in container
			if (!paper.info)
				return 0
		return .

/datum/recipe/plainsteak
	items = list(/obj/item/chems/food/snacks/meat)
	result = /obj/item/chems/food/snacks/plainsteak

/datum/recipe/meatsteak
	reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/meatsteak

/datum/recipe/loadedsteak
	reagents = list(/datum/reagent/nutriment/garlicsauce = 5)
	fruit = list("onion" = 1, "mushroom" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/loadedsteak

/datum/recipe/syntisteak
	reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(/obj/item/chems/food/snacks/meat/syntiflesh)
	result = /obj/item/chems/food/snacks/meatsteak/synthetic

/datum/recipe/pizzamargherita
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/margherita

/datum/recipe/meatpizza
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/mushroompizza
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/spacylibertyduff
	reagents = list(/datum/reagent/water = 10, /datum/reagent/ethanol/vodka = 5, /datum/reagent/psychotropics = 5)
	result = /obj/item/chems/food/snacks/spacylibertyduff

/datum/recipe/amanitajelly
	reagents = list(/datum/reagent/water = 10, /datum/reagent/ethanol/vodka = 5, /datum/reagent/toxin/amatoxin = 5)
	result = /obj/item/chems/food/snacks/amanitajelly
	make_food(var/obj/container as obj)
		var/obj/item/chems/food/snacks/amanitajelly/being_cooked = ..(container)
		being_cooked.reagents.del_reagent(/datum/reagent/toxin/amatoxin)
		return being_cooked

/datum/recipe/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/datum/reagent/water = 10)
	items = list(/obj/item/chems/food/snacks/meatball)
	result = /obj/item/chems/food/snacks/meatballsoup

/datum/recipe/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/chems/food/snacks/vegetablesoup

/datum/recipe/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1)
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/nettlesoup

/datum/recipe/wishsoup
	reagents = list(/datum/reagent/water = 20)
	result= /obj/item/chems/food/snacks/wishsoup

/datum/recipe/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/hotchili

/datum/recipe/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/coldchili

/datum/recipe/amanita_pie
	reagents = list(/datum/reagent/toxin/amatoxin = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/amanita_pie

/datum/recipe/plump_pie
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/plump_pie

/datum/recipe/spellburger
	items = list(
		/obj/item/chems/food/snacks/meatburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/chems/food/snacks/spellburger

/datum/recipe/bigbiteburger
	items = list(
		/obj/item/chems/food/snacks/meatburger,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/egg,
	)
	result = /obj/item/chems/food/snacks/bigbiteburger

/datum/recipe/enchiladas
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/enchiladas

/datum/recipe/creamcheesebread
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/creamcheesebread

/datum/recipe/monkeysdelight
	fruit = list("banana" = 1)
	reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1, /datum/reagent/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/monkeycube
	)
	result = /obj/item/chems/food/snacks/monkeysdelight

/datum/recipe/baguette
	reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
	)
	result = /obj/item/chems/food/snacks/baguette

/datum/recipe/fishandchips
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishandchips

/datum/recipe/bread
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/sliceable/bread

/datum/recipe/sandwich
	items = list(
		/obj/item/chems/food/snacks/meatsteak,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sandwich

/datum/recipe/toastedsandwich
	items = list(
		/obj/item/chems/food/snacks/sandwich
	)
	result = /obj/item/chems/food/snacks/toastedsandwich

/datum/recipe/grilledcheese
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/grilledcheese

/datum/recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/chems/food/snacks/tomatosoup

/datum/recipe/rofflewaffles
	reagents = list(/datum/reagent/psychotropics = 5, /datum/reagent/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/snacks/rofflewaffles

/datum/recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/datum/reagent/water = 10)
	items = list(/obj/item/chems/food/snacks/meat)
	result = /obj/item/chems/food/snacks/stew

/datum/recipe/slimetoast
	reagents = list(/datum/reagent/toxin/slimejelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jelliedtoast/slime

/datum/recipe/jelliedtoast
	reagents = list(/datum/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jelliedtoast/cherry

/datum/recipe/milosoup
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/milosoup

/datum/recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/soydope
	)
	result = /obj/item/chems/food/snacks/stewedsoymeat

/datum/recipe/boiledspagetti
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
	)
	result = /obj/item/chems/food/snacks/boiledspagetti

/datum/recipe/boiledrice
	reagents = list(/datum/reagent/water = 10, /datum/reagent/nutriment/rice = 10)
	result = /obj/item/chems/food/snacks/boiledrice

/datum/recipe/chazuke
	reagents = list(/datum/reagent/nutriment/rice/chazuke = 10)
	result = /obj/item/chems/food/snacks/boiledrice/chazuke

/datum/recipe/katsucurry
	fruit = list("apple" = 1, "carrot" = 1, "potato" = 1)
	reagents = list(/datum/reagent/water = 10, /datum/reagent/nutriment/rice = 10, /datum/reagent/nutriment/flour = 5)
	items = list(
		/obj/item/chems/food/snacks/meat/chicken
	)
	result = /obj/item/chems/food/snacks/katsucurry

/datum/recipe/ricepudding
	reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/rice = 10)
	result = /obj/item/chems/food/snacks/ricepudding

/datum/recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list(/datum/reagent/water = 10)
	items = list(/obj/item/chems/food/snacks/spagetti)
	result = /obj/item/chems/food/snacks/pastatomato

/datum/recipe/poppypretzel
	fruit = list("poppy" = 1)
	items = list(/obj/item/chems/food/snacks/dough)
	result = /obj/item/chems/food/snacks/poppypretzel

/datum/recipe/meatballspagetti
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
	)
	result = /obj/item/chems/food/snacks/meatballspagetti

/datum/recipe/spesslaw
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
	)
	result = /obj/item/chems/food/snacks/spesslaw

/datum/recipe/nanopasta
	reagents = list(/datum/reagent/water = 10)
	items = list(/obj/item/chems/food/snacks/spagetti,
				/obj/item/stack/nanopaste)
	result = /obj/item/chems/food/snacks/nanopasta

/datum/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list(/datum/reagent/sodiumchloride = 5, /datum/reagent/blackpepper = 5)
	items = list(
		/obj/item/chems/food/snacks/bigbiteburger,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/boiledegg,
	)
	result = /obj/item/chems/food/snacks/superbiteburger

/datum/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list(/datum/reagent/water = 10, /datum/reagent/nutriment/sugar = 5)
	result = /obj/item/chems/food/snacks/candiedapple

/datum/recipe/applepie
	fruit = list("apple" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/applepie

/datum/recipe/slimeburger
	reagents = list(/datum/reagent/toxin/slimejelly = 5)
	items = list(
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/jellyburger/slime

/datum/recipe/jellyburger
	reagents = list(/datum/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/jellyburger/cherry

/datum/recipe/twobread
	reagents = list(/datum/reagent/ethanol/wine = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/twobread

/datum/recipe/threebread
	items = list(
		/obj/item/chems/food/snacks/twobread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/threebread

/datum/recipe/slimesandwich
	reagents = list(/datum/reagent/toxin/slimejelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jellysandwich/slime

/datum/recipe/cherrysandwich
	reagents = list(/datum/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jellysandwich/cherry

/datum/recipe/bloodsoup
	reagents = list(/datum/reagent/blood = 30)
	result = /obj/item/chems/food/snacks/bloodsoup

/datum/recipe/slimesoup
	reagents = list(/datum/reagent/water = 10, /datum/reagent/toxin/slimejelly = 5)
	items = list()
	result = /obj/item/chems/food/snacks/slimesoup

/datum/recipe/chocolateegg
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/chocolatebar,
	)
	result = /obj/item/chems/food/snacks/chocolateegg

/datum/recipe/sausage
	items = list(
		/obj/item/chems/food/snacks/rawmeatball,
		/obj/item/chems/food/snacks/rawcutlet,
	)
	result = /obj/item/chems/food/snacks/sausage

/datum/recipe/fatsausage
	reagents = list(/datum/reagent/blackpepper = 2)
	items = list(
		/obj/item/chems/food/snacks/rawmeatball,
		/obj/item/chems/food/snacks/rawcutlet,
	)
	result = /obj/item/chems/food/snacks/fatsausage

/datum/recipe/fishfingers
	reagents = list(/datum/reagent/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishfingers

/datum/recipe/mysterysoup
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/badrecipe,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/mysterysoup

/datum/recipe/pumpkinpie
	fruit = list("pumpkin" = 1)
	reagents = list(/datum/reagent/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/sliceable/pumpkinpie

/datum/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list(/datum/reagent/nutriment/batter = 10)
	result = /obj/item/chems/food/snacks/plumphelmetbiscuit

/datum/recipe/plumphelmetbiscuitvegan
	fruit = list("plumphelmet" = 1)
	reagents = list(/datum/reagent/nutriment/flour = 10, /datum/reagent/water = 10)
	result = /obj/item/chems/food/snacks/plumphelmetbiscuit

/datum/recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list(/datum/reagent/drink/milk = 10)
	result = /obj/item/chems/food/snacks/mushroomsoup

/datum/recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list(/datum/reagent/water = 10, /datum/reagent/nutriment/soysauce = 5)
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/chawanmushi

/datum/recipe/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/chems/food/snacks/beetsoup

/datum/recipe/appletart
	fruit = list("goldapple" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/appletart

/datum/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/chems/food/snacks/tossedsalad

/datum/recipe/aesirsalad
	fruit = list("goldapple" = 1, "biteleafdeus" = 1)
	result = /obj/item/chems/food/snacks/aesirsalad

/datum/recipe/validsalad
	fruit = list("potato" = 1, "biteleaf" = 3)
	items = list(/obj/item/chems/food/snacks/meatball)
	result = /obj/item/chems/food/snacks/validsalad
	make_food(var/obj/container as obj)
		var/obj/item/chems/food/snacks/validsalad/being_cooked = ..(container)
		being_cooked.reagents.del_reagent(/datum/reagent/toxin)
		return being_cooked

/datum/recipe/cracker
	reagents = list(/datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/doughslice
	)
	result = /obj/item/chems/food/snacks/cracker

/datum/recipe/stuffing
	reagents = list(/datum/reagent/water = 10, /datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/bread,
	)
	result = /obj/item/chems/food/snacks/stuffing

/datum/recipe/tofurkey
	items = list(
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/stuffing,
	)
	result = /obj/item/chems/food/snacks/tofurkey

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/recipe/taco
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/taco

/datum/recipe/bun
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/bun

/datum/recipe/flatbread
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough
	)
	result = /obj/item/chems/food/snacks/flatbread

/datum/recipe/meatball
	items = list(
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/meatball

/datum/recipe/cutlet
	items = list(
		/obj/item/chems/food/snacks/rawcutlet
	)
	result = /obj/item/chems/food/snacks/cutlet

/datum/recipe/fries
	items = list(
		/obj/item/chems/food/snacks/rawsticks
	)
	result = /obj/item/chems/food/snacks/fries

/datum/recipe/onionrings
	fruit = list("onion" = 1)
	reagents = list(/datum/reagent/nutriment/batter = 10)
	result = /obj/item/chems/food/snacks/onionrings

/datum/recipe/mint
	reagents = list(/datum/reagent/nutriment/sugar = 5, /datum/reagent/frostoil = 5)
	result = /obj/item/chems/food/snacks/mint

// Cakes.
/datum/recipe/cake
	reagents = list(/datum/reagent/nutriment/batter/cakebatter = 60)
	result = /obj/item/chems/food/snacks/sliceable/plaincake

/datum/recipe/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/chems/food/snacks/sliceable/carrotcake

/datum/recipe/cake/cheese
	items = list(
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/cheesecake

/datum/recipe/cake/orange
	fruit = list("orange" = 1)
	result = /obj/item/chems/food/snacks/sliceable/orangecake

/datum/recipe/cake/lime
	fruit = list("lime" = 1)
	result = /obj/item/chems/food/snacks/sliceable/limecake

/datum/recipe/cake/lemon
	fruit = list("lemon" = 1)
	result = /obj/item/chems/food/snacks/sliceable/lemoncake

/datum/recipe/cake/chocolate
	items = list(/obj/item/chems/food/snacks/chocolatebar)
	result = /obj/item/chems/food/snacks/sliceable/chocolatecake

//datum/recipe/cake/birthday
//	items = list(/obj/item/clothing/head/cakehat)
//	result = /obj/item/chems/food/snacks/sliceable/birthdaycake

/datum/recipe/cake/birthday
	reagents = list(/datum/reagent/nutriment/sprinkles = 10)
	result = /obj/item/chems/food/snacks/sliceable/birthdaycake

/datum/recipe/cake/apple
	fruit = list("apple" = 2)
	result = /obj/item/chems/food/snacks/sliceable/applecake

/datum/recipe/cake/brain
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/chems/food/snacks/sliceable/braincake

/datum/recipe/cake/chocolatebar
	reagents = list(/datum/reagent/drink/milk/chocolate = 10, /datum/reagent/nutriment/coco = 5, /datum/reagent/nutriment/sugar = 5)
	result = /obj/item/chems/food/snacks/chocolatebar

/datum/recipe/boiledspiderleg
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spider
	)
	result = /obj/item/chems/food/snacks/spider/cooked