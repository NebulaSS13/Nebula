/obj/item/food/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon = 'icons/obj/food/hotdog.dmi'
	bitesize = 2
	center_of_mass = @'{"x":16,"y":17}'
	nutriment_type = /decl/material/liquid/nutriment/bread
	material = /decl/material/solid/organic/meat

/obj/item/food/hotdog/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 6)

/obj/item/food/classichotdog
	name = "classic hotdog"
	desc = "Going literal."
	icon = 'icons/obj/food/hotcorgi.dmi'
	bitesize = 6
	center_of_mass = @'{"x":16,"y":17}'
	material = /decl/material/solid/organic/meat

/obj/item/food/classichotdog/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 16)
