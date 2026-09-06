/mob/living/human/get_internals()
	return internal

/mob/living/human/set_internals(obj/item/tank/source, source_string)
	..()
	internal = source
	refresh_hud_element(HUD_INTERNALS)
