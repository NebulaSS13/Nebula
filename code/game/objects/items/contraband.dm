//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	wrapper_color = COLOR_PINK
	startswith = list(/obj/item/chems/pill/happy = 10)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	wrapper_color = COLOR_BLUE
	startswith = list(/obj/item/chems/pill/zoom = 10)

/obj/item/storage/pill_bottle/gleam
	name = "bottle of Gleam pills"
	desc = "Highly illegal drug. Stimulates rarely used portions of the brain."
	wrapper_color = COLOR_BLUE
	startswith = list(/obj/item/chems/pill/gleam = 10)

/obj/item/chems/glass/beaker/vial/random
	atom_flags = 0
	var/list/random_reagent_list = list(list(/decl/material/liquid/water = 15) = 1, list(/decl/material/liquid/cleaner = 15) = 1)

/obj/item/chems/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list(/decl/material/liquid/hallucinogenics = 10)    = 2,
		list(/decl/material/liquid/psychoactives = 20)      = 2,
		list(/decl/material/liquid/carpotoxin = 15)   = 2,
		list(/decl/material/liquid/narcotics = 15)          = 2,
		list(/decl/material/liquid/zombiepowder = 10) = 1
	)

/obj/item/chems/glass/beaker/vial/random/Initialize()
	. = ..()

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/reagent_type in reagents.reagent_volumes)
		var/decl/material/R = GET_DECL(reagent_type)
		names += R.liquid_name

	desc = "Contains [english_list(names)]."
	update_icon()
