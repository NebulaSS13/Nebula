/obj/effect/melee_marker
	icon          = 'icons/effects/markers.dmi'
	icon_state    = "arrow_white"
	abstract_type = /obj/effect/melee_marker

/obj/effect/melee_marker/Initialize()
	. = ..()
	name = null
	verbs.Cut()
	alpha = 0
	animate(src, alpha = 255, time = 2)
	animate(alpha = 0, time = 5)
	QDEL_IN(src, 7)

/obj/effect/melee_marker/miss
	color = COLOR_RED

/obj/effect/melee_marker/hit
	color = COLOR_GREEN
