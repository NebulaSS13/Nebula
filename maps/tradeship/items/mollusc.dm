/obj/item/mollusc/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.species.get_bodytype(H) == SPECIES_YINGLET)
		user.visible_message(SPAN_NOTICE("\The [user] cracks open \the [src] with their shelltooth."))
		crack_shell(user)
		return
	. = ..()
