/mob/living/carbon/get_active_grabs()
	. = list()
	for(var/obj/item/grab/grab in get_held_items())
		. += grab

/mob/living/carbon/make_grab(atom/movable/target, grab_tag = /decl/grab/simple, defer_hand = FALSE, force_grab_tag = FALSE)
	grab_tag = (!force_grab_tag && species?.grab_type) || grab_tag
	return ..()
