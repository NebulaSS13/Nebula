var/global/list/first_name_skrell =  file2list("mods/species/skrell/names/first_name_skrell.txt")
var/global/list/last_name_skrell =   file2list("mods/species/skrell/names/last_name_skrell.txt")

/decl/language/skrell
	name = "Common Skrellian"
	desc = "A set of warbles and hums, the language itself a complex mesh of both melodic and rhythmic components, exceptionally capable of conveying intent and emotion of the speaker."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "sings"
	whisper_verb = "hums"
	colour = "selenian"
	key = "k"
	flags = LANG_FLAG_WHITELISTED
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix","'","!")
	shorthand = "Skr"
	partial_understanding = list(
		/decl/language/skrell/far = 90
	)

/decl/language/skrell/far
	name = "High Skrellian"
	desc = "The most common language among the Skrellian Far Kingdoms. Has an even higher than usual concentration of inaudible phonemes."
	speech_verb = "croaks"
	ask_verb = "trills"
	exclaim_verb = "chirps"
	colour = "selenian"
	key = "p"
	flags = LANG_FLAG_WHITELISTED
	//should sound like there's holes in it
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix", "...", "!", "'", "oo", "q", "nq", "x", "xq", "ll", "...", "...", "...")
	shorthand = "HSk"
	partial_understanding = list(
		/decl/language/skrell = 90
	)

/decl/language/skrell/get_random_name(var/gender)
	return capitalize(pick(global.first_name_skrell)) + capitalize(pick(global.last_name_skrell))
