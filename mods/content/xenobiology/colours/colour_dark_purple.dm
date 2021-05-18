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
	reaction_strings = list(/decl/material/solid/metal/uranium = "Synthesises some metallic hydrogen.")

/decl/slime_colour/dark_purple/handle_uranium_reaction(var/datum/reagents/holder)
	SSmaterials.create_object(/decl/material/solid/metallic_hydrogen, get_turf(holder.my_atom), 10, /obj/item/stack/material/cubes)
	return TRUE
