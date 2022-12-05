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
	mouse_opacity = 0
	invisibility  =  INVISIBILITY_MAXIMUM+1

/obj/abstract/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/abstract/update_material(keep_health, should_update_icon)
	return

/obj/abstract/create_matter()
	return

/obj/abstract/set_material(new_material, keep_health, skip_update_material, skip_update_matter)
	return