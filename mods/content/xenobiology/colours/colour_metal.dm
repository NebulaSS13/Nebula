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
	reaction_strings = list(/decl/material/solid/phoron = "Synthesises cubes of steel and plasteel.")

/decl/slime_colour/metal/handle_phoron_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		SSmaterials.create_object(/decl/material/solid/metal/steel, location, 15, /obj/item/stack/material/cubes)
		SSmaterials.create_object(/decl/material/solid/metal/plasteel, location, 5, /obj/item/stack/material/cubes)
	return TRUE
