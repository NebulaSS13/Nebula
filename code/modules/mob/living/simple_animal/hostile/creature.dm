/mob/living/simple_animal/hostile/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/simple_animal/creature.dmi'
	speak_emote = list("gibbers")
	max_health = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	faction = "creature"
	supernatural = 1
	ability_handlers = list(/datum/ability_handler/predator)
