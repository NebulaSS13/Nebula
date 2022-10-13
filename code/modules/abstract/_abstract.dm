/obj/abstract
	name =          ""
	icon =          'icons/effects/landmarks.dmi'
	icon_state =    "x2"
	simulated =     FALSE
	density =       FALSE
	anchored =      TRUE
	abstract_type = /obj/abstract
	max_health =    OBJ_HEALTH_NO_DAMAGE

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()
	//Let mappers see the damn thing by just making them invisible here
	opacity       =  FALSE
	alpha         =  0
	mouse_opacity = 0
	invisibility  =  INVISIBILITY_MAXIMUM+1

/obj/abstract/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return
