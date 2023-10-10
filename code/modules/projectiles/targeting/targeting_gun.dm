//Removing the lock and the buttons.
/obj/item/gun/dropped(var/mob/living/user)
	if(istype(user))
		user.stop_aiming(src)
	return ..()

/obj/item/gun/equipped(var/mob/living/user, var/slot)
	if(istype(user) && !(slot in user.get_held_item_slots()))
		user.stop_aiming(src)
	return ..()

//Compute how to fire.....
//Return 1 if a target was found, 0 otherwise.
/obj/item/gun/proc/PreFire(var/atom/A, var/mob/living/user, var/params)
	return istype(user) && user.aim_at(A, src)
