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
	container_categories = list(
		RECIPE_CATEGORY_MICROWAVE,
		RECIPE_CATEGORY_POT
	)

/decl/recipe/boiled/egg
	items = list(/obj/item/food/egg)
	result = /obj/item/food/boiledegg
	completion_message = "The egg hardens as it is cooked through."

/decl/recipe/boiled/rice
	reagents = list(
		/decl/material/liquid/water = 10,
		/decl/material/liquid/nutriment/rice = 10
	)
	result = /obj/item/food/boiledrice
	completion_message = "The rice steams and softens as it is cooked through."

/decl/recipe/boiled/spagetti
	items = list(/obj/item/food/spagetti)
	result = /obj/item/food/boiledspagetti
	completion_message = "The spaghetti steams and softens as it is cooked through."

/decl/recipe/boiled/spiderleg
	items = list(/obj/item/food/spider)
	result = /obj/item/food/spider/cooked
	completion_message = "The gelatious spider meat firms up as it is cooked through."

/decl/recipe/boiled/pelmeni
	items = list(/obj/item/food/pelmen = 5)
	result = /obj/item/food/pelmeni_boiled
	completion_message = "The pelmeni firm up as they are cooked through."
