/mob/living/brain/death(gibbed)
	var/obj/item/organ/holder = loc
	. = ..()
	if(.)
		if(stat == DEAD && istype(holder))
			holder.die()

/mob/living/brain/gib(do_gibs = TRUE)
	var/obj/item/organ/internal/brain/sponge = loc
	. = ..()
	if(. && istype(sponge) && !QDELETED(sponge))
		qdel(sponge)
