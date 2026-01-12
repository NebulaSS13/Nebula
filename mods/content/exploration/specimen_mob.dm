// Mob helpers/overrides.
/mob/living/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/obj/item/gps/specimen_tag/xenotag = locate() in src
	if(istype(xenotag) && xenotag.has_been_implanted())
		. += "\The [src] has been tagged with \a [xenotag]."
