/obj/item/food/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "Vegetarian pizza, huh? What about all the plants that were slaughtered to make this, huh!? Hypocrite."
	slice_path = /obj/item/food/slice/pizza/vegetable
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	icon = 'icons/obj/food/pizzas/pizza_vegetable.dmi'

/obj/item/food/sliceable/pizza/vegetablepizza/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat,  5)
	add_to_reagents(/decl/material/liquid/nutriment/ketchup,  6)
	add_to_reagents(/decl/material/liquid/eyedrops,           12)

/obj/item/food/slice/pizza/vegetable
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	whole_path = /obj/item/food/sliceable/pizza/vegetablepizza

/obj/item/food/slice/pizza/vegetable/filled
	filled = TRUE
