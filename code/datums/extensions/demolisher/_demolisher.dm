// A subtype for items that can dismantle/demolish non-reinforced non-natural walls.
/datum/extension/demolisher
	base_type = /datum/extension/demolisher
	expected_type = /obj/item
	var/demolish_delay = 6 SECONDS
	var/demolish_verb
	var/demolish_sound

/datum/extension/demolisher/New(datum/holder, _delay, _verb, _sound)
	. = ..()
	if(_delay)
		demolish_delay = _delay
	if(_verb)
		demolish_verb = _verb
	if(_sound)
		demolish_sound = _sound

/datum/extension/demolisher/proc/get_demolish_delay(turf/wall/wall)
	return demolish_delay + wall?.get_material()?.cut_delay

/datum/extension/demolisher/proc/get_demolish_verb()
	return demolish_verb

/datum/extension/demolisher/proc/get_demolish_sound()
	return demolish_sound

/datum/extension/demolisher/proc/try_demolish(mob/user, turf/wall/wall)
	var/dismantle_verb  = get_demolish_verb()
	var/dismantle_sound = get_demolish_sound()
	to_chat(user, SPAN_NOTICE("You begin [dismantle_verb] \the [wall]."))
	if(dismantle_sound)
		playsound(wall, dismantle_sound, 100, 1)
	var/cut_delay = max(0, get_demolish_delay(wall))
	if(do_after(user, cut_delay, wall))
		to_chat(user, SPAN_NOTICE("You finish [dismantle_verb] \the [wall]."))
		user.visible_message(SPAN_DANGER("\The [user] finishes [dismantle_verb] \the [wall]!"))
		wall.dismantle_turf()
	return TRUE
