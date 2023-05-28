/decl/slime_colour/pyrite
	name = "pyrite"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_pyrite.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_pyrite.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_pyrite.dmi'
	reaction_strings = list(/decl/material/solid/phoron = "Synthesises a random bucket of paint.")

/decl/slime_colour/pyrite/handle_phoron_reaction(var/datum/reagents/holder)
	var/turf/location = get_turf(holder.get_reaction_loc())
	if(location)
		new /obj/item/chems/glass/paint/random(location)
	return TRUE
