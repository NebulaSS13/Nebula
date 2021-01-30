/decl/slime_colour/light_pink
	name = "light pink"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_lightpink.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_lightpink.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_lightpink.dmi'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Synthesises a potion that turns an adult slime into a docile pet.")

/decl/slime_colour/light_pink/handle_uranium_reaction(var/datum/reagents/holder)
	new /obj/item/slime_potion/advanced(get_turf(holder.my_atom))
	return TRUE
