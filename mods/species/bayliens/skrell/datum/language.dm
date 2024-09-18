var/global/list/first_name_skrell =  file2list("mods/species/bayliens/skrell/names/first_name_skrell.txt")
var/global/list/last_name_skrell =   file2list("mods/species/bayliens/skrell/names/last_name_skrell.txt")

/decl/language/skrell
	name = "Common Skrellian"
	desc = "A melodic and complex language spoken by the Skrell of the Oligarchy. Some of the notes are inaudible to humans."
	speech_verb = "warbles"
	ask_verb = "trills"
	exclaim_verb = "croaks"
	colour = "selenian"
	key = "k"
	flags = LANG_FLAG_WHITELISTED
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix","'","!")
	shorthand = "SK"
	partial_understanding = list(
		/decl/language/skrell/casteless = 90
	)

/decl/language/skrell/casteless
	name = "Ue-Katish Cant"
	desc = "A flat and emotionless language spoken mainly by Ue-Katish pirates, laden with slurs and insults."
	speech_verb = "croaks"
	ask_verb = "trills"
	exclaim_verb = "chirps"
	colour = "selenian"
	key = "h"
	flags = LANG_FLAG_WHITELISTED
	syllables = list("qra","xa","vilz*","s!zaao","qu!*m","girx","vol","xrim","za-r*oo","qu-xx","qix","qa'taz","zix","tuep","!","*")
	shorthand = "UK"
	partial_understanding = list(
		/decl/language/skrell = 90
	)

/decl/language/skrell/get_random_name(var/gender)
	return capitalize(pick(global.first_name_skrell)) + capitalize(pick(global.last_name_skrell))