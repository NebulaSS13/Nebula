/mob/living/simple_animal/hostile/siffet
	name = "siffet"
	desc = "A small, solitary predator with silky fur. Despite its size, the Siffet is ferocious when provoked."
	icon = 'mods/content/polaris/icons/wildlife/siffet.dmi'
	max_health = 60
	ai = /datum/mob_controller/aggressive/siffet
	base_movement_delay = -1
	mob_size = MOB_SIZE_SMALL

/*
	melee_damage_lower = 10
	melee_damage_upper = 15
	base_attack_cooldown = 1 SECOND
	attack_sharp = 1
	attacktext = list("sliced", "snapped", "gnawed")
*/

/datum/mob_controller/aggressive/siffet
	emote_speech = list("Yap!", "Heh!", "Huff.")
	emote_see    = list("sniffs its surroundings","flicks its ears", "scratches the ground")
	emote_hear   = list("chatters", "huffs")
