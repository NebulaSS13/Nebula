//base human language
/decl/language/human
	name = "proto-sapien"
	desc = "This is the human root language. If you have this, please tell a developer."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = "solcom"
	flags = LANG_FLAG_WHITELISTED | LANG_FLAG_RESTRICTED
	shorthand = "???"
	space_chance = 40
	abstract_type = /decl/language/human

/decl/language/human/get_spoken_verb(mob/living/speaker, msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells")
		if("?")
			return ask_verb
	return speech_verb

/decl/language/human/get_random_name(var/gender)
	if (prob(80))
		if(gender==FEMALE)
			return capitalize(pick(global.using_map.first_names_female)) + " " + capitalize(pick(global.using_map.last_names))
		else
			return capitalize(pick(global.using_map.first_names_male)) + " " + capitalize(pick(global.using_map.last_names))
	else
		return ..()

/*//////////////////////////////////////////////////////////////////////////////////////////////////////
	Syllable list compiled in this file based on work by Stefan Trost, available at the following URLs
						https://www.sttmedia.com/syllablefrequency-english
						https://www.sttmedia.com/syllablefrequency-french
						https://www.sttmedia.com/syllablefrequency-german
*///////////////////////////////////////////////////////////////////////////////////////////////////////

/decl/language/human/common
	name = "Common"
	desc = "The common language of most human settlements."
	speech_verb = "says"
	whisper_verb = "whispers"
	colour = ""
	key = "1"
	flags = LANG_FLAG_WHITELISTED
	shorthand = "C"
	partial_understanding = list()
	syllables = list(
		"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
		"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
		"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
		"ch", "de", "ge", "be", "ach", "abe", "ich", "ein", "die", "sch", "auf", "aus", "ber", "che", "ent", "que",
		"ait", "les", "lle", "men", "ais", "ans", "ait", "ave", "con", "com", "des", "tre", "eta", "eur", "est",
		"ing", "the", "ver", "was", "ith", "hin"
	)
