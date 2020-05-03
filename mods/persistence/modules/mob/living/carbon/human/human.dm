/mob/living/carbon/human/after_deserialize()
	// This refreshes/rebuilds the UI.
	for(var/obj/item/I in contents)
		I.hud_layerise()
	. = ..()