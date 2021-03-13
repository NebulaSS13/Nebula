/decl/slime_colour/blue
	name = "blue"
	descendants = list(
		/decl/slime_colour/dark_blue,
		/decl/slime_colour/silver,
		/decl/slime_colour/pink,
		/decl/slime_colour/pink
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_blue.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_blue.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_blue.dmi'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Synthesises a small amount of frost oil.")

/decl/slime_colour/blue/handle_uranium_reaction(var/datum/reagents/holder)
	holder.add_reagent(/decl/material/liquid/frostoil, 10)
	return TRUE
