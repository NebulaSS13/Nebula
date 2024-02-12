/mob/living/simple_animal/hostile/retaliate/aquatic/carp
	name = "carp"
	desc = "A ferocious fish. May be too hardcore."
	icon = 'icons/mob/simple_animal/fish_carp.dmi'
	faction = "fishes"
	maxHealth = 20
	health = 20
	meat_type = /obj/item/chems/food/fish/carp

/mob/living/simple_animal/hostile/retaliate/aquatic/carp/Initialize()
	. = ..()
	default_pixel_x = rand(-8,8)
	default_pixel_y = rand(-8,8)
	reset_offsets(0)