/atom/proc/get_weather_protection()
	return

/atom/proc/gives_weather_protection()
	return FALSE

/mob/get_weather_protection()
	var/list/loc_protection = isturf(loc) && loc.get_weather_protection()
	if(loc_protection)
		LAZYADD(., loc_protection)
	for(var/obj/item/brolly in get_held_items())
		if(brolly.gives_weather_protection())
			LAZYADD(., brolly)
	var/obj/item/clothing/head/check_head = get_equipped_item(slot_head_str)
	if(istype(check_head) && check_head.protects_against_weather)
		LAZYADD(., check_head)
	var/obj/item/clothing/suit/check_body = get_equipped_item(slot_wear_suit_str)
	if(istype(check_body) && check_body.protects_against_weather)
		LAZYADD(., check_body)

/turf/get_weather_protection()
	for(var/obj/structure/flora/tree/tree in range(1, src))
		if(tree.protects_against_weather)
			LAZYADD(., tree)

/atom/proc/get_weather_exposure()
	CRASH("Something called get_weather_exposure on a non-turf, non-object, non-mob, non-area type!")

/area/get_weather_exposure()
	CRASH("Something called get_weather_exposure on an area!")

/turf/get_weather_exposure()
	if(is_outside())
		// A roof isn't protecting us from the weather, do we have anything else blocking it?
		var/list/weather_protection = get_weather_protection()
		if(LAZYLEN(weather_protection))
			return WEATHER_PROTECTED
		return WEATHER_EXPOSED
	// We're under a roof or otherwise shouldn't be being rained on.
	// For non-multiz we'll give everyone some nice ambience.
	if(!HasAbove(z))
		return WEATHER_ROOFED

	// For multi-z, check the actual weather on the turf above.
	// TODO: maybe make this a property of the z-level marker.
	var/turf/above = GetAbove(src)
	if(above.weather)
		return WEATHER_ROOFED

	// Being more than one level down should exempt us from ambience.
	return WEATHER_IGNORE

/atom/movable/get_weather_exposure()
	// We're inside something else.
	if(!isturf(loc))
		return WEATHER_IGNORE

	. = loc.get_weather_exposure()
	if(. != WEATHER_EXPOSED)
		return .

	// Our loc isn't protecting us from the weather, is anything about us protecting us?
	var/list/weather_protection = get_weather_protection()
	if(LAZYLEN(weather_protection))
		return WEATHER_PROTECTED

	return WEATHER_EXPOSED