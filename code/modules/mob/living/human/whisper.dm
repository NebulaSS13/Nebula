//Lallander was here
/mob/living/human/whisper(message as text)

	if(filter_block_message(src, message))
		return

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot whisper (muted).</span>")
			return

	message = sanitize(message, encode = 0)

	if (src.stat == DEAD)
		return src.say_dead(message)

	if (src.stat)
		return

	if(get_id_name("Unknown") == GetVoice())
		SetName(get_id_name("Unknown"))

	say(list(message, get_default_language()), whispering = TRUE)
