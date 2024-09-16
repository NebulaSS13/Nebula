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
	eye_color          = "#9b7214"
	ability_handlers = list(/datum/ability_handler/predator)

	draw_visible_overlays = list(
		"base"     = "#6a6a6d",
		"markings" = "#574938",
		"socks"    = "#41414d"
	)

/datum/mob_controller/passive/hunter/wolf
	emote_speech   = list("Awoo!","Aroo!","Rrr!")
	emote_hear     = list("huffs","growls")
	emote_see      = list("paces back and forth", "flicks its tail")

/mob/living/simple_animal/passive/wolf/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/wolf)

/decl/bodytype/quadruped/animal/wolf
	uid = "bodytype_animal_wolf"

/mob/living/simple_animal/passive/wolf/sparkle
	name = "sparklewolf"
	desc = "A predatory canine commonly known to watch speedruns and take party drugs."

/mob/living/simple_animal/passive/wolf/sparkle/Initialize()
	draw_visible_overlays = list(
		"base"     = get_random_colour(),
		"markings" = get_random_colour(TRUE),
		"socks"    = get_random_colour()
	)
	eye_color = get_random_colour(TRUE)
	. = ..()
