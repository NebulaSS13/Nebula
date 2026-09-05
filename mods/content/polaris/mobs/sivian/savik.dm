/mob/living/simple_animal/hostile/savik
	name = "savik"
	icon = 'mods/content/polaris/icons/wildlife/savik.dmi'
	ai = /datum/mob_controller/aggressive/savik
	max_health = 125
	base_movement_delay = 0

/*
	melee_damage_lower = 15
	melee_damage_upper = 35
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	melee_attack_delay = 1 SECOND
	attacktext = list("mauled")
*/

/datum/mob_controller/aggressive/savik
	emote_speech = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")
