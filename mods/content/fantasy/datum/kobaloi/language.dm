/decl/language/kobaloi
	name = "Kobaloi Tongue"
	shorthand = "KB"
	desc = "The kobaloi have a huge variety of languages, sometimes differing even between groups in the same cave system, but all of them have some degree of overlap to allow mutual intelligibility."
	speech_verb = "says"
	ask_verb = "asks"
	exclaim_verb = "exclaims"
	colour = "indian"
	key = "m"
	flags = LANG_FLAG_WHITELISTED
	space_chance = 100 // We generate entire words rather than syllables, so we always need a space.

	// Consonant and vowel lists adapted from https://dwarffortresswiki.org/index.php/DF2014:Kobold_language
	// Fine detail was not adapted as it was more effort than I wanted to put in for a video game reference.
	var/list/s1c1 = list("b", "d", "st", "sh", "s", "t", "th", "ch", "l", "f", "g", "k", "p", "j")
	var/list/s1c2 = list("r", "l", "")
	var/list/s1v  = list("a", "o", "u", "ay", "ee", "i")
	var/list/s2c  = list("b", "d", "l", "f", "g", "k")
	var/list/s2v  = list("a", "i", "o", "u")
	var/list/s3c  = list("m", "r", "ng", "b", "rb", "mb", "g", "lg", "l", "lb", "lm", "k", "nk", "ld", "d", "rsn")
	var/list/s3r  = list("is", "us", "er", "in")

/decl/language/kobaloi/get_random_name(gender, name_count=2, syllable_count=4, syllable_divisor=2)
	return capitalize(get_next_scramble_token())

/decl/language/kobaloi/get_next_scramble_token()
	var/list/word = list()

	// 1-2 primary syllables
	for(var/i = 1 to rand(1, 2))
		word += pick(s1c1)
		word += pick(s1c2)
		word += pick(s1v)

	// 0-2 secondary syllables
	for(var/i = 1 to rand(1,3)-1)
		word += pick(s2c)
		word += pick(s2v)

	// 1 final syllable
	word += pick(s3c)
	word += pick(s3r)

	return jointext(word, null)

