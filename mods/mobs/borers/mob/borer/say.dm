/mob/living/simple_animal/borer/say(var/message)

	message = sanitize(message)
	message = capitalize(message)

	if(!message)
		return

	if (stat == DEAD)
		return say_dead(message)

	if (stat)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return

	if(findlasttextEx(message, get_prefix_key(/decl/prefix/custom_emote)) == 1)
		return emote(copytext(message,2))

	if(findlasttextEx(message, get_prefix_key(/decl/prefix/visible_emote)) == 1)
		return custom_emote(1, copytext(message,2))

	var/decl/language/L = parse_language(message)
	if(L && L.flags & LANG_FLAG_HIVEMIND)
		L.broadcast(src,trim(copytext(message,3)),src.truename)
		return

	if(!host)
		//TODO: have this pick a random mob within 3 tiles to speak for the borer.
		to_chat(src, "You have no host to speak to.")
		return //No host, no audible speech.

	to_chat(src, "You drop words into [host]'s mind: \"[message]\"")
	to_chat(host, "Your own thoughts speak: \"[message]\"")

	for (var/mob/M in global.player_list)
		if (isnewplayer(M))
			continue
		else if(M.stat == DEAD && M.get_preference_value(/datum/client_preference/ghost_ears) == PREF_ALL_SPEECH)
			to_chat(M, "[src.truename] whispers to [host], \"[message]\"")
