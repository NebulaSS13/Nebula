/decl/language/cultcommon
	name = "Cult"
	desc = "The chants of the occult, the incomprehensible."
	speech_verb = "intones"
	ask_verb = "intones"
	exclaim_verb = "chants"
	colour = "cult"
	key = "f"
	flags = LANG_FLAG_RESTRICTED
	space_chance = 100
	syllables = list("ire","ego","nahlizet","certum","veri","jatkaa","mgar","balaq", "karazet", "geeri", \
		"orkan", "allaq", "sas'so", "c'arta", "forbici", "tarem", "n'ath", "reth", "sh'yro", "eth", "d'raggathnor", \
		"mah'weyh", "pleggh", "at", "e'ntrath", "tok-lyr", "rqa'nap", "g'lt-ulotf", "ta'gh", "fara'qha", "fel", "d'amar det", \
		"yu'gular", "faras", "desdae", "havas", "mithum", "javara", "umathar", "uf'kal", "thenar", "rash'tla", \
		"sektath", "mal'zua", "zasan", "therium", "viortia", "kla'atu", "barada", "nikt'o", "fwe'sh", "mah", "erl", "nyag", "r'ya", \
		"gal'h'rfikk", "harfrandid", "mud'gib", "fuu", "ma'jin", "dedo", "ol'btoh", "n'ath", "reth", "sh'yro", "eth", \
		"d'rekkathnor", "khari'd", "gual'te", "nikka", "nikt'o", "barada", "kla'atu", "barhah", "hra" ,"zar'garis")
	machine_understands = 0
	shorthand = "CT"
	hidden_from_codex = TRUE

/decl/language/cult
	name = "Occult"
	desc = "The initiated can share their thoughts by means defying all reason."
	speech_verb = "intones"
	ask_verb = "intones"
	exclaim_verb = "chants"
	colour = "cult"
	key = "y"
	flags = LANG_FLAG_RESTRICTED | LANG_FLAG_HIVEMIND
	shorthand = "N/A"
	hidden_from_codex = TRUE

/decl/language/alium
	name = "Alium"
	colour = "cult"
	speech_verb = "hisses"
	key = "c"
	flags = LANG_FLAG_RESTRICTED
	syllables = list("qy","bok","mok","yok","dy","gly","ryl","byl","dok","forbici", "tarem", "n'ath", "reth", "sh'yro", "eth", "d'raggathnor","niii",
	"d'rekkathnor", "khari'd", "gual'te", "ki","ki","ki","ki","ya","ta","wej","nym","assah","qwssa","nieasl","qyno","shaffar",
	"eg","bog","voijs","nekks","bollos","qoulsan","borrksakja","neemen","aka","nikka","qyegno","shafra","beolas","Byno")
	machine_understands = 0
	shorthand = "AL"
	hidden_from_codex = TRUE

/decl/language/alium/Initialize()
	. = ..()
	speech_verb = pick("hisses","growls","whistles","blubbers","chirps","skreeches","rumbles","clicks")

/decl/language/alium/get_random_name()
	var/new_name = ""
	var/name_length = rand(1,3)
	for(var/i=0 to name_length)
		new_name += pick(syllables)
	return capitalize(new_name)