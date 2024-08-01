/obj/item/food/fishfingers
	name = "fish fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#ffdefe"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 3

/obj/item/food/fishfingers/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)

/obj/item/food/cubancarp
	name = "\improper Cuban Carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	plate = /obj/item/plate
	filling_color = "#e9adff"
	center_of_mass = @'{"x":12,"y":5}'
	nutriment_desc = list("toasted bread" = 3)
	nutriment_amt = 3
	bitesize = 3

/obj/item/food/cubancarp/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 3)
	add_to_reagents(/decl/material/liquid/capsaicin,         3)

/obj/item/food/fishandchips
	name = "fish and chips"
	desc = "Best enjoyed wrapped in a newspaper on a cold wet day."
	icon_state = "fishandchips"
	filling_color = "#e3d796"
	center_of_mass = @'{"x":16,"y":16}'
	nutriment_desc = list("salt" = 1, "chips" = 2, "fish" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/food/fishandchips/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 3)