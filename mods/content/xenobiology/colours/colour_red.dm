/decl/slime_colour/red
	name = "red"
	descendants = list(
		/decl/slime_colour/red,
		/decl/slime_colour/red,
		/decl/slime_colour/oil,
		/decl/slime_colour/oil
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_red.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_red.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_red.dmi'
	reaction_strings = list(/decl/material/liquid/blood = "Causes all nearby slimes to enter a berserk rage.")

/decl/slime_colour/red/handle_blood_reaction(var/datum/reagents/holder)
	for(var/mob/living/slime/slime in viewers(get_turf(holder.my_atom), 7))
		var/datum/ai/slime/slime_ai = slime.ai
		if(istype(slime_ai))
			slime_ai.rabid = TRUE
			slime.visible_message(SPAN_DANGER("\The [slime] is driven into a frenzy!"))
	return TRUE
