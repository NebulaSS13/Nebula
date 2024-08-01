/obj/item/food/sliceable/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delcious cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/food/cheesewedge
	slice_num = 5
	filling_color = "#fff700"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("cheese" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/food/sliceable/cheesewheel/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 10)

/obj/item/food/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#fff700"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":10}'

// todo: non-cheddar cheeses