/decl/slime_colour/oil
	name = "oil"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_oil.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_oil.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_oil.dmi'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Causes a violent explosion after a few seconds. Run!")

/decl/slime_colour/oil/handle_uranium_reaction(var/datum/reagents/holder)
	. = TRUE
	sleep(5 SECONDS)
	explosion(get_turf(holder.my_atom), 1, 3, 6)
