/decl/slime_colour/purple
	name = "purple"
	descendants = list(
		/decl/slime_colour/dark_purple,
		/decl/slime_colour/dark_blue,
		/decl/slime_colour/green,
		/decl/slime_colour/green
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_purple.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_purple.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_purple.dmi'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Synthesises a steroid capable of causing a slime to create additional slime cores.")

/decl/slime_colour/purple/handle_uranium_reaction(var/datum/reagents/holder)
	new /obj/item/slime_steroid(get_turf(holder.my_atom))
	return TRUE
