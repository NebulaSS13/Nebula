/mob/living/proc/binarycheck()
	for(var/slot in global.ear_slots)
		var/obj/item/radio/headset/dongle = get_equipped_item(slot)
		if(dongle?.can_transmit_binary())
			return TRUE
	return FALSE

/mob/living/proc/get_default_language()
	var/lang = ispath(default_language, /decl/language) && GET_DECL(default_language)
	if(can_speak(lang))
		return lang

/mob/living/proc/get_any_good_language(set_default=FALSE)
	. = get_default_language()
	if(!.)
		for(var/decl/language/L in languages)
			if(can_speak(L))
				. = L
				if(set_default)
					set_default_language(.)
				return


/mob/living/is_silenced()
	. = ..() || HAS_STATUS(src, STAT_SILENCE)

//Takes a list of the form list(message, verb, whispering) and modifies it as needed
//Returns 1 if a speech problem was applied, 0 otherwise
/mob/living/proc/handle_speech_problems(var/list/message_data)
	var/message = message_data[1]
	var/verb = message_data[2]

	. = 0

	if(HAS_STATUS(src, STAT_SLUR))
		message = slur(message)
		verb = pick("slobbers","slurs")
		. = 1
	else if(HAS_STATUS(src, STAT_STUTTER))
		message = NewStutter(message)
		verb = pick("stammers","stutters")
		. = 1
	else if(has_chemical_effect(CE_SQUEAKY, 1))
		message = "<font face = 'Comic Sans MS'>[message]</font>"
		verb = "squeaks"
		. = 1

	message_data[1] = message
	message_data[2] = verb

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
/mob/living/proc/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(!message_mode)
		return
	var/list/assess_items_as_radios = get_radios(message_mode)
	if(!LAZYLEN(assess_items_as_radios))
		return
	used_radios |= assess_items_as_radios
	for(var/obj/item/radio/radio as anything in used_radios)
		radio.add_fingerprint(src)
		radio.talk_into(src, message, message_mode, verb, speaking)

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending=="!")
		return pick("exclaims","shouts","yells")
	if(ending=="?")
		return "asks"
	return verb

/mob/living/proc/format_say_message(var/message = null)
	if(!message)
		return

	message = html_decode(message)

	var/end_char = copytext_char(message, -1)
	if(!(end_char in list(".", "?", "!", "-", "~")))
		message += "."

	return html_encode(message)

/mob/living/say(var/message, var/decl/language/speaking, var/verb = "says", var/alt_name = "", whispering)
	set waitfor = FALSE
	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (Muted).</span>")
			return

	if(stat)
		if(stat == 2)
			return say_dead(message)
		return

	if(findlasttextEx(message, get_prefix_key(/decl/prefix/custom_emote)) == 1)
		return emote(copytext(message,2))

	if(findlasttextEx(message, get_prefix_key(/decl/prefix/visible_emote)) == 1)
		return custom_emote(1, copytext(message,2))

	//parse the radio code and consume it
	var/message_mode = parse_message_mode(message, standard_mode = MESSAGE_MODE_DEFAULT)
	if(message_mode)
		if(message_mode == MESSAGE_MODE_DEFAULT)
			message = copytext_char(message, 2)
		else
			message = copytext_char(message, 3)

	message = trim_left(message)

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
		if(speaking)
			message = copytext_char(message,2+length_char(speaking.key))
		else
			speaking = get_any_good_language(set_default=TRUE)
			if (!speaking)
				to_chat(src, SPAN_WARNING("You don't know a language and cannot speak."))
				emote("custom", AUDIBLE_MESSAGE, "[pick("grunts", "babbles", "gibbers", "jabbers", "burbles")] aimlessly.")
				return

	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(speaking && (speaking.flags & LANG_FLAG_HIVEMIND))
		speaking.broadcast(src,trim(message))
		return 1

	if((is_muzzled()) && !(speaking && (speaking.flags & LANG_FLAG_SIGNLANG)))
		to_chat(src, "<span class='danger'>You're muzzled and cannot speak!</span>")
		return

	if (speaking)
		if(whispering)
			verb = speaking.whisper_verb ? speaking.whisper_verb : speaking.speech_verb
		else
			verb = say_quote(message, speaking)

	message = trim_left(message)
	message = handle_autohiss(message, speaking)
	message = format_say_message(message)
	message = filter_modify_message(message)

	if(speaking && !speaking.can_be_spoken_properly_by(src))
		message = speaking.muddle(message)

	if(!(speaking && (speaking.flags & LANG_FLAG_NO_STUTTER)))
		var/list/message_data = list(message, verb, 0)
		if(handle_speech_problems(message_data))
			message = message_data[1]
			verb = message_data[2]

	if(!message || message == "")
		return 0

	var/list/obj/item/used_radios = list()
	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name))
		return 1

	var/list/handle_v = (istype(speaking) && speaking.get_spoken_sound()) || handle_speech_sound()
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
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		var/msg
		if(!speaking || !(speaking.flags & LANG_FLAG_NO_TALK_MSG))
			msg = "<span class='notice'>\The [src] talks into \the [used_radios[1]].</span>"
		for(var/mob/living/M in hearers(5, src))
			if((M != src) && msg)
				M.show_message(msg)
			if (speech_sound)
				sound_vol *= 0.5

	var/list/listening = list()
	var/list/listening_obj = list()
	var/turf/T = get_turf(src)

	//handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & LANG_FLAG_NONVERBAL)
			if (prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & LANG_FLAG_SIGNLANG)
			log_say("[name]/[key] : SIGN: [message]")
			return say_signlang(message, pick(speaking.signlang_verb), speaking)

	if(T)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		get_mobs_and_objs_in_view_fast(T, message_range, listening, listening_obj, /datum/client_preference/ghost_ears)

	var/speech_bubble_state = check_speech_punctuation_state(message)
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
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
			if(M.client)
				speech_bubble_recipients += M.client

	for(var/obj/O in listening_obj)
		spawn(0)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking)

	var/list/eavesdroppers = list()
	if(whispering)
		var/eavesdroping_range = 5
		var/list/eavesdroping = list()
		var/list/eavesdroping_obj = list()
		get_mobs_and_objs_in_view_fast(T, eavesdroping_range, eavesdroping, eavesdroping_obj)
		eavesdroping -= listening
		eavesdroping_obj -= listening_obj
		for(var/mob/M in eavesdroping)
			if(M)
				M.hear_say(stars(message), verb, speaking, alt_name, italics, src, speech_sound, sound_vol)
				if(M.client)
					eavesdroppers |= M.client

		for(var/obj/O in eavesdroping)
			spawn(0)
				if(O) //It's possible that it could be deleted in the meantime.
					O.hear_talk(src, stars(message), verb, speaking)

	INVOKE_ASYNC(GLOBAL_PROC, .proc/animate_speech_bubble, speech_bubble, speech_bubble_recipients | eavesdroppers, 30)
	INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, speaking, italics, speech_bubble_recipients)
	if(length(eavesdroppers))
		INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, stars(message), speaking, italics, eavesdroppers)

	if(whispering)
		log_whisper("[name]/[key] : [message]")
	else
		log_say("[name]/[key] : [message]")
	return 1

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/decl/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)
	return 1

/mob/proc/GetVoice()
	return name
