/obj/item/food/bun/get_combined_food_products()
	var/list/combined_food_products = ..()
	LAZYSET(combined_food_products, /obj/item/slime_extract, /obj/item/food/jellyburger)
	return combined_food_products

/decl/recipe/slimetoast
	display_name = "slime toast"
	reagents = list(/decl/material/liquid/slimejelly = 5)
	items = list(
		/obj/item/food/slice/bread,
	)
	result = /obj/item/food/jelliedtoast/slime

/decl/recipe/slimedonut
	display_name = "slime jelly donut"
	reagents = list(/decl/material/liquid/slimejelly = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/food/dough
	)
	result = /obj/item/food/donut/jelly/slime

/decl/recipe/slimesandwich
	display_name = "slime sandwich"
	reagents = list(/decl/material/liquid/slimejelly = 5)
	items = list(
		/obj/item/food/slice/bread = 2,
	)
	result = /obj/item/food/jellysandwich/slime

/obj/item/food/jellysandwich/slime/populate_reagents()
	add_to_reagents(/decl/material/liquid/slimejelly, 5)
	. = ..()

/obj/item/food/jelliedtoast/slime/populate_reagents()
	add_to_reagents(/decl/material/liquid/slimejelly, 5)
	. = ..()

/obj/item/food/jellyburger/slime/populate_reagents()
	add_to_reagents(/decl/material/liquid/slimejelly, 5)
	. = ..()

/obj/item/chems/glass/bowl/mapped/slime
	initial_reagent_type = /decl/material/liquid/slimejelly

/obj/item/food/donut/jelly/slime
	name = "jelly donut"
	desc = "You jelly?"
	filling_color = "#ed1169"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_amt = 3
	bitesize = 5
	jelly_type = /decl/material/liquid/slimejelly

/obj/item/chems/glass/bowl/mystery/get_random_fillings()
	. = ..() + list(list(
		/decl/material/liquid/slimejelly = 10,
		/decl/material/liquid/water =      10
	))

/obj/item/food/donut/chaos/get_random_fillings()
	. = ..() + /decl/material/liquid/slimejelly
