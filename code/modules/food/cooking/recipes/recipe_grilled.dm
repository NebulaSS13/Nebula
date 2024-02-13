/decl/recipe/plainsteak
	items = list(/obj/item/chems/food/meat)
	result = /obj/item/chems/food/plainsteak

/decl/recipe/meatsteak
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/meatsteak

/decl/recipe/loadedsteak
	reagents = list(/decl/material/liquid/nutriment/garlicsauce = 5)
	fruit = list("onion" = 1, "mushroom" = 1)
	items = list(/obj/item/chems/food/cutlet)
	result = /obj/item/chems/food/loadedsteak

/decl/recipe/syntisteak
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/meat/syntiflesh)
	result = /obj/item/chems/food/meatsteak/synthetic

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

/decl/recipe/fishfingers
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/chems/food/egg,
		/obj/item/chems/food/fish
	)
	reagent_mix = REAGENT_REPLACE // no raw egg/fish
	result = /obj/item/chems/food/fishfingers

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
