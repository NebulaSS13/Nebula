/mob/living/carbon/get_active_grabs()
	. = list()
	for(var/obj/item/grab/grab in get_held_items())
		. += grab

/mob/living/carbon/make_grab(var/atom/movable/target, var/grab_tag = /decl/grab/simple)
	. = ..(target, species?.grab_type || grab_tag)

/mob/living/carbon/can_be_grabbed(var/mob/grabber, var/target_zone)
	. = ..()
	if(.)
		LAssailant = iscarbon(grabber) && grabber
