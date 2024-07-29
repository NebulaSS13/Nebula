/decl/recipe/simmered
	abstract_type = /decl/recipe/simmered

/decl/recipe/simmered/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/food/meatball)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result = /obj/item/food/meatballsoup

/decl/recipe/simmered/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result = /obj/item/food/vegetablesoup

/decl/recipe/simmered/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/food/egg
	)
	reagent_mix = REAGENT_REPLACE // Remove extra water and egg
	result = /obj/item/food/nettlesoup

/decl/recipe/simmered/wishsoup
	reagents = list(/decl/material/liquid/water = 20)
	reagent_mix = REAGENT_REPLACE // Remove extra water
	result= /obj/item/food/wishsoup
	container_categories = list(RECIPE_CATEGORY_MICROWAVE)

/decl/recipe/simmered/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/food/butchery/cutlet)
	result = /obj/item/food/hotchili

/decl/recipe/simmered/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/food/butchery/cutlet)
	result = /obj/item/food/coldchili

/decl/recipe/simmered/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/food/tomatosoup

/decl/recipe/simmered/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	items = list(/obj/item/food/butchery/meat)
	result = /obj/item/food/stew

/decl/recipe/simmered/milosoup
	reagents = list(/decl/material/liquid/water = 10)
	fruit = list("soybeans chopped" = 2)
	items = list(
		/obj/item/food/tofu = 2
	)
	result = /obj/item/food/milosoup

/decl/recipe/simmered/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1, "soybeans chopped" = 2)
	result = /obj/item/food/stewedsoymeat

/decl/recipe/simmered/bloodsoup
	reagents = list(/decl/material/liquid/blood = 30)
	result = /obj/item/food/bloodsoup
	hidden_from_codex = TRUE

/decl/recipe/simmered/mysterysoup
	reagents = list(/decl/material/liquid/water = 10)
	items = list(
		/obj/item/food/badrecipe,
		/obj/item/food/tofu,
		/obj/item/food/egg,
		/obj/item/food/cheesewedge,
	)
	reagent_mix = REAGENT_REPLACE // Has its own special products
	result = /obj/item/food/mysterysoup

/decl/recipe/simmered/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list(/decl/material/liquid/drink/milk = 10)
	reagent_mix = REAGENT_REPLACE // get that milk outta here
	result = /obj/item/food/mushroomsoup

/decl/recipe/simmered/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/decl/material/liquid/water = 10)
	result = /obj/item/food/beetsoup

/decl/recipe/simmered/katsucurry
	fruit = list("apple" = 1, "carrot" = 1, "potato" = 1)
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/nutriment/rice = 10, /decl/material/liquid/nutriment/flour = 5)
	items = list(
		/obj/item/food/butchery/meat/chicken
	)
	result = /obj/item/food/katsucurry
