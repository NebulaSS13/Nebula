//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	wrapper_color = COLOR_PINK

/obj/item/pill_bottle/happy/WillContain()
	return list(/obj/item/chems/pill/happy = 10)

/obj/item/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	wrapper_color = COLOR_BLUE

/obj/item/pill_bottle/zoom/WillContain()
	return list(/obj/item/chems/pill/zoom = 10)

/obj/item/pill_bottle/gleam
	name = "bottle of Gleam pills"
	desc = "Highly illegal drug. Stimulates rarely used portions of the brain."
	wrapper_color = COLOR_BLUE

/obj/item/pill_bottle/gleam/WillContain()
	return list(/obj/item/chems/pill/gleam = 10)

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
	update_icon()

/obj/item/chems/glass/beaker/vial/random/populate_reagents()
	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		add_to_reagents(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/liquid_type in reagents.liquid_volumes)
		var/decl/material/liquid = GET_DECL(liquid_type)
		names += liquid.get_reagent_name(reagents, MAT_PHASE_LIQUID)

	for(var/solid_type in reagents.solid_volumes)
		var/decl/material/solid = GET_DECL(solid_type)
		names += solid.get_reagent_name(reagents, MAT_PHASE_SOLID)

	desc = "Contains [english_list(names)]."