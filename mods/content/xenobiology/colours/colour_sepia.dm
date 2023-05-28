/decl/slime_colour/sepia
	name = "sepia"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_sepia.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_sepia.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_sepia.dmi'
	reaction_strings = list(
		/decl/material/liquid/blood = "Synthesises a camera film refill.",
		/decl/material/solid/phoron = "Synthesises a camera."
	)

/decl/slime_colour/sepia/handle_blood_reaction(var/datum/reagents/holder)
	var/turf/location = get_turf(holder.get_reaction_loc())
	if(location)
		for(var/i in 1 to 5)
			new /obj/item/camera_film(location)
	return TRUE

/decl/slime_colour/sepia/handle_phoron_reaction(var/datum/reagents/holder)
	var/turf/location = get_turf(holder.get_reaction_loc())
	if(location)
		new /obj/item/camera(location)
	return TRUE
