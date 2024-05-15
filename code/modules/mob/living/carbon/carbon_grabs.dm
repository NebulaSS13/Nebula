/mob/living/carbon/get_active_grabs()
	. = list()
	for(var/obj/item/grab/grab in get_held_items())
		. += grab
