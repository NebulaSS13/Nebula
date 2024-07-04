/mob/living/simple_animal/tomato
	name = "tomato"
	desc = "It's a horrifyingly enormous beef tomato, and it's packing extra beef!"
	icon = 'icons/mob/simple_animal/tomato.dmi'
	max_health = 15
	response_help_3p = "$USER$ pokes $TARGET$."
	response_help_1p = "You poke $TARGET$."
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite
	pass_flags = PASS_FLAG_TABLE
	butchery_data = /decl/butchery_data/animal/tomato
	ai = /datum/mob_controller/tomato

/datum/mob_controller/tomato
	speak_chance = 0
	turns_per_wander = 10
