/mob/living/proc/binarycheck()
	for(var/slot in global.ear_slots)
		var/obj/item/radio/headset/dongle = get_equipped_item(slot)
		if(dongle?.can_transmit_binary())
			return TRUE
	return FALSE

/mob/living/get_default_language(use_fallback = TRUE)
	var/decl/language/lang = GET_DECL(default_language)
	if(istype(lang) && can_speak(lang))
		return lang
	return use_fallback ? get_any_good_language(set_default=TRUE) : null

/mob/living/get_any_good_language(set_default=FALSE)
	. = get_default_language(use_fallback = FALSE)
	if(!.)
		for(var/decl/language/language in languages)
			if(can_speak(language))
				. = language
				if(set_default)
					set_default_language(.)
				return

/mob/living/is_silenced()
	. = ..() || HAS_STATUS(src, STAT_SILENCE)

//Takes a list of the form list(message, verb, whispering) and modifies it as needed
//Returns 1 if a speech problem was applied, 0 otherwise
/mob/living/proc/handle_speech_problems(var/list/message_data, var/decl/language/spoken)
	var/say_message = message_data[1]
	var/say_verb = message_data[2]

	. = FALSE
	var/obj/item/clothing/mask/M = get_equipped_item(slot_wear_mask_str)
	if(istype(M) && M.voicechange)
		say_message = pick(M.say_messages)
		say_verb = pick(M.say_verbs)
		. = TRUE
	else if(HAS_STATUS(src, STAT_SILENCE) || has_genetic_condition(GENE_COND_MUTED))
		to_chat(src, SPAN_WARNING("You are unable to speak!"))
		say_message = ""
		. = TRUE
	else if(HAS_STATUS(src, STAT_SLUR))
		say_message = slur(say_message)
		say_verb = pick("slobbers","slurs")
		. = TRUE
	else if(HAS_STATUS(src, STAT_STUTTER))
		say_message = NewStutter(say_message)
		say_verb = pick("stammers","stutters")
		. = TRUE
	else if(has_chemical_effect(CE_SQUEAKY, 1))
		say_message = "<font face = 'Comic Sans MS'>[say_message]</font>"
		say_verb = "squeaks"
		. = TRUE

	message_data[1] = say_message
	message_data[2] = say_verb

// Grabs any radios equipped to the mob, with message_mode used to
// determine relevancy. See handle_message_mode below.
/mob/living/proc/get_radios(var/message_mode)

	var/list/possible_radios
	if(message_mode == MESSAGE_MODE_RIGHT || message_mode == MESSAGE_MODE_LEFT)
		var/use_right = (message_mode == MESSAGE_MODE_RIGHT)
		var/obj/item/thing = get_equipped_item(use_right ? slot_r_ear_str : slot_l_ear_str)
		if(thing)
			LAZYDISTINCTADD(possible_radios, thing)
		else
			thing = get_equipped_item(use_right ? BP_R_HAND : BP_L_HAND)
			if(thing)
				LAZYDISTINCTADD(possible_radios, thing)
	else if(message_mode == MESSAGE_MODE_INTERCOM)
		if(!restrained())
			for(var/obj/item/radio/I in view(1))
				if(I.intercom_handling)
					LAZYDISTINCTADD(possible_radios, I)
	else if(message_mode != MESSAGE_MODE_WHISPER)
		for(var/slot in global.ear_slots)
			var/thing = get_equipped_item(slot)
			if(thing)
				LAZYDISTINCTADD(possible_radios, thing)

	if(LAZYLEN(possible_radios))
		for(var/atom/movable/thing as anything in possible_radios)
			var/obj/item/radio/radio = thing.get_radio(message_mode)
			if(istype(radio))
				LAZYDISTINCTADD(., radio)

// This proc takes in a string (message_mode) which maps to a radio key in global.department_radio_keys
// It then processes the message_mode to implement an additional behavior needed for the message, such
// as retrieving radios or looking for an intercom nearby.
/mob/living/proc/handle_message_mode(datum/speech/phrases, verb, used_radios)
	SHOULD_CALL_PARENT(TRUE)
	if(!phrases.message_mode)
		return
	var/list/assess_items_as_radios = get_radios(phrases.message_mode)
	if(!LAZYLEN(assess_items_as_radios))
		return
	used_radios |= assess_items_as_radios
	for(var/obj/item/radio/radio as anything in used_radios)
		radio.add_fingerprint(src)
		radio.talk_into(src, phrases, verb)

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/handle_mob_specific_speech(datum/speech/phrases, verb = "says")
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

// Parses a message into a list of list(text = spoken language) entries.
/mob/living/proc/parse_message_into_phrases(mob/living/_speaker, message)

	message = trim(message)
	var/full_message = message

	//parse the radio code and consume it
	var/message_mode = parse_message_mode(full_message, standard_mode = MESSAGE_MODE_DEFAULT)
	if(message_mode)
		if(message_mode == MESSAGE_MODE_DEFAULT)
			message = copytext_char(message, 2)
		else
			message = copytext_char(message, 3)

	var/static/regex/split_msg_regex = regex("(.*)(,\\w.*)")
	var/list/phrases = list()
	while(split_msg_regex.Find(message))
		message = split_msg_regex.group[1]
		phrases.Insert(1, split_msg_regex.group[2])
	if(message)
		phrases.Insert(1, message)

	var/use_verb
	var/list/parsed_phrases = list()
	for(var/phrase in phrases)

		var/decl/language/speaking = parse_language(phrase)
		if(speaking)
			if(speaking.type == /decl/language/noise)
				phrase = copytext_char(phrase, 1) // trim the single-char noise prefix
			else
				phrase = copytext_char(phrase, findtext_char(phrase, " ")+1) // trim the entire key
		else
			speaking = get_any_good_language(set_default=TRUE)

		// Format and present nicely.
		phrase = trim(html_encode(phrase))
		phrase = handle_autohiss(phrase, speaking)

		// The LANG_FLAG_NO_STUTTER check means nonvocal or unusually-produced
		// languages (e.g. sign language, noise emotes, computer beeps)
		// will not be affected by stuttering, slurring, silence, etc. effects.
		if(speaking && !(speaking.language_flags & LANG_FLAG_NO_STUTTER))
			var/list/message_data = list(phrase, speaking.speech_verb, 0)
			if(handle_speech_problems(message_data))
				phrase = message_data[1]
				use_verb ||= message_data[2]

		if(speaking)
			var/speech_ability_result = speaking.can_be_spoken_properly_by(src)
			if(speech_ability_result == SPEECH_RESULT_MUDDLED)
				phrase = speaking.muddle(phrase)
			else if(speech_ability_result == SPEECH_RESULT_INCAPABLE)
				// weird phrasing, but needs to cover speaking and signing
				to_chat(src, SPAN_WARNING("You don't have the right equipment to communicate in that way!"))
				return

		parsed_phrases += list(list(phrase, speaking))

	if(length(parsed_phrases))
		return new /datum/speech(_speaker, full_message, message_mode, parsed_phrases, use_verb)

/mob/living/say(datum/speech/phrases, verb = "says", whispering)
	set waitfor = FALSE

	if(client?.prefs.muted & MUTE_IC)
		to_chat(src, SPAN_WARNING("You cannot speak in-character as you are muted."))
		return FALSE

	if(istext(phrases))
		phrases = parse_message_into_phrases(src, phrases)

	if(phrases.incoherent_language_flagging)
		to_chat(src, SPAN_WARNING("You cannot mix non-spoken and spoken language at the same time!"))
		return

	if(!length(phrases?.phrases))
		return // nothing to say for whatever reason

	if(stat)
		if(stat == DEAD)
			return say_dead(phrases.unformatted_message)
		return

	if(findlasttextEx(phrases.raw_message, get_prefix_key(/decl/prefix/custom_emote)) == 1)
		return emote(copytext(phrases.raw_message,2))

	if(findlasttextEx(phrases.raw_message, get_prefix_key(/decl/prefix/visible_emote)) == 1)
		return custom_emote(1, copytext(phrases.raw_message,2))

	if(phrases.force_verb)
		verb = phrases.force_verb

	// Do some organ checking for mobs that have lungs and need air to speak.
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(root_bodytype && !root_bodytype.is_robotic && need_breathe() && failed_last_breath && root_bodytype.breathing_organ)

		// Grab lungs and breath data.
		var/obj/item/organ/internal/lungs/lungs = get_organ(root_bodytype.breathing_organ, /obj/item/organ/internal/lungs)
		var/is_short_of_breath = !lungs || (lungs.breath_fail_ratio > 0.7 || (lungs.breath_fail_ratio > 0.4 && length(phrases.unformatted_message) > 10) || (lungs.breath_fail_ratio > 0.2 && length(phrases.unformatted_message) > 30))
		var/is_suffocating     = !lungs || lungs.breath_fail_ratio > 0.9

		// We're short of breath, force whispering.
		if(is_short_of_breath)
			whispering = TRUE

		// If we don't have any lung issues we don't need to care about the rest of the logic.
		if(is_suffocating)
			// Track if we have some phrase that we can say aloud.
			var/has_speech = FALSE
			// Grab our voicebox (if we have one) in case of mechanically assisted languages.
			var/obj/item/organ/internal/voicebox/voice = locate() in get_internal_organs()
			var/has_voicebox = istype(voice) && voice.is_usable()

			// Check if any of our phrases need air.
			for(var/list/phrase in phrases.phrases)
				var/decl/language/speaking = phrase[2]
				// This is not a vocal language, it doesn't need air.
				if(speaking && (speaking.language_flags & (LANG_FLAG_NONVERBAL|LANG_FLAG_SIGNLANG)))
					has_speech = TRUE
					continue
				// This is a mechanically assisted language, doesn't need air.
				if(has_voicebox && voice.assists_languages[speaking])
					has_speech = TRUE
					continue

				if(lungs && world.time < lungs.last_successful_breath + 2 MINUTES) //if we're in grace suffocation period, give it up for last words
					to_chat(src, SPAN_WARNING("You use your remaining air to say something!"))
					lungs.last_successful_breath = world.time - 2 MINUTES
					whispering = FALSE
					has_speech = TRUE
					break
				phrase[1] = "..." // Can't speak.

			if(!has_speech)
				to_chat(src, SPAN_WARNING("You don't have enough air[lungs ? " in [lungs]" : ""] to make a sound!"))
				return

		else
			whispering ||= has_chemical_effect(CE_VOICELOSS, 1)
	else
		whispering ||= has_chemical_effect(CE_VOICELOSS, 1)


	// Check if we're muzzled.
	for(var/list/phrase in phrases.phrases)
		var/decl/language/speaking = phrase[2]
		if(speaking && (speaking.language_flags & (LANG_FLAG_NONVERBAL|LANG_FLAG_SIGNLANG|LANG_FLAG_HIVEMIND)))
			continue
		var/obj/item/muzzle = get_item_blocking_speech()
		if(muzzle)
			to_chat(src, SPAN_WARNING("You can't speak, \the [muzzle] is in the way!"))
			return

	if(!phrases.language)
		to_chat(src, SPAN_WARNING("You don't know a language and cannot speak."))
		custom_emote(AUDIBLE_MESSAGE, "[pick("grunts", "babbles", "gibbers", "jabbers", "burbles")] aimlessly.")
		return

	if(handle_mob_specific_speech(phrases, verb))
		return

	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(phrases.language && (phrases.language.language_flags & LANG_FLAG_HIVEMIND))
		phrases.language.broadcast(src, phrases)
		return 1

	if(phrases.language)
		if(whispering)
			verb = phrases.language.whisper_verb ? phrases.language.whisper_verb : phrases.language.speech_verb
		else
			verb = say_quote(phrases.unformatted_message, phrases.language)

	var/list/obj/item/used_radios = list()
	if(handle_message_mode(phrases, verb, used_radios))
		return TRUE

	var/list/handle_v = (istype(phrases.language) && phrases.language.get_spoken_sound()) || handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2]

	var/italics = 0
	var/message_range = world.view

	if(whispering)
		italics = 1
		message_range = 1

	//speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1
		if(phrases.language)
			message_range = phrases.language.get_talkinto_msg_range(phrases.unformatted_message)
		var/msg
		if(!phrases.language || !(phrases.language.language_flags & LANG_FLAG_NO_TALK_MSG))
			msg = "<span class='notice'>\The [src] talks into \the [used_radios[1]].</span>"
		for(var/mob/living/M in hearers(5, src))
			if((M != src) && msg)
				M.show_message(msg)
			if (speech_sound)
				sound_vol *= 0.5

	//handle nonverbal and sign languages here
	var/is_nonverbal = FALSE
	var/showed_signlang = FALSE
	for(var/list/phrase in phrases.phrases)
		var/decl/language/speaking = phrase[2]
		if(!speaking)
			continue

		// Signlang is problematic for mixed-language speech...
		// Not being able to mix multiple sign languages is an issue, but we only have one currently.
		// TODO: revisit how sign language is handled.
		if((speaking.language_flags & LANG_FLAG_SIGNLANG))
			log_say("[name]/[key] : SIGN: [phrase[1]]")
			say_signlang(phrase[1], pick(speaking.signlang_verb), speaking)
			showed_signlang = TRUE
			continue

		if(!is_nonverbal && (speaking.language_flags & LANG_FLAG_NONVERBAL) && prob(30))
			is_nonverbal = pick(speaking.signlang_verb)

	if(showed_signlang)
		return

	if(is_nonverbal)
		custom_emote(1, "[is_nonverbal].")

	var/list/listening = list()
	var/list/listening_obj = list()
	var/turf/speaker_turf = get_turf(src)
	if(speaker_turf)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = speaker_turf.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		get_listeners_in_range(speaker_turf, message_range, listening, listening_obj, /datum/client_preference/ghost_ears)

	var/speech_bubble_state = check_speech_punctuation_state(phrases.unformatted_message)
	var/speech_state_modifier = get_speech_bubble_state_modifier()
	if(speech_bubble_state && speech_state_modifier)
		speech_bubble_state = "[speech_state_modifier]_[speech_bubble_state]"

	var/image/speech_bubble
	if(speech_bubble_state)
		speech_bubble = image('icons/mob/talk.dmi', src, speech_bubble_state)
		speech_bubble.layer = layer
		speech_bubble.plane = plane

	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M)
			M.hear_say(phrases, verb, italics, src, speech_sound, sound_vol)
			if(M.client)
				speech_bubble_recipients += M.client

	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, phrases, verb)

	var/list/eavesdroppers = list()
	if(whispering)
		var/eavesdroping_range = 5
		var/list/eavesdroping = list()
		var/list/eavesdroping_obj = list()
		get_listeners_in_range(speaker_turf, eavesdroping_range, eavesdroping, eavesdroping_obj)
		eavesdroping -= listening
		eavesdroping_obj -= listening_obj
		for(var/mob/M in eavesdroping)
			if(M)
				M.hear_say(phrases, verb, italics, src, speech_sound, sound_vol, stars = TRUE)
				if(M.client)
					eavesdroppers |= M.client

		for(var/obj/O in eavesdroping)
			spawn(0)
				if(O) //It's possible that it could be deleted in the meantime.
					O.hear_talk(src, phrases, verb, stars = TRUE)

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(animate_speech_bubble), speech_bubble, speech_bubble_recipients | eavesdroppers, 30)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, animate_chat), phrases, italics, speech_bubble_recipients)
	if(length(eavesdroppers))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, animate_chat), phrases, italics, eavesdroppers, TRUE)

	if(whispering)
		log_whisper("[name]/[key] : [phrases.unformatted_message]")
	else
		log_say("[name]/[key] : [phrases.unformatted_message]")
	return 1

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/decl/language/language)
	var/list/viewing_mobs = list()
	var/list/viewing_objs = list()
	get_listeners_in_range(get_turf(src), 7, viewing_mobs, viewing_objs, check_ghosts = /datum/client_preference/ghost_sight)
	for (var/atom/viewer in (viewing_mobs | viewing_objs))
		viewer.see_signlang(message, verb, language, src)
	return TRUE

/mob/proc/GetVoice()
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

	return real_name || name
