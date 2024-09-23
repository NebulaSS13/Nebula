/datum/extension/demolisher/welder
	demolish_verb = "cutting through"
	demolish_sound = 'sound/items/Welder.ogg'
	expected_type = /obj/item/weldingtool

/datum/extension/demolisher/welder/try_demolish(mob/user, turf/wall/wall)
	if(!(wall.get_material()?.removed_by_welder))
		to_chat(user, SPAN_WARNING("\The [wall] is too delicate to be dismantled with \the [holder]; try a hammer or crowbar."))
		return TRUE
	var/obj/item/weldingtool/welder = holder
	if(welder.weld(0,user))
		return ..()
	return TRUE

/datum/extension/demolisher/welder/get_demolish_delay(turf/wall/wall)
	return ..() * 0.7
