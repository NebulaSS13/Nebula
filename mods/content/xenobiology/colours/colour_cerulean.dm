/decl/slime_colour/cerulean
	name = "cerulean"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_cerulean.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_cerulean.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_cerulean.dmi'
	reaction_strings = list(/decl/material/solid/phoron = "Synthesises a steroid that can enhance a slime core to have three uses.")

/decl/slime_colour/cerulean/handle_phoron_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		new /obj/item/slime_extract_enhancer(location)
	return TRUE
