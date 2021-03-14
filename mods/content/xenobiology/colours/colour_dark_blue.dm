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
	reaction_strings = list(/decl/material/solid/metal/uranium = "Drastically lowers the bodytemperature of surrounding creatures.")

/decl/slime_colour/dark_blue/handle_uranium_reaction(var/datum/reagents/holder)
	. = TRUE
	sleep(5 SECONDS)
	playsound(get_turf(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/M in range (get_turf(holder.my_atom), 7))
		M.bodytemperature -= 140
		to_chat(M, SPAN_WARNING("You feel a chill!"))
