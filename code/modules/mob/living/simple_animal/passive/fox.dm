/mob/living/simple_animal/passive/fox
	name               = "fox"
	desc               = "A cunning and graceful predatory mammal, known for its red fur and eerie screams."
	icon               = 'icons/mob/simple_animal/fox.dmi'
	natural_weapon     = /obj/item/natural_weapon/bite/weak
	ai                 = /datum/mob_controller/passive/hunter/fox
	mob_size           = MOB_SIZE_SMALL
	speak_emote        = list("yelps", "yips", "hisses", "screams")
	pass_flags         = PASS_FLAG_TABLE
	butchery_data      = /decl/butchery_data/animal/fox
	color              = "#ed5a20"
	var/markings_color = "#efe9e6"
	var/socks_color    = "#36221b"
	var/eyes_color     = "#1d628a"

/mob/living/simple_animal/passive/fox/Initialize()
	. = ..()
	update_icon()

/mob/living/simple_animal/passive/fox/on_update_icon()
	. = ..()
	add_overlay(overlay_image(icon, "[icon_state]-markings", markings_color, RESET_COLOR))
	add_overlay(overlay_image(icon, "[icon_state]-socks",    socks_color,    RESET_COLOR))
	add_overlay(overlay_image(icon, "[icon_state]-eyes",     eyes_color,     RESET_COLOR))

/datum/mob_controller/passive/hunter/fox
	emote_speech   = list("Yip!","AIEE!","YIPE!")
	emote_hear     = list("screams","yips")
	emote_see      = list("paces back and forth", "flicks its tail")

/mob/living/simple_animal/passive/fox/arctic
	name           = "arctic fox"
	desc           = "A cunning and graceful predatory mammal, known for leaping headfirst into snowbanks while hunting burrowing rodents."
	color          = "#ccc496"
	markings_color = "#efe9e6"
	socks_color    = "#cab9b1"
	eyes_color     = "#7a6f3b"

/mob/living/simple_animal/passive/fox/silver
	name           = "silver fox"
	desc           = "A cunning and graceful predatory mammal, known for the rarity and high value of their pelts."
	color          = "#2c2c2a"
	markings_color = "#3d3b39"
	socks_color    = "#746d66"
	eyes_color     = "#2db1c9"

/mob/living/simple_animal/passive/fox/sparkle
	name = "sparklefox"
	desc = "A cunning and graceful predatory mammal, known for being really into hardstyle."

/mob/living/simple_animal/passive/fox/sparkle/Initialize()
	color          = get_random_colour()
	markings_color = get_random_colour(TRUE)
	socks_color    = get_random_colour()
	eyes_color     = get_random_colour(TRUE)
	. = ..()
