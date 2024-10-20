///////////
// Pasta //
///////////

/obj/item/food/spagetti
	name = "spaghetti"
	desc = "A bundle of raw spaghetti."
	icon = 'icons/obj/food/pasta/rawspaghetti.dmi'
	filling_color = "#eddd00"
	center_of_mass = @'{"x":16,"y":16}'
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 1
	bitesize = 1

/obj/item/food/boiledspagetti
	name = "boiled spaghetti"
	desc = "A plain dish of pasta, just screaming for sauce."
	icon = 'icons/obj/food/pasta/spaghetti.dmi'
	plate = /obj/item/plate
	filling_color = "#fcee81"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/food/pastatomato
	name = "spaghetti & tomato"
	desc = "Spaghetti and crushed tomatoes."
	icon = 'icons/obj/food/pasta/tomato_spaghetti.dmi'
	plate = /obj/item/plate
	filling_color = "#de4545"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("tomato" = 3, "noodles" = 3)
	nutriment_amt = 6
	bitesize = 4

/obj/item/food/pastatomato/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/drink/juice/tomato, 10)

/obj/item/food/nanopasta
	name = "nanopasta"
	desc = "Nanomachines, son!"
	icon = 'icons/obj/food/pasta/nanopasta.dmi'
	plate = /obj/item/plate
	filling_color = "#535e66"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_amt = 6
	bitesize = 4

/obj/item/food/nanopasta/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nanitefluid, 10)

/obj/item/food/meatballspagetti
	name = "spaghetti & meatballs"
	desc = "Now thats a nice meatball!"
	icon = 'icons/obj/food/pasta/meatball_spaghetti.dmi'
	plate = /obj/item/plate
	filling_color = "#de4545"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/food/meatballspagetti/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)

/obj/item/food/spesslaw
	name = "spaghetti & too many meatballs"
	desc = "Do you want some pasta with those meatballs?"
	icon = 'icons/obj/food/pasta/extra_meatball_spaghetti.dmi'
	filling_color = "#de4545"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/food/spesslaw/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)
