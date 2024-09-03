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
	var/fur_color      = "#e6e5da"
	var/markings_color = "#c8b1a5"
	var/socks_color    = "#5c5552"
	var/eyes_color     = COLOR_BLACK

/datum/mob_controller/passive/rabbit
	emote_hear = list("chitters")
	emote_see = list("hops","lifts its head","sniffs the air","wiggles its tail")
	speak_chance = 0.25

/mob/living/simple_animal/passive/rabbit/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/rabbit)

/decl/bodytype/quadruped/animal/rabbit
	uid = "bodytype_animal_rabbit"


/mob/living/simple_animal/passive/rabbit/get_eye_colour()
	return eyes_color

/mob/living/simple_animal/passive/rabbit/refresh_visible_overlays()
	set_current_mob_overlay(HO_SKIN_LAYER,
		list(
			overlay_image(icon, icon_state,              fur_color,      RESET_COLOR),
			overlay_image(icon, "[icon_state]-markings", markings_color, RESET_COLOR),
			overlay_image(icon, "[icon_state]-socks",    socks_color,    RESET_COLOR)
		)
	)
	. = ..()

/mob/living/simple_animal/passive/rabbit/brown
	name = "brown rabbit"
	butchery_data = /decl/butchery_data/animal/rabbit/brown
	fur_color      = "#62472b"
	markings_color = "#958279"
	socks_color    = "#9c8b78"

/mob/living/simple_animal/passive/rabbit/black
	name = "black rabbit"
	butchery_data = /decl/butchery_data/animal/rabbit/black
	fur_color      = "#4f4f4f"
	markings_color = "#958279"
	socks_color    = "#838279"

/mob/living/simple_animal/passive/rabbit/sparkle
	name = "sparklerabbit"
	desc = "A hopping mammal with long ears and a love for raves."

/mob/living/simple_animal/passive/rabbit/sparkle/Initialize()
	fur_color      = get_random_colour()
	markings_color = get_random_colour(TRUE)
	socks_color    = get_random_colour()
	eyes_color     = get_random_colour(TRUE)
	. = ..()
