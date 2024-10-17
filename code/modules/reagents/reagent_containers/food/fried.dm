/////////////////
// Fried Foods //
/////////////////

// Also contains unfried fried foods.

/obj/item/food/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon = 'icons/obj/food/fried/onionrings.dmi'
	plate = /obj/item/plate
	filling_color = "#eddd00"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/food/fries
	name = "chips"
	desc = "Frenched potato, fried."
	icon = 'icons/obj/food/fried/fries.dmi'
	plate = /obj/item/plate
	filling_color = "#eddd00"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("fresh fries" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/food/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon = 'icons/obj/food/fried/cheesyfries.dmi'
	plate = /obj/item/plate
	filling_color = "#eddd00"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_desc = list("fresh fries" = 3, "cheese" = 3)
	nutriment_amt = 4
	bitesize = 2

/obj/item/food/cheesyfries/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/cheese, 2)
