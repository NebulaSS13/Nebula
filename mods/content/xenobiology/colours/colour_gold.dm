/decl/slime_colour/gold
	name = "gold"
	descendants = list(
		/decl/slime_colour/gold,
		/decl/slime_colour/gold,
		/decl/slime_colour/adamantine,
		/decl/slime_colour/adamantine
	)
	baby_icon =    'mods/content/xenobiology/icons/slimes/slime_baby_gold.dmi'
	adult_icon =   'mods/content/xenobiology/icons/slimes/slime_adult_gold.dmi'
	extract_icon = 'mods/content/xenobiology/icons/slimes/slime_extract_gold.dmi'
	reaction_strings = list(/decl/material/solid/metal/uranium = "Synthesises a cute critter.")
	var/list/possible_mobs = list(
		/mob/living/critter/cat,
		/mob/living/critter/cat/kitten,
		/mob/living/critter/corgi,
		/mob/living/critter/corgi/puppy,
		/mob/living/critter/cow,
		/mob/living/critter/chick,
		/mob/living/critter/chicken
	)

/decl/slime_colour/gold/handle_uranium_reaction(var/datum/reagents/holder)
	var/type = pick(possible_mobs)
	new type(get_turf(holder.my_atom))
	return TRUE
