/obj/item/food/sliceable/pizza/meatpizza
	name = "meatpizza"
	desc = "A pizza with meat topping."
	slice_path = /obj/item/food/slice/pizza/meat
	nutriment_amt = 10
	icon = 'icons/obj/food/pizzas/pizza_meat.dmi'

/obj/item/food/sliceable/pizza/meatpizza/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat,  34)
	add_to_reagents(/decl/material/liquid/nutriment/barbecue, 6)

/obj/item/food/slice/pizza/meat
	name = "meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	whole_path = /obj/item/food/sliceable/pizza/meatpizza

/obj/item/food/slice/pizza/meat/filled
	filled = TRUE
