/**
	Returns whether this object is damaged.
 */
/obj/proc/is_damaged()
	return can_take_damage() && (current_health < get_max_health())

/**
	Returns TRUE if this object can take damage.
 */
/obj/proc/can_take_damage()
	return (current_health != ITEM_HEALTH_NO_DAMAGE) && (get_max_health() != ITEM_HEALTH_NO_DAMAGE)

/**
	Returns the percentage of health remaining for this object.
 */
/obj/proc/get_percent_health()
	return can_take_damage()? round((current_health * 100)/get_max_health(), HEALTH_ROUNDING) : 100

/**
	Returns the percentage of damage done to this object.
 */
/obj/proc/get_percent_damages()
	//Clamp from 0 to 100 so health values larger than max health don't return unhelpful numbers
	return clamp(100 - get_percent_health(), 0, 100)

