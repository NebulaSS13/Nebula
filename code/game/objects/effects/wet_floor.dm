// Visual marker and data holder for slippery floors.
/atom/movable/wet_floor
	icon = 'icons/effects/water.dmi'
	icon_state = "wet_floor"
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	simulated = FALSE
	var/wetness = 0
	var/image/wet_overlay = null
	var/wet_timer_id

/atom/movable/wet_floor/Initialize()
	. = ..()
	name = ""
	verbs.Cut()

/atom/movable/wet_floor/proc/unwet_floor()
	var/turf/myturf = loc
	if(istype(myturf))
		myturf.unwet_floor()
