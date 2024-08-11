// mobs do not have blocked mouths by default
// overridden in human_defense.dm
/mob/proc/check_mouth_coverage()
	return null

/mob/proc/get_eaten_transfer_amount(var/default)
	. = default
	if(issmall(src))
		. = ceil(.*0.5)

/mob/proc/can_eat_food_currently(obj/eating, mob/user)
	return TRUE
