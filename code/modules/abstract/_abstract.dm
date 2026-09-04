/obj/abstract
	name             = ""
	icon             = 'icons/effects/landmarks.dmi'
	icon_state       = "x2"
	simulated        = FALSE
	density          = FALSE
	anchored         = TRUE
	abstract_type    = /obj/abstract
	invisibility     = INVISIBILITY_ABSTRACT
	var/hide_on_init = TRUE

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()
	opacity       =  FALSE
	//Let mappers see the damn thing by just making them invisible here
	if(hide_on_init)
		alpha         =  0
		mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

/obj/abstract/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return
