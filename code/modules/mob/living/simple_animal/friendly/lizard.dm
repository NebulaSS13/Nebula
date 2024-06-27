/mob/living/simple_animal/lizard
	name = "lizard"
	desc = "A cute tiny lizard."
	icon = 'icons/mob/simple_animal/lizard.dmi'
	speak_emote = list("hisses")
	max_health = 5
	natural_weapon = /obj/item/natural_weapon/bite/weak
	response_harm = "stamps on"
	mob_size = MOB_SIZE_MINISCULE
	possession_candidate = 1
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	butchery_data = /decl/butchery_data/animal/reptile/small

/mob/living/simple_animal/lizard/get_remains_type()
	return /obj/item/remains/lizard
