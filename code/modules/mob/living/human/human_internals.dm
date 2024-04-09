/mob/living/carbon/human/get_internals()
	return internal

/mob/living/carbon/human/set_internals(obj/item/tank/source, source_string)
	..()
	internal = source
	if(internals)
		internals.icon_state = "internal[!!internal]"
