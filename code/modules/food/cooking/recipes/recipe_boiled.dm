/decl/recipe/boiled
	abstract_type = /decl/recipe/boiled
	//minimum_temperature = T100C
	//cooking_heat_type = COOKING_HEAT_INDIRECT
	//cooking_medium_type = /decl/material/liquid/water
	//cooking_medium_amount = 20
	reagent_mix = REAGENT_REPLACE // no raw egg or water
	reagents = list(
		/decl/material/liquid/water = 10
	)

/decl/recipe/boiled/egg
	items = list(/obj/item/chems/food/egg)
	result = /obj/item/chems/food/boiledegg

/decl/recipe/boiled/rice
	reagents = list(
		/decl/material/liquid/water = 10,
		/decl/material/liquid/nutriment/rice = 10
	)
	result = /obj/item/chems/food/boiledrice

/decl/recipe/boiled/spagetti
	items = list(/obj/item/chems/food/spagetti)
	result = /obj/item/chems/food/boiledspagetti

/decl/recipe/boiled/spiderleg
	items = list(/obj/item/chems/food/spider)
	result = /obj/item/chems/food/spider/cooked

/decl/recipe/boiled/pelmeni
	items = list(/obj/item/chems/food/pelmen = 5)
	result = /obj/item/chems/food/pelmeni_boiled
