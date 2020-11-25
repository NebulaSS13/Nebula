/datum/forensics/fibers
	name = "fibers and microparticles"
	remove_on_transfer = TRUE

/datum/forensics/fibers/add_from_atom(mob/living/carbon/human/M)
	if(!istype(M))
		return
	var/covered = 0
	for(var/obj/item/clothing/C in list(M.wear_suit, M.gloves, M.w_uniform))
		if(prob(15) && (C.body_parts_covered & ~covered))
			add_data(C.get_fibers())
		covered |= C.body_parts_covered

/datum/forensics/fibers/spot_message(mob/detective, atom/location)
	to_chat(detective, SPAN_NOTICE("You notice some fibers embedded in \the [location]."))