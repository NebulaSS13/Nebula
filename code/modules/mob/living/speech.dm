// Structure used for passing around spoken text.
/datum/speech
	var/weakref/speaker_ref
	var/raw_message
	var/message_mode
	var/list/phrases
	var/force_verb
	var/formatted_message
	var/unformatted_message
	var/decl/language/language
	var/incoherent_language_flagging = FALSE

/datum/speech/New(mob/living/_speaker, _msg, _mode, _phrases, _verb)
	speaker_ref  = weakref(_speaker)
	raw_message  = _msg
	message_mode = _mode
	force_verb   = _verb
	phrases      = _phrases

	var/saw_signlang  = null
	var/saw_broadcast = null
	var/saw_nonvocal  = null

	var/list/all_phrases = list()
	var/first_string = TRUE
	for(var/list/phrase in phrases)

		var/decl/language/speaking = phrase[2]

		if(speaking)

			// Keep track of our first vocal language.
			language ||= speaking

			// Check if our combined language flagging is incoherent.
			// Can't mix sign lang, vocal lang and broadcast in the same message.
			if(!incoherent_language_flagging)

				if(speaking.language_flags & LANG_FLAG_NONVERBAL)
					if(isnull(saw_nonvocal))
						saw_nonvocal = TRUE
					else if(!saw_nonvocal)
						incoherent_language_flagging = TRUE
				else
					if(isnull(saw_nonvocal))
						saw_broadcast = FALSE
					else if(saw_nonvocal)
						incoherent_language_flagging = TRUE

				if(speaking.language_flags & LANG_FLAG_SIGNLANG)
					if(isnull(saw_signlang))
						saw_signlang = TRUE
					else if(!saw_signlang)
						incoherent_language_flagging = TRUE
				else
					if(isnull(saw_signlang))
						saw_broadcast = FALSE
					else if(saw_signlang)
						incoherent_language_flagging = TRUE

				if(speaking.language_flags & LANG_FLAG_HIVEMIND)
					if(isnull(saw_broadcast))
						saw_broadcast = TRUE
					else if(!saw_broadcast)
						incoherent_language_flagging = TRUE
				else
					if(isnull(saw_broadcast))
						saw_broadcast = FALSE
					else if(saw_broadcast)
						incoherent_language_flagging = TRUE

		phrase[1] = trim(phrase[1])
		if(first_string)
			phrase[1] = capitalize(phrase[1])
			first_string = FALSE
		// Pre-generate scrambled versions for people who don't understand the language.
		phrase += speaking ? speaking.scramble(_speaker, phrase[1], _speaker.languages) : phrase[1]
		// Pre-generate obfuscated starred version for people who are hard of hearing, eavesdropping, etc.
		phrase += stars(phrase[1])
		all_phrases += phrase[1]
	// Store fully translated, stripped versions for stuff like broadcasts/ghosts/logs.
	unformatted_message = jointext(all_phrases, " ")
	formatted_message = language?.format_message_no_verb(unformatted_message) || unformatted_message

// Returns a list of formatted and unformatted message strings for display to a target listener.
// Future TODO: cache as much of this as possible.
/datum/speech/proc/compile_for_listener(atom/listener, skip_verbal = FALSE, skip_non_verbal = FALSE, scramble = FALSE, stars = FALSE, hard_to_hear = FALSE, machine_listener = FALSE)

	var/mob/speaker            = speaker_ref.resolve()
	var/mob/listener_mob       = ismob(listener) ? listener : null
	var/list/final_strings     = list()
	var/list/formatted_strings = list()

	for(var/list/phrase in phrases)
		var/decl/language/speaking = phrase[2]

		if(speaking)
			if(skip_verbal && !(speaking.language_flags & (LANG_FLAG_NONVERBAL|LANG_FLAG_SIGNLANG|LANG_FLAG_HIVEMIND)))
				continue
			if(skip_non_verbal && (speaking.language_flags & (LANG_FLAG_NONVERBAL|LANG_FLAG_SIGNLANG|LANG_FLAG_HIVEMIND)))
				continue

		var/message = phrase[1]
		if(scramble || (machine_listener && !speaking?.machine_understands))
			var/decl/language/machine/noise_lang = GET_DECL(/decl/language/machine)
			message = noise_lang.scramble(null, message, null)
		//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
		else if(stars || ((speaking?.language_flags & LANG_FLAG_NONVERBAL) && (!speaker || listener_mob?.is_blind() || !(speaker in view(listener)))))
			message = phrase[4]

		// skip understanding checks for LANG_FLAG_INNATE languages
		if(!(speaking?.language_flags & LANG_FLAG_INNATE))
			if(!listener_mob?.say_understands(speaker, speaking))
				if(isanimal(speaker))
					if(LAZYLEN(speaker.ai?.emote_speech))
						message = pick(speaker.ai.emote_speech)
				else
					if(speaking)
						message = phrase[3]
					else
						message = phrase[4]

			if(hard_to_hear)
				if(hard_to_hear <= 5)
					message = phrase[4]
				else // Used for compression
					message = RadioChat(null, message, 80, 1+(hard_to_hear/10))

		message = trim(message)
		final_strings     += message
		formatted_strings += speaking ? speaking.format_message_no_verb(message) : message

	return list(
		handle_autopunctuation(filter_modify_message(jointext(final_strings, " "))),
		handle_autopunctuation(filter_modify_message(jointext(formatted_strings, " ")))
	)
