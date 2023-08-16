/mob/living/Initialize()
	. = ..()
	if(isSynthetic())
		overlay_fullscreen("synthetic_scanline", /obj/screen/fullscreen/scanline, null)
	else
		overlay_fullscreen("synthetic_noise",    /obj/screen/fullscreen/noise,    null)