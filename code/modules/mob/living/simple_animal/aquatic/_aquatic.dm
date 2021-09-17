/mob/living/simple_animal/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	turns_per_move = 5
	speed = 4
	mob_size = MOB_SIZE_SMALL
	emote_see = list("glubs", "blubs", "bloops")

	// They only really care if there's water around them or not.
	max_gas = list()
	min_gas = list()
	minbodytemp = 0

	meat_type = /obj/item/chems/food/fish
	meat_amount = 3
	bone_amount = 5
	skin_amount = 5
	bone_material = /decl/material/solid/bone/fish
	skin_material = /decl/material/solid/skin/fish

/mob/living/simple_animal/aquatic/Initialize()
	. = ..()
	default_pixel_x = rand(-12,12)
	default_pixel_y = rand(-12,12)
	reset_offsets(0)

/mob/living/simple_animal/aquatic/Life()
	if(!submerged())
		walk(src, 0)
		SET_STATUS_MAX(src, STAT_PARA, 3)
	. = ..()
	update_icon()

/mob/living/simple_animal/aquatic/on_update_icon()
	. = ..()
	if(stat != DEAD && HAS_STATUS(src, STAT_PARA))
		icon_state += "-dying"

/mob/living/simple_animal/aquatic/handle_atmos(var/atmos_suitable = 1)
	. = ..(atmos_suitable = submerged())
