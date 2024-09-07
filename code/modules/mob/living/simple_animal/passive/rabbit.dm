/mob/living/simple_animal/passive/rabbit
	name = "white rabbit"
	desc = "A hopping mammal with long ears and a love for carrots."
	icon = 'icons/mob/simple_animal/rabbit.dmi'
	max_health = 20
	natural_weapon = /obj/item/natural_weapon/bite/weak
	speak_emote = list("chitters")
	mob_size = MOB_SIZE_SMALL
	butchery_data = /decl/butchery_data/animal/rabbit
	holder_type = /obj/item/holder
	ai = /datum/mob_controller/passive/rabbit
	butchery_data      = /decl/butchery_data/animal/rabbit
	eye_color = COLOR_BLACK
	draw_visible_overlays = list(
		"base"     = "#e6e5da",
		"markings" = "#c8b1a5",
		"socks"    = "#e6e5da"
	)

/datum/mob_controller/passive/rabbit
	emote_hear = list("chitters")
	emote_see = list("hops","lifts its head","sniffs the air","wiggles its tail")
	speak_chance = 0.25

/mob/living/simple_animal/passive/rabbit/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/rabbit)

/decl/bodytype/quadruped/animal/rabbit
	uid = "bodytype_animal_rabbit"

/mob/living/simple_animal/passive/rabbit/brown
	name = "brown rabbit"
	butchery_data = /decl/butchery_data/animal/rabbit/brown
	draw_visible_overlays = list(
		"base"     = "#62472b",
		"markings" = "#958279",
		"socks"    = "#62472b"
	)

/mob/living/simple_animal/passive/rabbit/black
	name = "black rabbit"
	butchery_data = /decl/butchery_data/animal/rabbit/black
	draw_visible_overlays = list(
		"base"     = "#4f4f4f",
		"markings" = "#958279",
		"socks"    = "#4f4f4f"
	)

/mob/living/simple_animal/passive/rabbit/sparkle
	name = "sparklerabbit"
	desc = "A hopping mammal with long ears and a love for raves."

/mob/living/simple_animal/passive/rabbit/sparkle/Initialize()
	eye_color     = get_random_colour(TRUE)
	draw_visible_overlays = list(
		"base"     = get_random_colour(),
		"markings" = get_random_colour(TRUE),
		"socks"    = get_random_colour()
	)
	. = ..()
