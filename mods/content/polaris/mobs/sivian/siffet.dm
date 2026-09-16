/mob/living/simple_animal/hostile/siffet
	name = "siffet"
	desc = "A small, solitary predator with silky fur. Despite its size, the Siffet is ferocious when provoked."
	icon = 'mods/content/polaris/icons/wildlife/siffet.dmi'
	max_health = 60
	ai = /datum/mob_controller/aggressive/siffet
	base_movement_delay = -1
	mob_size = MOB_SIZE_SMALL
	natural_weapon = /obj/item/natural_weapon/siffet_bite

/obj/item/natural_weapon/siffet_bite
	_base_attack_force = 12
	attack_cooldown = 1 SECOND
	sharp = TRUE
	attack_verb = list("sliced", "snapped", "gnawed")

/datum/mob_controller/aggressive/siffet
	emote_speech = list("Yap!", "Heh!", "Huff.")
	emote_see    = list("sniffs its surroundings","flicks its ears", "scratches the ground")
	emote_hear   = list("chatters", "huffs")
