/mob/living/simple_animal/hostile/tree
	name = "pine tree"
	desc = "A pissed off tree-like alien. It seems annoyed with the festivities..."
	icon = 'icons/mob/simple_animal/pinetree.dmi'
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/chems/food/fish
	speed = -1
	mob_default_max_health = 250
	pixel_x = -16
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite

	//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0
	faction = "carp"

/mob/living/simple_animal/hostile/tree/FindTarget()
	. = ..()
	if(.)
		audible_emote("growls at [.]")

/mob/living/simple_animal/hostile/tree/death(gibbed, deathmessage, show_dead_message)
	..(null,"is hacked into pieces!", show_dead_message)
	var/decl/material/mat = GET_DECL(/decl/material/solid/organic/wood)
	mat.place_shards(loc)
	qdel(src)