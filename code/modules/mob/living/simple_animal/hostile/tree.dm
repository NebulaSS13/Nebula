/mob/living/simple_animal/hostile/tree
	name = "pine tree"
	desc = "A pissed off tree-like alien. It seems annoyed with the festivities..."
	icon = 'icons/mob/simple_animal/pinetree.dmi'
	butchery_data = null
	max_health = 250
	pixel_x = -16
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite
	ai = /datum/mob_controller/aggressive/tree
	base_movement_delay = -1

	// For 12 years, this comment has implied trees are a kind of space carp.
	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0
	faction = "carp"

/datum/mob_controller/aggressive/tree
	speak_chance = 0
	turns_per_wander = 10

/datum/mob_controller/aggressive/tree/find_target()
	. = ..()
	if(.)
		body.custom_emote(AUDIBLE_MESSAGE, "growls at [.]")

/mob/living/simple_animal/hostile/tree/check_has_mouth()
	return FALSE

/mob/living/simple_animal/hostile/tree/get_death_message(gibbed)
	return "is hacked into pieces!"

/mob/living/simple_animal/hostile/tree/death(gibbed)
	. = ..()
	if(. && !gibbed)
		var/decl/material/mat = GET_DECL(/decl/material/solid/organic/wood)
		mat.place_shards(loc)
		qdel(src)
