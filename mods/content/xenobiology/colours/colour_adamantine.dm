/decl/slime_colour/adamantine
	name = "adamantine"
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_adamantine.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_adamantine.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_adamantine.dmi'
	reaction_strings = list(
		/decl/material/liquid/blood = "Synthesizes some crystallizing agent.",
		/decl/material/solid/phoron = "Create a rune that will allow ghosts to join as loyal golems."
	)

/decl/slime_colour/adamantine/handle_blood_reaction(var/datum/reagents/holder)
	holder.add_reagent(/decl/material/liquid/crystal_agent, 10)
	return TRUE

/decl/slime_colour/adamantine/handle_phoron_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		var/obj/effect/golemrune/Z = new(location)
		Z.announce_to_ghosts()
	return TRUE
