/obj/item/food/sliceable/pizza/margherita
	name = "margherita"
	desc = "The golden standard of pizzas."
	slice_path = /obj/item/food/slice/pizza/margherita
	icon = 'icons/obj/food/pizzas/pizza_margherita.dmi'

/obj/item/food/sliceable/pizza/margherita/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat,  5)
	add_to_reagents(/decl/material/liquid/drink/juice/tomato, 6)

/obj/item/food/slice/pizza/margherita
	name = "margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	whole_path = /obj/item/food/sliceable/pizza/margherita

/obj/item/food/slice/pizza/margherita/filled
	filled = TRUE
