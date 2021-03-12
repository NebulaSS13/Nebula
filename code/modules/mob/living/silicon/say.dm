/mob/living/silicon/say(var/message, var/sanitize = 1)
	return ..(sanitize ? sanitize(message) : message)

/mob/living/silicon/handle_message_mode(mob/speaker, list/phrases, channel, verb = "says", used_radios, alt_name)
	for(var/list/phrase in phrases)
		log_say("[key_name(src)] : [phrase[2]]")

/mob/living/silicon/robot/handle_message_mode(mob/speaker, list/phrases, channel, verb = "says", used_radios, alt_name)
	if(channel)
		if(!is_component_functioning("radio"))
			to_chat(src, SPAN_WARNING("Your radio isn't functional at this time."))
		else
			used_radios += silicon_radio
		. = TRUE
	return ..()

/mob/living/silicon/ai/handle_message_mode(mob/speaker, list/phrases, channel, verb = "says", used_radios, alt_name)
	if(message_mode)
		if(message_mode == MESSAGE_MODE_DEPARTMENT)
			holopad_talk(message, verb, speaking)
		else if (ai_radio.disabledAi || !has_power() || stat)
			to_chat(src, SPAN_DANGER("System Error - Transceiver Disabled."))
		else
			used_radios += ai_radio
		. = TRUE
	..()

/mob/living/silicon/pai/handle_message_mode(mob/speaker, list/phrases, channel, verb = "says", used_radios, alt_name)
	if(message_mode)
		used_radios += silicon_radio
		. = TRUE
	..()

/mob/living/silicon/say_quote(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return speak_query
	else if (ending == "!")
		return speak_exclamation
	return speak_statement

#define IS_AI 1
#define IS_ROBOT 2
#define IS_PAI 3

/mob/living/silicon/say_understands(mob/speaker, decl/language/speaking)
	return (!speaking && (iscarbon(speaker) || issilicon(speaker) || isbrain(speaker))) || ..()

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(var/list/phrases, verb)

	if(!islist(phrases) || !length(phrases))
		return

	var/obj/machinery/hologram/holopad/H = src.holo
	if(H && H.masters[src])//If there is a hologram and its master is the user.

		// AI can hear their own message, this formats it for them.
		var/message = compile_mixed_language_text_for(src, src, phrases)
		to_chat(src, "<i><span class='game say'>Holopad transmitted, <span class='name'>[real_name]</span> [verb], <span class='message'><span class='body'>\"[message]\"</span></span></span></i>")
		log_say("[key_name(src)] : [message]")

		//This is so pAI's and people inside lockers/boxes,etc can hear the AI Holopad, the alternative being recursion through contents.
		//This is much faster.
		var/list/listening = list()
		var/list/listening_obj = list()
		var/turf/T = get_turf(H)

		if(T)
			var/list/hear = hear(7, T)
			var/list/hearturfs = list()

			for(var/I in hear)
				if(istype(I, /mob/))
					var/mob/M = I
					listening += M
					hearturfs += M.locs[1]
					for(var/obj/O in M.contents)
						listening_obj |= O
				else if(istype(I, /obj/))
					var/obj/O = I
					hearturfs += O.locs[1]
					listening_obj |= O

			for(var/mob/M in global.player_list)
				if(M.stat == DEAD && M.get_preference_value(/datum/client_preference/ghost_ears) == PREF_ALL_SPEECH)
					M.hear_say(phrases, verb, speaker = src)
					continue
				if(M.loc && (M.locs[1] in hearturfs))
					M.hear_say(phrases, verb, speaker = src)


	else
		to_chat(src, "No holopad connected.")
		return 0
	return 1

/mob/living/silicon/ai/proc/holopad_emote(var/message) //This is called when the AI uses the 'me' verb while using a holopad.

	log_emote("[key_name(src)] : [message]")

	message = trim(message)

	if (!message)
		return

	var/obj/machinery/hologram/holopad/T = src.holo
	if(T && T.masters[src])
		var/turf/our_turf = get_turf(T)
		var/rendered = "<span class='game say'><span class='name'>[name]</span> <span class='message'>[message]</span></span>"
		to_chat(src, "<i><span class='game say'>Holopad action relayed, <span class='name'>[real_name]</span> <span class='message'>[message]</span></span></i>")
		our_turf.audible_message(rendered)
	else //This shouldn't occur, but better safe then sorry.
		to_chat(src, "No holopad connected.")
		return 0
	return 1

#undef IS_AI
#undef IS_ROBOT
#undef IS_PAI

/mob/living/silicon/binarycheck()
	. = TRUE
