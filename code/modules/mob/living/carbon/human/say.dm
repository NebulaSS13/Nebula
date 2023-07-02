/mob/living/carbon/human/say(var/message, var/decl/language/speaking, var/verb = "says", var/alt_name = "", whispering)
	if(!whispering)
		var/obj/item/organ/internal/voicebox/voice = locate() in get_internal_organs()
		// Check if the language they're speaking is vocal and not supplied by a machine, and if they are currently suffocating.
		whispering = (whispering || has_chemical_effect(CE_VOICELOSS, 1))
		if((!speaking || !(speaking.flags & (LANG_FLAG_NONVERBAL|LANG_FLAG_SIGNLANG))) && (!voice || !voice.is_usable() || !voice.assists_languages[speaking]) && !isSynthetic() && need_breathe() && failed_last_breath)
			var/obj/item/organ/internal/lungs/L = get_organ(species.breathing_organ, /obj/item/organ/internal/lungs)
			if(!L || L.breath_fail_ratio > 0.9)
				if(L && world.time < L.last_successful_breath + 2 MINUTES) //if we're in grace suffocation period, give it up for last words
					to_chat(src, SPAN_WARNING("You use your remaining air to say something!"))
					L.last_successful_breath = world.time - 2 MINUTES
					whispering = FALSE
				else
					to_chat(src, SPAN_WARNING("You don't have enough air[L ? " in [L]" : ""] to make a sound!"))
					return
			else if(L.breath_fail_ratio > 0.7 || (L.breath_fail_ratio > 0.4 && length(message) > 10) || (L.breath_fail_ratio > 0.2 && length(message) > 30))
				whispering = TRUE
	if(name != GetVoice())
		if(get_id_name("Unknown") == GetVoice())
			SetName(get_id_name("Unknown"))
	. = ..(message, speaking, verb, alt_name, whispering)

/mob/living/carbon/human/proc/forcesay(list/append)
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

/mob/living/carbon/human/say_understands(mob/speaker, decl/language/speaking)
	return (!speaking && (issilicon(speaker) || istype(speaker, /mob/announcer) || isbrain(speaker))) || ..()

/mob/living/carbon/human/GetVoice()

	var/voice_sub
	var/obj/item/rig/rig = get_rig()
	if(rig?.speech?.voice_holder?.active && rig.speech.voice_holder.voice)
		voice_sub = rig.speech.voice_holder.voice

	if(!voice_sub)

		var/list/check_gear = list(get_equipped_item(slot_wear_mask_str), get_equipped_item(slot_head_str))
		if(rig)
			var/datum/extension/armor/rig/armor_datum = get_extension(rig, /datum/extension/armor)
			if(istype(armor_datum) && armor_datum.sealed && rig.helmet == get_equipped_item(slot_head_str))
				check_gear |= rig

		for(var/obj/item/gear in check_gear)
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice)
				voice_sub = changer.voice

	if(voice_sub)
		return voice_sub
	return real_name

/mob/living/carbon/human/say_quote(var/message, var/decl/language/speaking = null)
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

/mob/living/carbon/human/handle_speech_problems(var/list/message_data)
	if(HAS_STATUS(src, STAT_SILENCE) || (sdisabilities & MUTED))
		to_chat(src, SPAN_WARNING("You are unable to speak!"))
		message_data[1] = ""
		return TRUE

	var/obj/item/clothing/mask/M = get_equipped_item(slot_wear_mask_str)
	if(istype(M) && M.voicechange)
		message_data[1] = pick(M.say_messages)
		message_data[2] = pick(M.say_verbs)
		return TRUE

	return ..(message_data)

/mob/living/carbon/human/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(message_mode == MESSAGE_MODE_WHISPER) //It's going to get sanitized again immediately, so decode.
		whisper_say(html_decode(message), speaking, alt_name)
		return TRUE
	return ..()

/mob/living/carbon/human/handle_speech_sound()
	if(species.speech_sounds && prob(species.speech_chance))
		var/list/returns[2]
		var/sound_to_play = species.speech_sounds
		if(islist(species.speech_sounds))
			sound_to_play = species.speech_sounds[gender] || species.speech_sounds
		returns[1] = sound(pick(sound_to_play))
		returns[2] = 50
		return returns
	return ..()

/mob/living/carbon/human/can_speak(decl/language/speaking)
	if(ispath(speaking, /decl/language))
		speaking = GET_DECL(speaking)
	if(species && speaking && (speaking.name in species.assisted_langs))
		for(var/obj/item/organ/internal/voicebox/I in get_internal_organs())
			if(I.is_usable() && I.assists_languages[speaking])
				return TRUE
		return FALSE
	. = ..()

/mob/living/carbon/human/parse_language(var/message)
	var/prefix = copytext(message,1,2)
	if(length(message) >= 1 && prefix == get_prefix_key(/decl/prefix/audible_emote))
		return GET_DECL(/decl/language/noise)

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = lowertext(copytext(message, 2 ,3))
		var/decl/language/L = SSlore.get_language_by_key(language_prefix)
		if (can_speak(L))
			return L

	return null
