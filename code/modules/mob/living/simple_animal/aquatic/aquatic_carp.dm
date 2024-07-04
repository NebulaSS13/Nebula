/mob/living/simple_animal/hostile/aquatic/carp
	name = "carp"
	desc = "A ferocious fish. May be too hardcore."
	icon = 'icons/mob/simple_animal/fish_carp.dmi'
	faction = "fishes"
	max_health = 20
	butchery_data = /decl/butchery_data/animal/fish/carp

/mob/living/simple_animal/hostile/aquatic/carp/Initialize()
	. = ..()
	default_pixel_x = rand(-8,8)
	default_pixel_y = rand(-8,8)
	reset_offsets(0)