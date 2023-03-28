/mob/living/simple_animal/hostile/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/simple_animal/creature.dmi'
	speak_emote = list("gibbers")
	health = 100
	maxHealth = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	faction = "creature"
	speed = 4
	supernatural = 1

/mob/living/simple_animal/hostile/creature/cult
	faction = "cult"
	min_gas = null
	max_gas = null
	minbodytemp = 0

/mob/living/simple_animal/hostile/creature/cult/on_defilement()
	return