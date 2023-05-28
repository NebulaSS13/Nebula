/decl/slime_colour/dark_purple
	name = "dark purple"
	descendants = list(
		/decl/slime_colour/purple,
		/decl/slime_colour/sepia,
		/decl/slime_colour/orange,
		/decl/slime_colour/orange
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_darkpurple.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_darkpurple.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_darkpurple.dmi'
	reaction_strings = list(/decl/material/solid/phoron = "Synthesises some phoron.")

/decl/slime_colour/dark_purple/handle_phoron_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		SSmaterials.create_object(/decl/material/solid/phoron, location, 10, /obj/item/stack/material/cubes)
	return TRUE
