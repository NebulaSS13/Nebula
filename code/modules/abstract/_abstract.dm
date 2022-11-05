/obj/abstract
	name =          ""
	icon =          'icons/effects/landmarks.dmi'
	icon_state =    "x2"
	mouse_opacity = 0
	alpha =         0
	simulated =     FALSE
	density =       FALSE
	opacity =       FALSE
	anchored =      TRUE
	unacidable =    TRUE
	invisibility =  INVISIBILITY_MAXIMUM+1
	is_spawnable_type = FALSE
	abstract_type = /obj/abstract

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()

/obj/abstract/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return
