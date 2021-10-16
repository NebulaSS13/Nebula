/mob/living/silicon/ai/death(gibbed, deathmessage, show_dead_message)

	if(stat == DEAD)
		return

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))


	remove_ai_verbs(src)

	for(var/obj/machinery/ai_status_display/O in SSmachines.machinery)
		O.mode = 2

	if (istype(loc, /obj/item/aicard))
		var/obj/item/aicard/card = loc
		card.update_icon()

	. = ..(gibbed,"gives one shrill beep before falling lifeless.", "You have suffered a critical system failure, and are dead.")
	set_density(1)
