/decl/recipe/friedegg
	appliance = SKILLET
	reagents = list(/decl/material/solid/mineral/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/friedegg

/decl/recipe/friedegg2
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg,
	)
	result = /obj/item/chems/food/snacks/friedegg

/decl/recipe/chocolateegg
	appliance = SAUCEPAN|POT // melt the chocolate
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/chocolatebar,
	)
	result = /obj/item/chems/food/snacks/chocolateegg

/decl/recipe/sausage
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/rawmeatball,
		/obj/item/chems/food/snacks/rawcutlet,
	)
	result = /obj/item/chems/food/snacks/sausage

/decl/recipe/fatsausage
	appliance = SKILLET
	reagents = list(/decl/material/solid/blackpepper = 2)
	items = list(
		/obj/item/chems/food/snacks/rawmeatball,
		/obj/item/chems/food/snacks/rawcutlet,
	)
	result = /obj/item/chems/food/snacks/fatsausage

/decl/recipe/candiedapple
	appliance = SAUCEPAN
	fruit = list("apple" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/sugar = 5)
	result = /obj/item/chems/food/snacks/candiedapple

/decl/recipe/chawanmushi
	appliance = SAUCEPAN|POT // steamed
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/soysauce = 5)
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/chawanmushi

/decl/recipe/bloodsoup
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/liquid/blood = 30)
	result = /obj/item/chems/food/snacks/bloodsoup

/decl/recipe/mysterysoup
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/badrecipe,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/mysterysoup

/decl/recipe/mushroomsoup
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/drink/milk = 10)
	result = /obj/item/chems/food/snacks/mushroomsoup

/decl/recipe/beetsoup
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/beetsoup

/decl/recipe/milosoup
	appliance = MICROWAVE|SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/tofu,
		/obj/item/chems/food/snacks/tofu,
	)
	result = /obj/item/chems/food/snacks/milosoup

/decl/recipe/tomatosoup
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/tomatosoup
/decl/recipe/meatballsoup
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/snacks/meatball)
	result = /obj/item/chems/food/snacks/meatballsoup

/decl/recipe/vegetablesoup
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/snacks/vegetablesoup

/decl/recipe/nettlesoup
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("nettle" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/nettlesoup

/decl/recipe/wishsoup
	appliance = MICROWAVE|SAUCEPAN|POT // microwave works, because desperation
	reagents = list(/decl/material/liquid/water = 20)
	result= /obj/item/chems/food/snacks/wishsoup

/decl/recipe/hotchili
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/hotchili

/decl/recipe/coldchili
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/snacks/cutlet)
	result = /obj/item/chems/food/snacks/coldchili

/decl/recipe/stew
	appliance = MICROWAVE|SAUCEPAN|POT
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/snacks/meat)
	result = /obj/item/chems/food/snacks/stew

/decl/recipe/mint
	appliance = SAUCEPAN
	reagents = list(/decl/material/liquid/nutriment/sugar = 5, /decl/material/liquid/frostoil = 5)
	result = /obj/item/chems/food/snacks/mint

/decl/recipe/boiledspiderleg
	appliance = SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spider
	)
	result = /obj/item/chems/food/snacks/spider/cooked

/decl/recipe/pelmeni_boiled
	appliance = SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen,
		/obj/item/chems/food/snacks/pelmen
	)
	result = /obj/item/chems/food/snacks/pelmeni_boiled

/decl/recipe/meatball
	appliance = SKILLET|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/rawmeatball
	)
	result = /obj/item/chems/food/snacks/meatball

/decl/recipe/cutlet
	appliance = SKILLET|MICROWAVE
	items = list(
		/obj/item/chems/food/snacks/rawcutlet
	)
	result = /obj/item/chems/food/snacks/cutlet

/decl/recipe/ricepudding
	appliance = SAUCEPAN|POT
	reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/snacks/ricepudding


/decl/recipe/stewedsoymeat
	appliance = SAUCEPAN|POT
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/soydope,
		/obj/item/chems/food/snacks/soydope
	)
	result = /obj/item/chems/food/snacks/stewedsoymeat

/decl/recipe/boiledspagetti
	appliance = SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/spagetti,
	)
	result = /obj/item/chems/food/snacks/boiledspagetti

/decl/recipe/boiledegg
	appliance = SAUCEPAN|POT
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/snacks/egg
	)
	result = /obj/item/chems/food/snacks/boiledegg

/decl/recipe/waffles
	appliance = SKILLET // no waffle griddle, sadly
	reagents = list(/decl/material/liquid/nutriment/batter/cakebatter = 20)
	result = /obj/item/chems/food/snacks/waffles

/decl/recipe/pancakes
	appliance = SKILLET
	reagents = list(/decl/material/liquid/nutriment/batter = 20)
	result = /obj/item/chems/food/snacks/pancakes

/decl/recipe/pancakes/blu
	fruit = list("blueberries" = 2)
	result = /obj/item/chems/food/snacks/pancakesblu

/decl/recipe/omelette
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/egg,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/omelette

/decl/recipe/soylenviridians
	appliance = SKILLET // considering it equivalent to waffles?
	fruit = list("soybeans" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	result = /obj/item/chems/food/snacks/soylenviridians

/decl/recipe/soylentgreen
	appliance = SKILLET // considering it equivalent to waffles?
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/snacks/meat/human,
		/obj/item/chems/food/snacks/meat/human
	)
	result = /obj/item/chems/food/snacks/soylentgreen

/decl/recipe/amanitajelly
	appliance = SAUCEPAN
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/ethanol/vodka = 5, /decl/material/liquid/amatoxin = 5)
	result = /obj/item/chems/food/snacks/amanitajelly

/decl/recipe/amanitajelly/make_food(var/obj/container)
	var/obj/item/chems/food/snacks/amanitajelly/being_cooked = ..(container)
	being_cooked.reagents.clear_reagent(/decl/material/liquid/amatoxin)
	return being_cooked

/decl/recipe/toastedsandwich
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/sandwich
	)
	result = /obj/item/chems/food/snacks/toastedsandwich

/decl/recipe/grilledcheese
	appliance = SKILLET
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/slice/bread,
		/obj/item/chems/food/snacks/cheesewedge,
	)
	result = /obj/item/chems/food/snacks/grilledcheese
/decl/recipe/jelliedtoast
	appliance = SKILLET
	reagents = list(/decl/material/liquid/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/chems/food/snacks/slice/bread,
	)
	result = /obj/item/chems/food/snacks/jelliedtoast/cherry