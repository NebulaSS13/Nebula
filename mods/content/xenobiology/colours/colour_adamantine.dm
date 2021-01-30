/decl/slime_colour/adamantine
	name = "adamantine"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_adamantine.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_adamantine.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_adamantine.dmi'
	reaction_strings = list(
		/decl/material/liquid/blood = "Synthesies some crystallizing agent.",
		/decl/material/solid/metal/uranium = "Create a rune that will allow ghosts to join as loyal golems."
	)

/decl/slime_colour/adamantine/handle_blood_reaction(var/datum/reagents/holder)
	holder.add_reagent(/decl/material/liquid/crystal_agent, 10)
	return TRUE

/decl/slime_colour/adamantine/handle_uranium_reaction(var/datum/reagents/holder)
	var/obj/effect/golemrune/Z = new /obj/effect/golemrune(get_turf(holder.my_atom))
	Z.announce_to_ghosts()
	return TRUE
