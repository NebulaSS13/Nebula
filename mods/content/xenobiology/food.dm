/decl/recipe/slimetoast
	reagents = list(/decl/material/liquid/slimejelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread,
	)
	result = /obj/item/chems/food/jelliedtoast/slime

/decl/recipe/jellydonut/slime
	reagents = list(/decl/material/liquid/slimejelly = 5, /decl/material/liquid/nutriment/sugar = 5)
	items = list(
		/obj/item/chems/food/dough
	)
	result = /obj/item/chems/food/donut/slimejelly

/decl/recipe/slimeburger
	reagents = list(/decl/material/liquid/slimejelly = 5)
	items = list(
		/obj/item/chems/food/bun
	)
	result = /obj/item/chems/food/jellyburger/slime

/decl/recipe/slimesandwich
	reagents = list(/decl/material/liquid/slimejelly = 5)
	items = list(
		/obj/item/chems/food/slice/bread = 2,
	)
	result = /obj/item/chems/food/jellysandwich/slime

/decl/recipe/slimesoup
	reagents = list(/decl/material/liquid/water = 10, /decl/material/liquid/slimejelly = 5)
	items = list()
	result = /obj/item/chems/food/slimesoup

/obj/item/chems/food/jellysandwich/slime/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)

/obj/item/chems/food/jelliedtoast/slime/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)

/obj/item/chems/food/jellyburger/slime/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)


/obj/item/chems/food/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup"//nonexistant?
	filling_color = "#c4dba0"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/slimesoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/chems/food/donut/slimejelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_amt = 3
	bitesize = 5

/obj/item/chems/food/donut/slimejelly/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted jelly donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

/obj/item/chems/food/mysterysoup/get_random_fillings()
	. = ..() + list(list(
		/decl/material/liquid/slimejelly = 10,
		/decl/material/liquid/water =      10
	))

/obj/item/chems/food/donut/chaos/get_random_fillings()
	. = ..() + /decl/material/liquid/slimejelly
