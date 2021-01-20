/datum/forensics/fibers
	name = "fibers and microparticles"
	remove_on_transfer = TRUE

/datum/forensics/fibers/add_from_atom(atom/movable/AM)
	if(!AM)
		return
	var/list/sources
	if(istype(AM, /obj/item/clothing/))
		LAZYADD(sources, AM)
	else if(ishuman(AM))
		var/mob/living/carbon/human/M = AM
		var/covered = 0
		for(var/obj/item/clothing/C in list(M.wear_suit, M.gloves, M.w_uniform))
			if(prob(15) && (C.body_parts_covered & ~covered))
				LAZYADD(sources, C)
			covered |= C.body_parts_covered

	for(var/obj/item/clothing/C in sources)
		add_data(C.get_fibers())

/datum/forensics/fibers/spot_message(mob/detective, atom/location)
	to_chat(detective, SPAN_NOTICE("You notice some fibers embedded in \the [location]."))