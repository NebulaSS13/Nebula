/obj/machinery/holopad/proc/get_audience()
	. = list()
	if(!incoming_connection)
		for(var/mob/living/listener in range(7, targetpad))
			. += listener
		for(var/mob/living/listener in range(7, sourcepad))
			. |= listener
	for(var/mob/living/silicon/ai/master in masters)
		. |= master
	if(length(.))
		for(var/mob/observer/ghost/ghost in get_ghosts())
			if(ghost.client && ghost.get_preference_value(/datum/client_preference/ghost_ears) == PREF_ALL_SPEECH)
				. |= ghost
	for(var/obj/machinery/holopad/holopad in .)
		. -= holopad

/obj/machinery/holopad/show_message(msg, type, alt, alt_type, atom/source)
	. = ..()
	if(last_message == msg || istype(source, /obj/machinery/holopad))
		return
	if(length(masters) || ((sourcepad || targetpad) && !incoming_connection))
		last_message = msg
		var/list/local_audience = get_mobs_or_objects_in_view(7, get_turf(src), TRUE, FALSE)
		for(var/mob/listener in get_audience())
			if(!(listener in local_audience))
				listener.show_message("<i><small>\icon[src] [capitalize(strip_improper(name))] relayed:</small></i> [msg]", type, source)

/obj/machinery/holopad/see_signlang(message, verb = "gestures", decl/language/language, mob/speaker, prefix)
	if(length(masters) || ((sourcepad || targetpad) && !incoming_connection))
		prefix ||= "<i><small>\icon[src] [capitalize(strip_improper(name))] relayed:</small></i>"
		var/list/local_audience = get_mobs_or_objects_in_view(7, get_turf(speaker), TRUE, FALSE)
		for(var/mob/listener in get_audience())
			if(listener != speaker && !(listener in local_audience))
				listener.see_signlang(message, verb, language, speaker, prefix)

/obj/machinery/holopad/hear_talk(mob/living/speaker, datum/speech/phrases, verb, stars = FALSE, decl/language/force_language)
	..()
	var/phrase_msg = "\ref[speaker]: [istype(phrases) ? phrases.formatted_message : phrases]"
	if(last_message == phrase_msg)
		return
	if(length(masters) || ((sourcepad || targetpad) && !incoming_connection))
		last_message = phrase_msg
		var/list/local_audience = get_mobs_or_objects_in_view(7, get_turf(speaker), TRUE, FALSE)
		for(var/mob/listener in get_audience())
			if(listener != speaker && !(listener in local_audience))
				listener.hear_say(phrases, verb, speaker = speaker, relayed_by = src)
