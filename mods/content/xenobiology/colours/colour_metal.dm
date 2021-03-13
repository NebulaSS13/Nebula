/decl/slime_colour/metal
	name = "metal"
	descendants = list(
		/decl/slime_colour/silver,
		/decl/slime_colour/yellow,
		/decl/slime_colour/gold,
		/decl/slime_colour/gold
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_metal.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_metal.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_metal.dmi'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Synthesises cubes of steel and plasteel.")

/decl/slime_colour/metal/handle_uranium_reaction(var/datum/reagents/holder)
	new /obj/item/stack/material/cubes(get_turf(holder.my_atom), 15, /decl/material/solid/metal/steel)
	new /obj/item/stack/material/cubes(get_turf(holder.my_atom), 5, /decl/material/solid/metal/plasteel)
	return TRUE
