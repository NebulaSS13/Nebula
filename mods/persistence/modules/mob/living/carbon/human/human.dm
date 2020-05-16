/mob/living/carbon/human
	var/obj/home_spawn		// The object we last safe-slept on. Used for moving characters to safe locations on loads.

/mob/living/carbon/human/after_deserialize()
	// This refreshes/rebuilds the UI.
	for(var/obj/item/I in contents)
		I.hud_layerise()
	. = ..()