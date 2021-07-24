///////////
// Pasta //
///////////

/obj/item/chems/food/spagetti
	name = "spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':16}"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 1
	bitesize = 1

/obj/item/chems/food/boiledspagetti
	name = "boiled spaghetti"
	desc = "A plain dish of pasta, just screaming for sauce."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#fcee81"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/chems/food/pastatomato
	name = "spaghetti & tomato"
	desc = "Spaghetti and crushed tomatoes."
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#de4545"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("tomato" = 3, "noodles" = 3)
	nutriment_amt = 6
	bitesize = 4

/obj/item/chems/food/pastatomato/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 10)

/obj/item/chems/food/nanopasta
	name = "nanopasta"
	desc = "Nanomachines, son!"
	icon_state = "nanopasta"
	trash = /obj/item/trash/plate
	filling_color = "#535e66"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_amt = 6
	bitesize = 4

/obj/item/chems/food/nanopasta/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nanitefluid, 10)

/obj/item/chems/food/meatballspagetti
	name = "spaghetti & meatballs"
	desc = "Now thats a nice meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#de4545"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/meatballspagetti/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/spesslaw
	name = "spaghetti & too many meatballs"
	desc = "Do you want some pasta with those meatballs?"
	icon_state = "spesslaw"
	filling_color = "#de4545"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/spesslaw/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)