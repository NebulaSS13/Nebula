/obj/abstract
	name =          ""
	mouse_opacity = 0
	alpha =         0
	simulated =     FALSE
	density =       FALSE
	opacity =       FALSE
	anchored =      TRUE
	invisibility =  INVISIBILITY_MAXIMUM

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()

/obj/abstract/weather_system/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return
