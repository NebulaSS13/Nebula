
// see code/datums/recipe.dm


/* No telebacon. just no...
/decl/recipe/telebacon
	items = list(
		/obj/item/chems/food/snacks/meat,
		/obj/item/assembly/signaler
	)
	result = /obj/item/chems/food/snacks/telebacon

I said no!
/decl/recipe/syntitelebacon
	items = list(
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/assembly/signaler
	)
	result = /obj/item/chems/food/snacks/telebacon
*/

/decl/recipe/friedegg
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/friedegg

/decl/recipe/friedegg2
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg,
	)
	result = /obj/item/chems/food/snacks/friedegg

/decl/recipe/boiledegg
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/boiledegg

/decl/recipe/classichotdog
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/holder/corgi
	)
	result = /obj/item/chems/food/snacks/classichotdog

/decl/recipe/jellydonut
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
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/normal

/decl/recipe/meatburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatburger

/decl/recipe/brainburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/chems/food/snacks/brainburger

/decl/recipe/roburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/chems/food/snacks/roburger

/decl/recipe/xenoburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/xenomeat
	)
	result = /obj/item/chems/food/snacks/xenoburger

/decl/recipe/fishburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishburger

/decl/recipe/tofuburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/tofu
	)
	result = /obj/item/chems/food/snacks/tofuburger

/decl/recipe/ghostburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/chems/food/snacks/ghostburger

/decl/recipe/clownburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/chems/food/snacks/clownburger

/decl/recipe/mimeburger
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/chems/food/snacks/mimeburger

/decl/recipe/bunbun
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/bunbun

/decl/recipe/hotdog
	items = list(
		/obj/item/chems/food/snacks/bun,
		/obj/item/chems/food/snacks/sausage
	)
	result = /obj/item/chems/food/snacks/hotdog

/decl/recipe/waffles
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/snacks/waffles

/decl/recipe/pancakesblu
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	fruit = list("blueberries" = 2)
	result = /obj/item/chems/food/snacks/pancakesblu

/decl/recipe/pancakes
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	result = /obj/item/chems/food/snacks/pancakes

/decl/recipe/donkpocket
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

/decl/recipe/donkpocket2
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/donkpocket //SPECIAL

/decl/recipe/donkpocket2/proc/warm_up(var/obj/item/chems/food/snacks/donkpocket/being_cooked)
	being_cooked.heat()

/decl/recipe/donkpocket2/make_food(var/obj/container)
	var/obj/item/chems/food/snacks/donkpocket/being_cooked = ..(container)
	warm_up(being_cooked)
	return being_cooked

/decl/recipe/donkpocket/warm
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
	fruit = list("banana" = 2)
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
	)
	result = /obj/item/chems/food/snacks/sliceable/bananabread

/decl/recipe/omelette
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/omelette

/decl/recipe/muffin
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 10)
	result = /obj/item/chems/food/snacks/muffin

/decl/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
		)
	result = /obj/item/chems/food/snacks/eggplantparm

/decl/recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	result = /obj/item/chems/food/snacks/soylenviridians

/decl/recipe/soylentgreen
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/meat/human,
		/obj/item/chems/food/snacks/meat/human
	)
	result = /obj/item/chems/food/snacks/soylentgreen

/decl/recipe/meatpie
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatpie

/decl/recipe/tofupie
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/tofupie

/decl/recipe/xemeatpie
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/xenomeat,
	)
	result = /obj/item/chems/food/snacks/xemeatpie

/decl/recipe/bananapie
	fruit = list("banana" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/bananapie

/decl/recipe/cherrypie
	fruit = list("cherries" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 10)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/chems/food/snacks/cherrypie

/decl/recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/chems/food/snacks/berryclafoutis

/decl/recipe/chaosdonut
	reagents = list(/decl/material/liquid/frostoil = 5, /decl/material/liquid/capsaicin = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/donut/chaos

/decl/recipe/meatkabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet
	)
	result = /obj/item/chems/food/snacks/meatkabob

/decl/recipe/tofukabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/tofukabob

/decl/recipe/tofubread
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

/decl/recipe/loadedbakedpotato
	fruit = list("potato" = 1)
	items = list(/obj/item/chems/food/snacks/cheesewedge)
	result = /obj/item/chems/food/snacks/loadedbakedpotato

/decl/recipe/cheesyfries
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/cheesyfries

/decl/recipe/cubancarp
	fruit = list("chili" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	items = list(
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/cubancarp

/decl/recipe/popcorn
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 5)
	fruit = list("corn" = 1)
	result = /obj/item/chems/food/snacks/popcorn

/decl/recipe/cookie
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 5, /decl/material/liquid/nutriment/coco = 5)

	result = /obj/item/chems/food/snacks/cookie

/decl/recipe/fortunecookie
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
	items = list(/obj/item/chems/food/snacks/meat)
	result = /obj/item/chems/food/snacks/plainsteak

/decl/recipe/meatsteak
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/meatsteak

/decl/recipe/loadedsteak
	reagents = list(/decl/material/liquid/nutriment/garlicsauce = 5)
	fruit = list("onion" = 1, "mushroom" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/loadedsteak

/decl/recipe/syntisteak
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/snacks/meat/syntiflesh)
	result = /obj/item/chems/food/snacks/meatsteak/synthetic

/decl/recipe/pizzamargherita
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/margherita

/decl/recipe/meatpizza
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/meatpizza

/decl/recipe/mushroompizza
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/mushroompizza

/decl/recipe/vegetablepizza
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza

/decl/recipe/spacylibertyduff
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/psychotropics = 5)
	result = /obj/item/chems/food/snacks/spacylibertyduff

/decl/recipe/amanitajelly
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/amatoxin = 5)
	result = /obj/item/chems/food/snacks/amanitajelly

/decl/recipe/amanitajelly/make_food(var/obj/container)
	var/obj/item/chems/food/snacks/amanitajelly/being_cooked = ..(container)
	being_cooked.reagents.clear_reagent(/decl/material/liquid/amatoxin)
	return being_cooked

/decl/recipe/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/snacks/meatball)
	result = /obj/item/chems/food/snacks/meatballsoup

/decl/recipe/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/vegetablesoup

/decl/recipe/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/nettlesoup

/decl/recipe/wishsoup
	reagents = list(/decl/material/liquid/water = 20)
	result= /obj/item/chems/food/snacks/wishsoup

/decl/recipe/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/hotchili

/decl/recipe/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/coldchili

/decl/recipe/amanita_pie
	reagents = list(/decl/material/liquid/amatoxin = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/amanita_pie

/decl/recipe/plump_pie
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/plump_pie

/decl/recipe/spellburger
	items = list(
		/obj/item/chems/food/snacks/meatburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/chems/food/snacks/spellburger

/decl/recipe/bigbiteburger
	items = list(
		/obj/item/chems/food/snacks/meatburger,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/egg,
	)
	result = /obj/item/chems/food/snacks/bigbiteburger

/decl/recipe/enchiladas
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/enchiladas

/decl/recipe/creamcheesebread
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sliceable/creamcheesebread

/decl/recipe/monkeysdelight
	fruit = list("banana" = 1)
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1, /decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/monkeycube
	)
	result = /obj/item/chems/food/snacks/monkeysdelight

/decl/recipe/baguette
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
	)
	result = /obj/item/chems/food/snacks/baguette

/decl/recipe/fishandchips
	items = list(
		/obj/item/chems/food/snacks/fries,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishandchips

/decl/recipe/bread
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/sliceable/bread

/decl/recipe/sandwich
	items = list(
		/obj/item/chems/food/snacks/meatsteak,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/sandwich

/decl/recipe/toastedsandwich
	items = list(
		/obj/item/chems/food/snacks/sandwich
	)
	result = /obj/item/chems/food/snacks/toastedsandwich

/decl/recipe/grilledcheese
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/grilledcheese

/decl/recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/tomatosoup

/decl/recipe/rofflewaffles
	reagents = list(/decl/material/liquid/psychotropics = 5, /decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/snacks/rofflewaffles

/decl/recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/snacks/meat)
	result = /obj/item/chems/food/snacks/stew

/decl/recipe/jelliedtoast
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jelliedtoast/cherry

/decl/recipe/milosoup
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/milosoup

/decl/recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/soydope
	)
	result = /obj/item/chems/food/snacks/stewedsoymeat

/decl/recipe/boiledspagetti
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
	)
	result = /obj/item/chems/food/snacks/boiledspagetti

/decl/recipe/boiledrice
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/snacks/boiledrice

/decl/recipe/chazuke
	reagents = list(/decl/material/liquid/nutriment/rice/chazuke = 10)
	result = /obj/item/chems/food/snacks/boiledrice/chazuke

/decl/recipe/katsucurry
	fruit = list("apple" = 1, "carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10, /decl/material/liquid/nutriment/flour = 5)
	items = list(
		/obj/item/chems/food/snacks/meat/chicken
	)
	result = /obj/item/chems/food/snacks/katsucurry

/decl/recipe/ricepudding
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/snacks/ricepudding

/decl/recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/snacks/spagetti)
	result = /obj/item/chems/food/snacks/pastatomato

/decl/recipe/poppypretzel
	fruit = list("poppy" = 1)
	items = list(/obj/item/chems/food/snacks/dough)
	result = /obj/item/chems/food/snacks/poppypretzel

/decl/recipe/meatballspagetti
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
	)
	result = /obj/item/chems/food/snacks/meatballspagetti

/decl/recipe/spesslaw
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/meatball,
	)
	result = /obj/item/chems/food/snacks/spesslaw

/decl/recipe/nanopasta
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
		/obj/item/stack/nanopaste
	)
	result = /obj/item/chems/food/snacks/nanopasta

/decl/recipe/superbiteburger
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

/decl/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/snacks/candiedapple

/decl/recipe/applepie
	fruit = list("apple" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/applepie

/decl/recipe/jellyburger
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/bun
	)
	result = /obj/item/chems/food/snacks/jellyburger/cherry

/decl/recipe/twobread
	reagents = list(/decl/material/liquid/ethanol/wine = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/twobread

/decl/recipe/threebread
	items = list(
		/obj/item/chems/food/snacks/twobread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/threebread

/decl/recipe/cherrysandwich
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jellysandwich/cherry

/decl/recipe/bloodsoup
	reagents = list(/decl/material/liquid/blood = 30)
	result = /obj/item/chems/food/snacks/bloodsoup

/decl/recipe/chocolateegg
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/chocolatebar,
	)
	result = /obj/item/chems/food/snacks/chocolateegg

/decl/recipe/sausage
	items = list(
		/obj/item/chems/food/snacks/rawmeatball,
		/obj/item/chems/food/snacks/rawcutlet,
	)
	result = /obj/item/chems/food/snacks/sausage

/decl/recipe/fatsausage
	reagents = list(/decl/material/solid/blackpepper = 2)
	items = list(
		/obj/item/chems/food/snacks/rawmeatball,
		/obj/item/chems/food/snacks/rawcutlet,
	)
	result = /obj/item/chems/food/snacks/fatsausage

/decl/recipe/fishfingers
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/fish
	)
	result = /obj/item/chems/food/snacks/fishfingers

/decl/recipe/mysterysoup
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/badrecipe,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/mysterysoup

/decl/recipe/pumpkinpie
	fruit = list("pumpkin" = 1)
	reagents = list(/decl/material/liquid/nutriment/sugar = 5)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/sliceable/pumpkinpie

/decl/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/snacks/plumphelmetbiscuit

/decl/recipe/plumphelmetbiscuitvegan
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/plumphelmetbiscuit

/decl/recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/drink/milk = 10)
	result = /obj/item/chems/food/snacks/mushroomsoup

/decl/recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/soysauce = 5)
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/chawanmushi

/decl/recipe/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/beetsoup

/decl/recipe/appletart
	fruit = list("goldapple" = 1)
	items = list(/obj/item/chems/food/snacks/sliceable/flatdough)
	result = /obj/item/chems/food/snacks/appletart

/decl/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/chems/food/snacks/tossedsalad

/decl/recipe/aesirsalad
	fruit = list("goldapple" = 1, "biteleafdeus" = 1)
	result = /obj/item/chems/food/snacks/aesirsalad

/decl/recipe/validsalad
	fruit = list("potato" = 1, "biteleaf" = 3)
	items = list(/obj/item/chems/food/snacks/meatball)
	result = /obj/item/chems/food/snacks/validsalad

/decl/recipe/cracker
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1)
	items = list(
		/obj/item/chems/food/snacks/doughslice
	)
	result = /obj/item/chems/food/snacks/cracker

/decl/recipe/stuffing
	reagents = list(/decl/material/liquid/water = 10, /decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/bread,
	)
	result = /obj/item/chems/food/snacks/stuffing

/decl/recipe/tofurkey
	items = list(
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/stuffing,
	)
	result = /obj/item/chems/food/snacks/tofurkey

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/decl/recipe/taco
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/cutlet,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/taco

/decl/recipe/bun
	items = list(
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/bun

/decl/recipe/flatbread
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough
	)
	result = /obj/item/chems/food/snacks/flatbread

/decl/recipe/meatball
	items = list(
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/meatball

/decl/recipe/cutlet
	items = list(
		/obj/item/chems/food/snacks/rawcutlet
	)
	result = /obj/item/chems/food/snacks/cutlet

/decl/recipe/fries
	items = list(
		/obj/item/chems/food/snacks/rawsticks
	)
	result = /obj/item/chems/food/snacks/fries

/decl/recipe/onionrings
	fruit = list("onion" = 1)
	reagents = list(/decl/material/liquid/nutriment/batter = 10)
	result = /obj/item/chems/food/snacks/onionrings

/decl/recipe/mint
	reagents = list(/decl/material/liquid/nutriment/sugar = 5, /decl/material/liquid/frostoil = 5)
	result = /obj/item/chems/food/snacks/mint

// Cakes.
/decl/recipe/cake
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

/decl/recipe/boiledspiderleg
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spider
	)
	result = /obj/item/chems/food/snacks/spider/cooked

/decl/recipe/pelmen
	items = list(
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/doughslice,
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/pelmen

/decl/recipe/pelmeni_boiled
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen
	)
	result = /obj/item/chems/food/snacks/pelmeni_boiled
