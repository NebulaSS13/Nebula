/mob/living/simple_animal/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	turns_per_wander = 5
	mob_size = MOB_SIZE_SMALL
	emote_see = list("glubs", "blubs", "bloops")
	base_animal_type = /mob/living/simple_animal/aquatic
	is_aquatic = TRUE
	butchery_data = /decl/butchery_data/animal/fish/small
	holder_type = /obj/item/holder

/mob/living/simple_animal/aquatic/Initialize()
	. = ..()
	default_pixel_x = rand(-12,12)
	default_pixel_y = rand(-12,12)
	reset_offsets(0)
