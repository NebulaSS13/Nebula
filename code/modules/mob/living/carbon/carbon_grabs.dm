/mob/living/carbon/get_active_grabs()
	. = list()
	for(var/obj/item/grab/grab in list(l_hand, r_hand))
		. += grab

/mob/living/carbon/make_grab(var/atom/movable/target, var/grab_tag = GRAB_SIMPLE)
	. = ..(target, species?.grab_type || GRAB_SIMPLE)

/mob/living/carbon/can_be_grabbed(var/mob/grabber, var/target_zone)
	. = ..()
	if(.)
		LAssailant = iscarbon(grabber) && grabber
