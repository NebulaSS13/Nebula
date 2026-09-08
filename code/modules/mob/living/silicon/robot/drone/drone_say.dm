/mob/living/silicon/robot/drone/say(datum/speech/phrases, verb = "says", whispering)
	if(local_transmit)
		if (src.client)
			if(client.prefs.muted & MUTE_IC)
				to_chat(src, "You cannot send IC messages (muted).")
				return 0

		var/message = sanitize(istype(phrases) ? phrases.unformatted_message : phrases) // we don't care about languages etc. for drones, so don't parse it into a datum.
		if (stat == DEAD)
			return say_dead(message)

		if(findlasttextEx(message, get_prefix_key(/decl/prefix/custom_emote)) == 1)
			return emote(copytext(message,2))

		if(findlasttextEx(message, get_prefix_key(/decl/prefix/visible_emote)) == 1)
			return custom_emote(1, copytext(message,2))

		if(copytext(message,1,2) == ";")
			var/decl/language/language = GET_DECL(/decl/language/binary/drone)
			if(istype(language))
				return language.broadcast(src,trim(copytext(message,2)))

		//Must be conscious to speak
		if (stat)
			return 0

		var/list/listeners = hearers(5,src)
		listeners |= src

		for(var/mob/living/silicon/D in listeners)
			if(D.client && D.local_transmit)
				to_chat(D, "<b>[src]</b> transmits, \"[message]\"")

		for (var/mob/listener in global.player_list)
			if (isnewplayer(listener))
				continue
			if(listener.stat == DEAD && listener.get_preference_value(/datum/client_preference/ghost_ears) == PREF_ALL_SPEECH && listener.client)
				to_chat(listener, "<b>[src]</b> transmits, \"[message]\"")
		return 1
	return ..()
