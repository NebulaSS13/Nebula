/decl/slime_colour/sepia
	name = "sepia"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_sepia.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_sepia.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_sepia.dmi'
	reaction_strings = list(
		/decl/material/liquid/blood =        "Synthesises a camera film refill.",
		/decl/material/solid/metal/uranium = "Synthesises a camera."
	)

/decl/slime_colour/sepia/handle_blood_reaction(var/datum/reagents/holder)
	for(var/i in 1 to 5)
		new /obj/item/camera_film(get_turf(holder.my_atom))
	return TRUE

/decl/slime_colour/sepia/handle_uranium_reaction(var/datum/reagents/holder)
	new /obj/item/camera(get_turf(holder.my_atom))
	return TRUE
