//A temporary effect that does not DO anything except look pretty.
/obj/effect/temporary
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	density = FALSE
	layer = ABOVE_HUMAN_LAYER

/obj/effect/temporary/Initialize(var/mapload, var/duration = 30, var/_icon = 'icons/effects/effects.dmi', var/_state)
	. = ..()
	icon = _icon
	icon_state = _state
	QDEL_IN(src, duration)