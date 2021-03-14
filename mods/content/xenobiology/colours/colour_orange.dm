/decl/slime_colour/orange
	name = "orange"
	descendants = list(
		/decl/slime_colour/dark_purple,
		/decl/slime_colour/yellow,
		/decl/slime_colour/red,
		/decl/slime_colour/red
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_orange.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_orange.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_orange.dmi'
	reaction_strings = list(
		/decl/material/liquid/blood =        "Synthesises a small amount of caspaicin.",
		/decl/material/solid/metal/uranium = "Causes a violent conflagration after a few seconds. Run!"
	)

/decl/slime_colour/orange/handle_blood_reaction(var/datum/reagents/holder)
	holder.add_reagent(/decl/material/liquid/capsaicin, 10)
	return TRUE

/decl/slime_colour/orange/handle_uranium_reaction(var/datum/reagents/holder)
	. = TRUE
	sleep(5 SECONDS)
	if(holder?.my_atom?.loc)
		var/turf/location = get_turf(holder.my_atom)
		location.assume_gas(/decl/material/gas/hydrogen, 250, 1400)
		location.hotspot_expose(700, 400)
