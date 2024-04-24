/obj/item/chems/food/bun/get_combined_food_products()
	var/list/combined_food_products = ..()
	LAZYSET(combined_food_products, /obj/item/slime_extract, /obj/item/chems/food/jellyburger)
	return combined_food_products

/decl/recipe/slimetoast
	display_name = "slime toast"
	reagents = list(/decl/material/liquid/slimejelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread,
	)
	result = /obj/item/chems/food/jelliedtoast/slime

/decl/recipe/slimedonut
	display_name = "slime jelly donut"
	reagents = list(/decl/material/liquid/slimejelly = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/donut/jelly/slime

/decl/recipe/slimesandwich
	display_name = "slime sandwich"
	reagents = list(/decl/material/liquid/slimejelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread = 2,
	)
	result = /obj/item/chems/food/jellysandwich/slime

/decl/recipe/slimesoup
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/slimejelly = 5)
	items = list()
	result = /obj/item/chems/food/slimesoup

/obj/item/chems/food/jellysandwich/slime/populate_reagents()
	add_to_reagents(/decl/material/liquid/slimejelly, 5)
	. = ..()

/obj/item/chems/food/jelliedtoast/slime/populate_reagents()
	add_to_reagents(/decl/material/liquid/slimejelly, 5)
	. = ..()

/obj/item/chems/food/jellyburger/slime/populate_reagents()
	add_to_reagents(/decl/material/liquid/slimejelly, 5)
	. = ..()

/obj/item/chems/food/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup"//nonexistant?
	filling_color = "#c4dba0"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'
	utensil_flags = UTENSIL_FLAG_SCOOP

/obj/item/chems/food/slimesoup/populate_reagents()
	add_to_reagents(/decl/material/liquid/slimejelly, 5)
	add_to_reagents(/decl/material/liquid/water, 10)
	. = ..()

/obj/item/chems/food/donut/jelly/slime
	name = "jelly donut"
	desc = "You jelly?"
	filling_color = "#ed1169"
	center_of_mass = @'{"x":16,"y":11}'
	nutriment_amt = 3
	bitesize = 5
	jelly_type = /decl/material/liquid/slimejelly

/obj/item/chems/food/mysterysoup/get_random_fillings()
	. = ..() + list(list(
		/decl/material/liquid/slimejelly = 10,
		/decl/material/liquid/water =      10
	))

/obj/item/chems/food/donut/chaos/get_random_fillings()
	. = ..() + /decl/material/liquid/slimejelly
