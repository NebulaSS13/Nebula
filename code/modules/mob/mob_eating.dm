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

#define EATING_NO_ISSUE      0
#define EATING_NBP_MOUTH     1
#define EATING_BLOCKED_MOUTH 2

/mob/proc/can_eat_status()
	if(!check_has_mouth())
		return list(EATING_NBP_MOUTH)
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return list(EATING_BLOCKED_MOUTH, blocked)
	return list(EATING_NO_ISSUE)

/mob/proc/can_eat(food, feedback = TRUE)
	var/list/status = can_eat_status()
	if(status[1] == EATING_NO_ISSUE)
		return TRUE
	if(feedback)
		if(status[1] == EATING_NBP_MOUTH)
			to_chat(src, SPAN_WARNING("Where do you intend to put \the [food]? You don't have a mouth!"))
		else if(status[1] == EATING_BLOCKED_MOUTH)
			to_chat(src, SPAN_WARNING("\The [status[2]] is in the way!"))
	return FALSE

/mob/proc/can_force_feed(mob/target, food, feedback = TRUE)
	if(src == target)
		return can_eat(food)
	var/list/status = target.can_eat_status()
	if(status[1] == EATING_NO_ISSUE)
		return TRUE
	if(feedback)
		if(status[1] == EATING_NBP_MOUTH)
			to_chat(src, SPAN_WARNING("Where do you intend to put \the [food]? \The [target] doesn't have a mouth!"))
		else if(status[1] == EATING_BLOCKED_MOUTH)
			to_chat(src, SPAN_WARNING("\The [status[2]] is in the way!"))
	return FALSE

#undef EATING_NO_ISSUE
#undef EATING_NBP_MOUTH
#undef EATING_BLOCKED_MOUTH
