/decl/slime_colour/quantum
	name = "quantum"
	baby_icon =      'mods/content/xenobiology/icons/slimes/slime_baby_quantum.dmi'
	adult_icon =     'mods/content/xenobiology/icons/slimes/slime_adult_quantum.dmi'
	extract_icon =   'mods/content/xenobiology/icons/slimes/slime_extract_quantum.dmi'
	reaction_sound = 'sound/effects/teleport.ogg'
	reaction_strings = list(/decl/material/solid/phoron = "Randomly teleports everything around the core.")

/decl/slime_colour/quantum/handle_phoron_reaction(var/datum/reagents/holder)
	var/turf/location = get_turf(holder.get_reaction_loc())
	if(location)
		var/list/turfs = RANGE_TURFS(location, 6)
		if(length(turfs))
			for(var/atom/movable/AM in viewers(location, 2))
				if(AM.simulated && !AM.anchored)
					AM.dropInto(pick(turfs))
	return TRUE
