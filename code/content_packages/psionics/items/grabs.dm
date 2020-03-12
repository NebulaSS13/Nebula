/obj/item/grab/attack(mob/M, mob/living/user)
	if(ishuman(user) && affecting == M)
		var/mob/living/carbon/human/H = user
		if(H.check_psi_grab(src))
			return
	. = ..()