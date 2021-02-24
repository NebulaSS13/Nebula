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
		/mob/living/simple_animal/cat,
		/mob/living/simple_animal/cat/kitten,
		/mob/living/simple_animal/corgi,
		/mob/living/simple_animal/corgi/puppy,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/chicken
	)

/decl/slime_colour/gold/handle_uranium_reaction(var/datum/reagents/holder)
	var/type = pick(possible_mobs)
	new type(get_turf(holder.my_atom))
	return TRUE
