/mob/living/carbon/get_internals()
	return internal

/mob/living/carbon/set_internals(obj/item/tank/source, source_string)
	..()
	internal = source
	var/obj/screen/internals = get_hud_element(/decl/hud_element/internals)
	if(internals)
		internals.icon_state = "internal[!!internal]"
