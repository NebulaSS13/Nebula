/decl/slime_colour/silver
	name = "silver"
	descendants = list(
		/decl/slime_colour/metal,
		/decl/slime_colour/pyrite,
		/decl/slime_colour/blue,
		/decl/slime_colour/blue
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_silver.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_silver.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_silver.dmi'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Synthesises a large amount of food.")
	var/static/list/borks = subtypesof(/obj/item/chems/food)

/decl/slime_colour/silver/handle_uranium_reaction(var/datum/reagents/holder)
	var/location = get_turf(holder.get_reaction_loc())
	if(location)
		playsound(location, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in viewers(location, null))
			if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
				M.flash_eyes()
		for(var/i = 1, i <= 4 + rand(1,2), i++)
			var/chosen = pick(borks)
			var/obj/B = new chosen(location)
			if(B)
				if(prob(50))
					for(var/j = 1, j <= rand(1, 3), j++)
						step(B, pick(NORTH, SOUTH, EAST, WEST))
	return TRUE
