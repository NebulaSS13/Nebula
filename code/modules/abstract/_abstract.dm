/obj/abstract
	name =          ""
	icon =          'icons/effects/landmarks.dmi'
	icon_state =    "x2"
	simulated =     FALSE
	density =       FALSE
	anchored =      TRUE
	unacidable =    TRUE
	abstract_type = /obj/abstract

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()
	//Let mappers see the damn thing by just making them invisible here
	opacity       =  FALSE
	alpha         =  0
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	invisibility  =  INVISIBILITY_MAXIMUM+1

/obj/abstract/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return
