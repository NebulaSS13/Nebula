/obj/item/grab/attack(mob/M, mob/living/user)
	if(ishuman(user) && affecting == M)
		var/mob/living/human/H = user
		if(H.check_psi_grab(src))
			return
	. = ..()