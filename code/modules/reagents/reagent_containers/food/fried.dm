/////////////////
// Fried Foods //
/////////////////

// Also contains unfried fried foods.

/obj/item/chems/food/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/fries
	name = "chips"
	desc = "Frenched potato, fried."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("fresh fries" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/rawsticks
	name = "raw potato sticks"
	desc = "Uncooked potato stick, not very tasty."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	nutriment_desc = list("raw potato" = 3)
	nutriment_amt = 3

/obj/item/chems/food/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("fresh fries" = 3, "cheese" = 3)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/cheesyfries/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)
