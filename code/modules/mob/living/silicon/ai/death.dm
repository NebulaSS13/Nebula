/mob/living/silicon/ai/death(gibbed)
	. = ..()
	if(.)
		eyeobj?.setLoc(get_turf(src))
		remove_ai_verbs(src)
		for(var/obj/machinery/ai_status_display/O in SSmachines.machinery)
			O.mode = 2
		if (istype(loc, /obj/item/aicard))
			var/obj/item/aicard/card = loc
			card.update_icon()
		set_density(TRUE)
