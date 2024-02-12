/mob/living/silicon/robot/drone/say(var/message)
	if(local_transmit)
		if (src.client)
			if(client.prefs.muted & MUTE_IC)
				to_chat(src, "You cannot send IC messages (muted).")
				return 0

		message = sanitize(message)

		if (stat == DEAD)
			return say_dead(message)

		if(findlasttextEx(message, get_prefix_key(/decl/prefix/custom_emote)) == 1)
			return emote(copytext(message,2))

		if(findlasttextEx(message, get_prefix_key(/decl/prefix/visible_emote)) == 1)
			return custom_emote(1, copytext(message,2))

		if(copytext(message,1,2) == ";")
			var/decl/language/L = GET_DECL(/decl/language/binary/drone)
			if(istype(L))
				return L.broadcast(src,trim(copytext(message,2)))

		//Must be concious to speak
		if (stat)
			return 0

		var/list/listeners = hearers(5,src)
		listeners |= src

		for(var/mob/living/silicon/D in listeners)
			if(D.client && D.local_transmit)
				to_chat(D, "<b>[src]</b> transmits, \"[message]\"")

		for (var/mob/M in global.player_list)
			if (isnewplayer(M))
				continue
			else if(M.stat == DEAD && M.get_preference_value(/datum/client_preference/ghost_ears) == PREF_ALL_SPEECH)
				if(M.client) to_chat(M, "<b>[src]</b> transmits, \"[message]\"")
		return 1
	return ..(message, 0)
