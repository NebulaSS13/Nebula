/decl/slime_colour/quantum
	name = "quantum"
	baby_icon =      'mods/content/xenobiology/icons/slimes/slime_baby_quantum.dmi'
	adult_icon =     'mods/content/xenobiology/icons/slimes/slime_adult_quantum.dmi'
	extract_icon =   'mods/content/xenobiology/icons/slimes/slime_extract_quantum.dmi'
	reaction_sound = 'sound/effects/teleport.ogg'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Randomly teleports everything around the core.")

/decl/slime_colour/quantum/handle_uranium_reaction(var/datum/reagents/holder)
	var/list/turfs = RANGE_TURFS(holder.my_atom, 6)
	if(length(turfs))
		for(var/atom/movable/AM in viewers(holder.my_atom, 2))
			if(AM.simulated && !AM.anchored)
				AM.dropInto(pick(turfs))
	return TRUE
