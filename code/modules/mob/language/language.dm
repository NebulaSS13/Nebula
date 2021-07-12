#define SCRAMBLE_CACHE_LEN 20

/*
	Datum based languages. Easily editable and modular.
*/

/decl/language
	var/name                          // Fluff name of language if any.
	var/desc = "You should not have this language." // Short description for 'Check Languages'.
	var/speech_verb = "says"          // 'says', 'hisses', 'farts'.
	var/ask_verb = "asks"             // Used when sentence ends in a ?
	var/exclaim_verb = "exclaims"     // Used when sentence ends in a !
	var/whisper_verb                  // Optional. When not specified speech_verb + quietly/softly is used instead.
	var/signlang_verb = list("signs", "gestures") // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/colour = "body"               // CSS style to use for strings in this language.
	var/key = ""                      // Character used to speak in language
	var/flags = 0                     // Various language flags.
	var/native                        // If set, non-native speakers will have trouble speaking.
	var/list/syllables                // Used when scrambling text for a non-speaker.
	var/list/space_chance = 55        // Likelihood of getting a space in the random scramble string
	var/machine_understands = 1       // Whether machines can parse and understand this language
	var/shorthand = "???"			  // Shorthand that shows up in chat for this language.
	var/list/partial_understanding				  // List of languages that can /somehwat/ understand it, format is: name = chance of understanding a word
	var/warning = ""
	var/hidden_from_codex			  // If it should not show up in Codex
	var/category = /decl/language    // Used to point at root language types that shouldn't be visible
	var/list/scramble_cache = list()
	var/list/speech_sounds
	var/allow_repeated_syllables = TRUE

/decl/language/proc/get_spoken_sound()
	if(speech_sounds)
		var/list/result[2]
		result[1] = pick(speech_sounds)
		result[2] = 40
		return result

/decl/language/proc/can_be_spoken_properly_by(var/mob/speaker)
	return TRUE

/decl/language/proc/muddle(var/message)
	return message

/decl/language/proc/get_random_name(var/gender, name_count=2, syllable_count=4, syllable_divisor=2)
	if(!length(syllables))
		if(gender==FEMALE)
			return capitalize(pick(global.first_names_female)) + " " + capitalize(pick(global.last_names))
		else
			return capitalize(pick(global.first_names_male)) + " " + capitalize(pick(global.last_names))

	var/possible_syllables = allow_repeated_syllables ? syllables : syllables.Copy()
	for(var/i = 0;i<name_count;i++)
		var/new_name = ""
		for(var/x = rand(Floor(syllable_count/syllable_divisor),syllable_count);x>0;x--)
			if(!length(possible_syllables))
				break
			new_name += allow_repeated_syllables ? pick(possible_syllables) : pick_n_take(possible_syllables)
		LAZYADD(., capitalize(lowertext(new_name)))
	. = "[trim(jointext(., " "))]"

/decl/language/proc/scramble(var/input, var/list/known_languages)

	var/understand_chance = 0
	for(var/decl/language/L in known_languages)
		if(LAZYACCESS(partial_understanding, L.name))
			understand_chance += partial_understanding[L.name]

	var/list/words = splittext(input, " ")
	var/list/scrambled_text = list()
	var/new_sentence = 0
	for(var/w in words)
		var/nword = "[w] "
		var/input_ending = copytext(w, length(w))
		var/ends_sentence = findtext(".?!",input_ending)
		if(!prob(understand_chance))
			nword = scramble_word(w)
			if(new_sentence)
				nword = capitalize(nword)
				new_sentence = FALSE
			if(ends_sentence)
				nword = trim(nword)
				nword = "[nword][input_ending] "

		if(ends_sentence)
			new_sentence = TRUE

		scrambled_text += nword

	. = jointext(scrambled_text, null)
	. = capitalize(.)
	. = trim(.)

/decl/language/proc/scramble_word(var/input)
	if(!syllables || !syllables.len)
		return stars(input)

	// If the input is cached already, move it to the end of the cache and return it
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n

	var/input_size = length(input)
	var/scrambled_text = ""
	var/capitalize = 0

	while(length(scrambled_text) < input_size)
		var/next = pick(syllables)
		if(capitalize)
			next = capitalize(next)
			capitalize = 0
		scrambled_text += next
		var/chance = rand(100)
		if(chance <= 5)
			scrambled_text += ". "
			capitalize = 1
		else if(chance > 5 && chance <= space_chance)
			scrambled_text += " "

	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-SCRAMBLE_CACHE_LEN-1)
	
	return scrambled_text

/decl/language/proc/format_message(message, verb)
	return "[verb], <span class='message'><span class='[colour]'>\"[capitalize(message)]\"</span></span>"

/decl/language/proc/format_message_plain(message, verb)
	return "[verb], \"[capitalize(message)]\""

/decl/language/proc/format_message_radio(message, verb)
	return "[verb], <span class='[colour]'>\"[capitalize(message)]\"</span>"

/decl/language/proc/get_talkinto_msg_range(message)
	// if you yell, you'll be heard from two tiles over instead of one
	return (copytext(message, length(message)) == "!") ? 2 : 1

/decl/language/proc/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]")

	if(!speaker_mask) speaker_mask = speaker.name
	message = format_message(message, get_spoken_verb(message))
	for(var/mob/player in global.player_list)
		player.hear_broadcast(src, speaker, speaker_mask, message)

/mob/proc/hear_broadcast(var/decl/language/language, var/mob/speaker, var/speaker_name, var/message)
	if((language in languages) && language.check_special_condition(src))
		var/msg = "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>"
		to_chat(src, msg)

/mob/new_player/hear_broadcast(var/decl/language/language, var/mob/speaker, var/speaker_name, var/message)
	return

/mob/observer/ghost/hear_broadcast(var/decl/language/language, var/mob/speaker, var/speaker_name, var/message)
	if(speaker.name == speaker_name || antagHUD)
		to_chat(src, "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> ([ghost_follow_link(speaker, src)]) [message]</span></i>")
	else
		to_chat(src, "<i><span class='game say'>[language.name], <span class='name'>[speaker_name]</span> [message]</span></i>")

/decl/language/proc/check_special_condition(var/mob/other)
	return 1

/decl/language/proc/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return exclaim_verb
		if("?")
			return ask_verb
	return speech_verb

/decl/language/proc/can_speak_special(var/mob/speaker)
	return 1

// Language handling.
/mob/proc/add_language(var/language)
	var/decl/language/new_language = GET_DECL(language)
	if(!istype(new_language) || (new_language in languages))
		return 0
	languages.Add(new_language)
	return 1

/mob/proc/remove_language(var/rem_language)
	var/decl/language/L = GET_DECL(rem_language)
	. = (L in languages)
	languages.Remove(L)

/mob/living/remove_language(rem_language)
	var/decl/language/L = GET_DECL(rem_language)
	if(default_language == L)
		default_language = null
	return ..()

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(decl/language/speaking)
	if(!speaking)
		return 0

	if (only_species_language && speaking != GET_DECL(species_language))
		return 0

	return (speaking.can_speak_special(src) && (universal_speak || (speaking && speaking.flags & INNATE) || (speaking in src.languages)))

/mob/proc/get_language_prefix()
	return get_prefix_key(/decl/prefix/language)

/mob/proc/is_language_prefix(var/prefix)
	return prefix == get_prefix_key(/decl/prefix/language)

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/decl/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b><br/>[L.desc]<br/><br/>"

	show_browser(src, dat, "window=checklanguage")
	return

/mob/living/check_languages()
	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		var/decl/language/lang = GET_DECL(default_language)
		dat += "Current default language: [lang.name] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/decl/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			if(L == default_language)
				dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b> - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/>[L.desc]<br/><br/>"
			else if (can_speak(L))
				dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b> - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a><br/>[L.desc]<br/><br/>"
			else
				dat += "<b>[L.name]([L.shorthand]) ([get_language_prefix()][L.key])</b> - cannot speak!<br/>[L.desc]<br/><br/>"

	show_browser(src, dat, "window=checklanguage")

/mob/living/OnSelfTopic(href_list)
	if(href_list["default_lang"])
		if(href_list["default_lang"] == "reset")

			if (species_language)
				set_default_language(species_language)
			else
				set_default_language(null)

		else
			var/decl/language/L = locate(href_list["default_lang"])
			if(L && (L in languages))
				set_default_language(L)
		check_languages()
		return TOPIC_HANDLED
	return ..()

/proc/transfer_languages(var/mob/source, var/mob/target, var/except_flags)
	for(var/decl/language/L in source.languages)
		if(L.flags & except_flags)
			continue
		target.add_language(L.name)

#undef SCRAMBLE_CACHE_LEN