/decl/slime_colour/oil
	name = "oil"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_oil.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_oil.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_oil.dmi'
	reaction_strings = list(/decl/material/solid/phoron = "Causes a violent explosion after a few seconds. Run!")

/decl/slime_colour/oil/handle_phoron_reaction(var/datum/reagents/holder)
	. = TRUE
	sleep(5 SECONDS)
	var/location = holder.get_reaction_loc()
	if(location)
		explosion(location, 1, 3, 6)
