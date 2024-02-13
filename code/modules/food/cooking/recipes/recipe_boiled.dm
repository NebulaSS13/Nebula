/decl/recipe/boiledegg
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // no raw egg or water
	result = /obj/item/chems/food/boiledegg

/decl/recipe/boiledrice
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10)
	result = /obj/item/chems/food/boiledrice

/decl/recipe/boiledspagetti
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spagetti,
	)
	result = /obj/item/chems/food/boiledspagetti

/decl/recipe/boiledspiderleg
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/spider
	)
	result = /obj/item/chems/food/spider/cooked

/decl/recipe/pelmeni_boiled
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/pelmen = 5
	)
	result = /obj/item/chems/food/pelmeni_boiled
