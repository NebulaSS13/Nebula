/mob/living/carbon/human/say(var/message, var/decl/language/speaking = null, whispering)
	set waitfor = FALSE
	var/prefix = copytext(message,1,2)
	if(prefix == get_prefix_key(/decl/prefix/custom_emote) || prefix == get_prefix_key(/decl/prefix/visible_emote) || prefix == get_prefix_key(/decl/prefix/audible_emote))
		return ..(message, null, null)
	if(name != GetVoice())
		if(get_id_name("Unknown") == GetVoice())
			SetName(get_id_name("Unknown"))

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
		if (speaking)
			message = copytext(message,2+length(speaking.key))
		else
			speaking = get_any_good_language(set_default=TRUE)
			if (!speaking)
				to_chat(src, SPAN_WARNING("You don't know a language and cannot speak."))
				emote("custom", AUDIBLE_MESSAGE, "[pick("grunts", "babbles", "gibbers", "jabbers", "burbles")] aimlessly.")
				return

	if(has_chemical_effect(CE_VOICELOSS, 1))
		whispering = TRUE

	message = sanitize(message)
	var/obj/item/organ/internal/voicebox/voice = locate() in internal_organs
	var/snowflake_speak = (speaking && (speaking.flags & (NONVERBAL|SIGNLANG))) || (voice && voice.is_usable() && voice.assists_languages[speaking])
	if(!isSynthetic() && need_breathe() && failed_last_breath && !snowflake_speak)
		var/obj/item/organ/internal/lungs/L = get_internal_organ(species.breathing_organ)
		if(!L || L.breath_fail_ratio > 0.9)
			if(L && world.time < L.last_successful_breath + 2 MINUTES) //if we're in grace suffocation period, give it up for last words
				to_chat(src, "<span class='warning'>You use your remaining air to say something!</span>")
				L.last_successful_breath = world.time - 2 MINUTES
				return ..(message, speaking = speaking)

			to_chat(src, "<span class='warning'>You don't have enough air[L ? " in [L]" : ""] to make a sound!</span>")
			return
		else if(L.breath_fail_ratio > 0.7)
			whisper_say(length(message) > 5 ? stars(message) : message, speaking)
		else if(L.breath_fail_ratio > 0.4 && length(message) > 10)
			whisper_say(message, speaking)
		else if(L.breath_fail_ratio > 0.2 && length(message) > 30)
			whisper_say(message, speaking)
		else
			return ..(message, speaking = speaking, whispering = whispering)
	else
		return ..(message, speaking = speaking, whispering = whispering)


/mob/living/carbon/human/proc/forcesay(list/append)
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//case sensitive means
				var/main_key = get_prefix_key(/decl/prefix/radio_main_channel)
				temp = replacetext(temp, main_key, "")	//general radio

				var/channel_key = get_prefix_key(/decl/prefix/radio_channel_selection)
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

/mob/living/carbon/human/say_understands(var/mob/other,var/decl/language/speaking = null)

	if(species.can_understand(other))
		return 1

	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (istype(other, /mob/living/silicon))
			return 1
		if (istype(other, /mob/living/carbon/brain))
			return 1

	//This is already covered by mob/say_understands()
	//if (istype(other, /mob/living/simple_animal))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()

/mob/living/carbon/human/GetVoice()

	var/voice_sub
	if(istype(back,/obj/item/rig))
		var/obj/item/rig/rig = back
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice)
			voice_sub = rig.speech.voice_holder.voice

	if(!voice_sub)

		var/list/check_gear = list(wear_mask, head)
		if(wearing_rig)
			var/datum/extension/armor/rig/armor_datum = get_extension(wearing_rig, /datum/extension/armor)
			if(istype(armor_datum) && armor_datum.sealed && wearing_rig.helmet == head)
				check_gear |= wearing_rig

		for(var/obj/item/gear in check_gear)
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice)
				voice_sub = changer.voice

	if(voice_sub)
		return voice_sub
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	return real_name

/mob/living/carbon/human/say_quote(var/message, var/decl/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(ending)
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
		. = 1

	else if(istype(wear_mask, /obj/item/clothing/mask))
		var/obj/item/clothing/mask/M = wear_mask
		if(M.voicechange)
			message_data[1] = pick(M.say_messages)
			message_data[2] = pick(M.say_verbs)
			. = 1

	else
		. = ..(message_data)

/mob/living/carbon/human/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	switch(message_mode)
		if("intercom")
			if(!src.restrained())
				for(var/obj/item/radio/intercom/I in view(1))
					I.talk_into(src, message, null, verb, speaking)
					I.add_fingerprint(src)
					used_radios += I
		if("headset")
			if(l_ear && istype(l_ear,/obj/item/radio))
				var/obj/item/radio/R = l_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += l_ear
			else if(r_ear && istype(r_ear,/obj/item/radio))
				var/obj/item/radio/R = r_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += r_ear
		if("right ear")
			var/obj/item/radio/R
			var/has_radio = 0
			if(r_ear && istype(r_ear,/obj/item/radio))
				R = r_ear
				has_radio = 1
			var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, BP_R_HAND)
			if(istype(inv_slot?.holding, /obj/item/radio))
				R = inv_slot.holding
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R
		if("left ear")
			var/obj/item/radio/R
			var/has_radio = 0
			if(l_ear && istype(l_ear,/obj/item/radio))
				R = l_ear
				has_radio = 1
			var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, BP_L_HAND)
			if(istype(inv_slot?.holding, /obj/item/radio))
				R = inv_slot.holding
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R
		if("whisper") //It's going to get sanitized again immediately, so decode.
			whisper_say(html_decode(message), speaking, alt_name)
			return 1
		else
			if(message_mode)
				if(l_ear && istype(l_ear,/obj/item/radio))
					l_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += l_ear
				else if(r_ear && istype(r_ear,/obj/item/radio))
					r_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += r_ear

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
		for(var/obj/item/organ/internal/voicebox/I in src.internal_organs)
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
