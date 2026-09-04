/mob/living/human/say(datum/speech/phrases, verb = "says", whispering)
	if(name != GetVoice())
		if(get_id_name("Unknown") == GetVoice())
			SetName(get_id_name("Unknown"))
	. = ..()

/mob/living/human/proc/forcesay(list/append)
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//case sensitive means
				var/main_key = get_common_radio_prefix()
				temp = replacetext(temp, main_key, "")	//general radio

				var/channel_key = get_department_radio_prefix()
				if(findtext(trim_left(temp), channel_key, 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), channel_key, 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)

				var/custom_emote_key = get_prefix_key(/decl/prefix/custom_emote)
				if(findtext(temp, custom_emote_key, 1, 2))	//emotes
					return
				temp = copytext(trim_left(temp), 1, rand(5,8))

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=[null]")

/mob/living/human/say_understands(mob/speaker, decl/language/speaking)
	return (!speaking && (issilicon(speaker) || istype(speaker, /mob/announcer) || isbrain(speaker))) || ..()

/mob/living/human/say_quote(var/message, var/decl/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(src, ending)
	else
		if(ending == "!")
			verb=pick("exclaims","shouts","yells")
		else if(ending == "?")
			verb="asks"

	return verb

/mob/living/human/handle_message_mode(datum/speech/phrases, verb, used_radios)
	if(phrases.message_mode == MESSAGE_MODE_WHISPER) //It's going to get sanitized again immediately, so decode.
		say(phrases, "whisper", whispering = TRUE)
		return TRUE
	return ..()

/mob/living/human/handle_speech_sound()
	if(species.speech_sounds && prob(species.speech_chance))
		var/list/returns[2]
		var/sound_to_play = species.speech_sounds
		if(islist(species.speech_sounds))
			sound_to_play = species.speech_sounds[gender] || species.speech_sounds
		returns[1] = sound(pick(sound_to_play))
		returns[2] = 50
		return returns
	return ..()

/mob/living/human/can_speak(decl/language/speaking)
	if(ispath(speaking, /decl/language))
		speaking = GET_DECL(speaking)
	if(!istype(speaking))
		return ..()
	if(species)
		if(speaking.type in species.assisted_langs)
			for(var/obj/item/organ/internal/voicebox/I in get_internal_organs())
				if(I.is_usable() && I.assists_languages[speaking])
					return TRUE
			return FALSE
		else if(speaking.type in species.unspeakable_langs)
			return FALSE
	. = ..()
