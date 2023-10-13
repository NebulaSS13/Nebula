/obj/effect/decal
	layer = DECAL_LAYER

/obj/effect/decal/fall_damage()
	return 0

/obj/effect/decal/lava_act()
	. = !throwing ? ..() : FALSE
