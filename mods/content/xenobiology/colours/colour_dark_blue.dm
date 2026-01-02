/decl/slime_colour/dark_blue
	name = "dark blue"
	descendants = list(
		/decl/slime_colour/purple,
		/decl/slime_colour/cerulean,
		/decl/slime_colour/blue,
		/decl/slime_colour/blue
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_darkblue.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_darkblue.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_darkblue.dmi'
	reaction_strings = list(/decl/material/solid/phoron = "Drastically lowers the bodytemperature of surrounding creatures.")

/decl/slime_colour/dark_blue/handle_phoron_reaction(var/datum/reagents/holder)
	. = TRUE
	sleep(5 SECONDS)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		playsound(location, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/M in range(location, 7))
			M.bodytemperature -= 140
			to_chat(M, SPAN_WARNING("You feel a chill!"))
