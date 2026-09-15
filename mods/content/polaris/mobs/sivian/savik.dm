/mob/living/simple_animal/hostile/savik
	name = "savik"
	icon = 'mods/content/polaris/icons/wildlife/savik.dmi'
	ai = /datum/mob_controller/aggressive/savik
	max_health = 125
	base_movement_delay = 0
	natural_weapon = /obj/item/natural_attack/savik_claws

/obj/item/natural_attack/savik_claws
	_base_attack_force = 20
	armor_penetration = 15
	sharp = TRUE
	attack_cooldown = 1 SECOND
	attack_verb = list("mauled")

/datum/mob_controller/aggressive/savik
	emote_speech = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")
