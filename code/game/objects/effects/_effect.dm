/obj/effect
	abstract_type = /obj/effect

/obj/effect/ShouldSerialize(_age)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE // Typically no. Specific subtypes should reimplement this (vomit etc)

/obj/effect/can_be_grabbed(var/mob/grabber, var/target_zone)
	return FALSE

/obj/effect/try_make_grab(mob/living/user, defer_hand = FALSE)
	return FALSE

