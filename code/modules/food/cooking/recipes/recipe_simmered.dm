/decl/recipe/simmered
	abstract_type = /decl/recipe/simmered

/decl/recipe/simmered/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/meatball)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result = /obj/item/chems/food/meatballsoup

/decl/recipe/simmered/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result = /obj/item/chems/food/vegetablesoup

/decl/recipe/simmered/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/egg
	)
	reagent_mix = REAGENT_REPLACE // Remove extra water and egg
	result = /obj/item/chems/food/nettlesoup

/decl/recipe/simmered/wishsoup
	reagents = list(/decl/material/liquid/water = 20)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result= /obj/item/chems/food/wishsoup
	container_categories = list(RECIPE_CATEGORY_MICROWAVE)

/decl/recipe/simmered/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/butchery/cutlet)
	result = /obj/item/chems/food/hotchili

/decl/recipe/simmered/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/chems/food/butchery/cutlet)
	result = /obj/item/chems/food/coldchili

/decl/recipe/simmered/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/tomatosoup

/decl/recipe/simmered/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/chems/food/butchery/meat)
	result = /obj/item/chems/food/stew

/decl/recipe/simmered/milosoup
	reagents = list(/decl/material/liquid/water = 10)
	fruit = list("soybeans chopped" = 2)
	items = list(
		/obj/item/chems/food/tofu = 2
	)
	result = /obj/item/chems/food/milosoup

/decl/recipe/simmered/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1, "soybeans chopped" = 2)
	result = /obj/item/chems/food/stewedsoymeat

/decl/recipe/simmered/bloodsoup
	reagents = list(/decl/material/liquid/blood = 30)
	result = /obj/item/chems/food/bloodsoup
	hidden_from_codex = TRUE

/decl/recipe/simmered/mysterysoup
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/chems/food/badrecipe,
		/obj/item/chems/food/tofu,
		/obj/item/chems/food/egg,
		/obj/item/chems/food/cheesewedge,
	)
	reagent_mix = REAGENT_REPLACE // Has its own special products
	result = /obj/item/chems/food/mysterysoup

/decl/recipe/simmered/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/drink/milk = 10)
	reagent_mix = REAGENT_REPLACE // get that milk outta here
	result = /obj/item/chems/food/mushroomsoup

/decl/recipe/simmered/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/chems/food/beetsoup

/decl/recipe/simmered/katsucurry
	fruit = list("apple" = 1, "carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10, /decl/material/liquid/nutriment/flour = 5)
	items = list(
		/obj/item/chems/food/butchery/meat/chicken
	)
	result = /obj/item/chems/food/katsucurry
