/mob/living/simple_animal/passive/wolf
	name               = "wolf"
	desc               = "A predatory canine commonly known to run in packs and howl at the moon."
	icon               = 'icons/mob/simple_animal/wolf.dmi'
	natural_weapon     = /obj/item/natural_weapon/bite
	ai                 = /datum/mob_controller/passive/hunter/wolf
	mob_size           = MOB_SIZE_MEDIUM
	speak_emote        = list("huffs", "growls")
	pass_flags         = PASS_FLAG_TABLE
	butchery_data      = /decl/butchery_data/animal/wolf
	var/fur_color      = "#6a6a6d"
	var/markings_color = "#574938"
	var/socks_color    = "#41414d"
	var/eyes_color     = "#9b7214"

/datum/mob_controller/passive/hunter/wolf
	emote_speech   = list("Awoo!","Aroo!","Rrr!")
	emote_hear     = list("huffs","growls")
	emote_see      = list("paces back and forth", "flicks its tail")

/mob/living/simple_animal/passive/wolf/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/wolf)

/decl/bodytype/quadruped/animal/wolf
	uid = "bodytype_animal_wolf"

/mob/living/simple_animal/passive/wolf/get_eye_colour()
	return eyes_color

/mob/living/simple_animal/passive/wolf/refresh_visible_overlays()
	set_current_mob_overlay(HO_SKIN_LAYER,
		list(
			overlay_image(icon, icon_state,              fur_color,      RESET_COLOR),
			overlay_image(icon, "[icon_state]-markings", markings_color, RESET_COLOR),
			overlay_image(icon, "[icon_state]-socks",    socks_color,    RESET_COLOR)
		)
	)
	. = ..()

/mob/living/simple_animal/passive/wolf/sparkle
	name = "sparklewolf"
	desc = "A predatory canine commonly known to watch speedruns and take party drugs."

/mob/living/simple_animal/passive/wolf/sparkle/Initialize()
	fur_color      = get_random_colour()
	markings_color = get_random_colour(TRUE)
	socks_color    = get_random_colour()
	eyes_color     = get_random_colour(TRUE)
	. = ..()
