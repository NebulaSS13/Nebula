/mob/living/simple_animal/passive/fox
	name           = "fox"
	desc           = "A cunning and graceful predatory mammal, known for its red fur and eerie screams."
	icon           = 'icons/mob/simple_animal/fox.dmi'
	natural_weapon = /obj/item/natural_weapon/bite/weak
	ai             = /datum/mob_controller/passive/hunter/fox
	mob_size       = MOB_SIZE_SMALL
	speak_emote    = list("yelps", "yips", "hisses", "screams")
	pass_flags     = PASS_FLAG_TABLE
	butchery_data  = /decl/butchery_data/animal/fox

/datum/mob_controller/passive/hunter/fox
	emote_speech   = list("Yip!","AIEE!","YIPE!")
	emote_hear     = list("screams","yips")
	emote_see      = list("paces back and forth", "flicks its tail")
