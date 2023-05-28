/decl/slime_colour/yellow
	name = "yellow"
	descendants = list(
		/decl/slime_colour/quantum,
		/decl/slime_colour/metal,
		/decl/slime_colour/orange,
		/decl/slime_colour/orange
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_yellow.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_yellow.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_yellow.dmi'
	reaction_strings = list(
		/decl/material/liquid/blood = "Causes a localized electromagnetic pulse.",
		/decl/material/solid/phoron = "Converts a slime core into a portable power source.",
		/decl/material/liquid/water = "Converts a slime core into a portable light source."
	)

/decl/slime_colour/yellow/Initialize()
	. = ..()
	LAZYSET(reaction_procs, /decl/material/liquid/water, TYPE_PROC_REF(/decl/slime_colour/yellow, try_water_reaction))

/decl/slime_colour/yellow/handle_blood_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		empulse(location, 3, 7)
	return TRUE

/decl/slime_colour/yellow/handle_phoron_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		new /obj/item/cell/slime(location)
	return TRUE

/decl/slime_colour/yellow/proc/try_water_reaction(var/datum/reagents/holder)
	return handle_water_reaction(holder)
/decl/slime_colour/yellow/proc/handle_water_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		new /obj/item/flashlight/slime(location)
	return TRUE
