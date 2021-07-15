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
	SSmaterials.create_object(/decl/material/solid/metal/steel, get_turf(holder.my_atom), 15, /obj/item/stack/material/cubes)
	SSmaterials.create_object(/decl/material/solid/metal/plasteel, get_turf(holder.my_atom), 5, /obj/item/stack/material/cubes)
	return TRUE
