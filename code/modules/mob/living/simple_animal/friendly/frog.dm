/mob/living/simple_animal/frog
	name = "green frog"
	desc = "A small, slimy amphibian. Likes to eat flies."
	icon = 'icons/mob/simple_animal/frog_green.dmi'
	speak_emote = list("ribbits","croaks")
	response_harm = "stamps on"
	density = FALSE
	holder_type = /obj/item/holder
	mob_size = MOB_SIZE_MINISCULE
	max_health = 5
	butchery_data = /decl/butchery_data/animal/small/frog
	ai = /datum/mob_controller/frog

/datum/mob_controller/frog
	emote_speech = list("Ribbit!","Riiibit!")
	emote_hear = list("ribbits","croaks")
	emote_see = list("hops","inflates its vocal sac","catches a fly with its tongue")
	speak_chance = 0.25

/mob/living/simple_animal/frog/brown
	name = "brown frog"
	icon = 'icons/mob/simple_animal/frog_brown.dmi'

/mob/living/simple_animal/frog/yellow
	name = "yellow frog"
	icon = 'icons/mob/simple_animal/frog_yellow.dmi'

/mob/living/simple_animal/frog/purple
	name = "purple frog"
	icon = 'icons/mob/simple_animal/frog_purple.dmi'
