/datum/extension/demolisher/delicate
	demolish_verb = "dismantling"
	demolish_sound = 'sound/items/Crowbar.ogg'
	var/alternative_tools = "a sledgehammer or welding torch" // For overriding on medieval maps.

/datum/extension/demolisher/delicate/try_demolish(mob/user, turf/wall/wall)
	if(!(wall.get_material()?.removed_by_welder))
		return ..()
	to_chat(user, SPAN_WARNING("\The [wall] is too robust to be dismantled with \the [holder]; try [alternative_tools]."))
	return TRUE

/datum/extension/demolisher/delicate/get_demolish_delay(turf/wall/wall)
	return ..() * 1.2
