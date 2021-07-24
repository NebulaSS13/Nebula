/obj/item/chems/food/sliceable/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delcious cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/chems/food/cheesewedge
	slices_num = 5
	filling_color = "#fff700"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cheese" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/sliceable/cheesewheel/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#fff700"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':10}"

// todo: non-cheddar cheeses