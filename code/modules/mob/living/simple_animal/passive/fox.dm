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
	eye_color          = "#1d628a"
	draw_visible_overlays = list(
		"base"     = "#ed5a20",
		"markings" = "#efe9e6",
		"socks"    = "#36221b"
	)
	ability_handlers = list(/datum/ability_handler/predator)

/mob/living/simple_animal/passive/fox/get_available_postures()
	var/static/list/available_postures = list(
		/decl/posture/standing,
		/decl/posture/lying,
		/decl/posture/lying/deliberate,
		/decl/posture/sitting
	)
	return available_postures

/mob/living/simple_animal/passive/fox/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/fox)

/decl/bodytype/quadruped/animal/fox
	uid = "bodytype_animal_fox"

/decl/bodytype/quadruped/animal/fox/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list( 1,  -9),
			"[SOUTH]" = list( 1,  -8),
			"[EAST]" =  list( 11,  -9),
			"[WEST]" =  list(-11,  -9)
		)
	)
	return ..()

/datum/mob_controller/passive/hunter/fox
	emote_speech   = list("Yip!","AIEE!","YIPE!")
	emote_hear     = list("screams","yips")
	emote_see      = list("paces back and forth", "flicks its tail")

/mob/living/simple_animal/passive/fox/arctic
	name           = "arctic fox"
	desc           = "A cunning and graceful predatory mammal, known for leaping headfirst into snowbanks while hunting burrowing rodents."
	eye_color      = "#7a6f3b"
	draw_visible_overlays = list(
		"base"     = "#ccc496",
		"markings" = "#efe9e6",
		"socks"    = "#cab9b1"
	)

/mob/living/simple_animal/passive/fox/silver
	name           = "silver fox"
	desc           = "A cunning and graceful predatory mammal, known for the rarity and high value of their pelts."
	eye_color      = "#2db1c9"
	draw_visible_overlays = list(
		"base"     = "#2c2c2a",
		"markings" = "#3d3b39",
		"socks"    = "#746d66"
	)

/mob/living/simple_animal/passive/fox/sparkle
	name = "sparklefox"
	desc = "A cunning and graceful predatory mammal, known for being really into hardstyle."

/mob/living/simple_animal/passive/fox/sparkle/Initialize()
	eye_color      = get_random_colour(TRUE)
	draw_visible_overlays = list(
		"base"     = get_random_colour(),
		"markings" = get_random_colour(TRUE),
		"socks"    = get_random_colour()
	)
	. = ..()
