/obj/effect/effect/cig_smoke
	name = "smoke"
	icon_state = "smallsmoke"
	icon = 'icons/effects/effects.dmi'
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = FALSE
	layer = ABOVE_HUMAN_LAYER

	var/time_to_live = 3 SECONDS

/obj/effect/effect/cig_smoke/Initialize()
	. = ..()
	set_dir(pick(GLOB.cardinal))
	pixel_x = rand(0, 13)
	pixel_y = rand(0, 13)
	return INITIALIZE_HINT_LATELOAD

/obj/effect/effect/cig_smoke/LateInitialize()
	animate(src, alpha = 0, time_to_live, easing = EASE_IN)
	QDEL_IN(src, time_to_live)
