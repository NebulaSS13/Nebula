/mob/living/simple_animal/hostile/hivebot/strong
	desc = "A junky looking robot with four spiky legs - this one has thick armour plating."
	max_health = 120
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT
	)
	ai = /datum/mob_controller/aggressive/hivebot_strong

/datum/mob_controller/aggressive/hivebot_strong
	can_escape_buckles = TRUE

/mob/living/simple_animal/hostile/hivebot/strong/has_ranged_attack()
	return TRUE
