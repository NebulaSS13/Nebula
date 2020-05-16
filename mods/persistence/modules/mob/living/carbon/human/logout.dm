/mob/living/carbon/human/Initialize()
	. = ..()

	// Safety check. If a character spawned outside of a saved area, we want to move them to their last spawn.
	if(!(z in SSmapping.saved_levels))
		if(istype(home_spawn))
			if(locate(/mob) in get_turf(home_spawn))
				gib() // Someone or something was in your bed/cryopod.
			else
				forceMove(get_turf(home_spawn)) // Welcome home!
		else
			gib() // Sorry man. Your bed/cryopod was not set.

	// Check if humans are asleep on startup.
	if(!istype(client))
		goto_sleep()


/mob/living/carbon/human/Logout()
	. = ..()
	addtimer(CALLBACK(src, /mob/living/carbon/human/proc/goto_sleep), 5 MINUTES)

	var/obj/bed = locate(/obj/structure/bed) in get_turf(src)
	var/obj/cryopod = locate(/obj/machinery/cryopod) in get_turf(src)
	if(istype(bed))
		// We logged out in a bed or cryopod. Set this as home_spawn.
		home_spawn = bed
	if(istype(cryopod))
		// We logged out in a bed or cryopod. Set this as home_spawn.
		home_spawn = cryopod

/mob/living/carbon/human/proc/goto_sleep()
	if(istype(client))
		// We have a client, so we're awake.
		return

	if(locate(/obj/structure/bed) in get_turf(src))
		SetStasis(20, STASIS_SLEEP) // beds are better.
		return

	//Apply sleeping stasis.
	SetStasis(10, STASIS_SLEEP)