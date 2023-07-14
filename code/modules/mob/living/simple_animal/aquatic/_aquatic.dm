/mob/living/simple_animal/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	turns_per_move = 5
	speed = 4
	mob_size = MOB_SIZE_SMALL
	emote_see = list("glubs", "blubs", "bloops")
	base_animal_type = /mob/living/simple_animal/aquatic
	is_aquatic = TRUE

	meat_type = /obj/item/chems/food/fish
	meat_amount = 1
	bone_amount = 1
	skin_amount = 2
	bone_material = /decl/material/solid/bone/fish
	skin_material = /decl/material/solid/skin/fish

/mob/living/simple_animal/aquatic/Initialize()
	. = ..()
	default_pixel_x = rand(-12,12)
	default_pixel_y = rand(-12,12)
	reset_offsets(0)
