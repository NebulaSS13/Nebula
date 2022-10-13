//A temporary effect that does not DO anything except look pretty.
/obj/effect/temporary
	anchored = TRUE
	max_health = OBJ_HEALTH_NO_DAMAGE
	mouse_opacity = 0
	density = FALSE
	layer = ABOVE_HUMAN_LAYER

/obj/effect/temporary/Initialize(var/mapload, var/duration = 30, var/_icon = 'icons/effects/effects.dmi', var/_state)
	. = ..()
	icon = _icon
	icon_state = _state
	QDEL_IN(src, duration)