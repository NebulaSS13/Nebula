//Culture

/decl/cultural_info/culture/tajaran
	name = CULTURE_TAJARA
	description = "The Tajaran culture is steeped in superstition and tradition from centuries of survival on their harsh, frozen homeworld."
	language = /decl/language/tajaran
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)

//Language

/decl/language/tajaran
	name = LANGUAGE_TAJARA
	desc = "The traditionally employed tongue of Ahdomai, composed of expressive yowls and chirps. Native to the Tajaran."
	speech_verb = "purrs"
	ask_verb = "purrs"
	exclaim_verb = "howls"
	whisper_verb = "purrs softly"
	key = "2"
	flags = WHITELISTED
	shorthand = "T"
	syllables = list("mrr","rr","tajr","kir","raj","kii","mir","kra","ahk","nal","vah","khaz","jri","ran","darr",
	"mi","jri","dynh","manq","rhe","zar","rrhaz","kal","chur","eech","thaa","dra","jurl","mah","sanu","dra","ii'r",
	"ka","aasi","far","wa","baq","ara","qara","zir","sam","mak","hrar","nja","rir","khan","jun","dar","rik","kah",
	"hal","ket","jurl","mah","tul","cresh","azu","ragh","mro","mra","mrro","mrra")

/decl/language/tajaran/get_random_name(var/gender, name_count=2, syllable_count=4, syllable_divisor=2)
	var/new_name = ..(gender,1)
	if(prob(70))
		new_name += " [pick(list("Hadii","Kaytam","Nazkiin","Zhan-Khazan","Hharar","Njarir'Akhan","Faaira'Nrezi","Rhezar","Mi'dynh","Rrhazkal","Bayan","Al'Manq","Mi'jri","Chur'eech","Sanu'dra","Ii'rka"))]"
	else
		new_name += " [..(gender,1)]"
	return new_name

//#803b56 is color

/decl/language/tajaran/format_message(message, verb)
	return "[verb], <span class='message'><span style='color: #803b56'>\"[capitalize(filter_modify_message(message))]\"</span></span>"

/decl/language/tajaran/format_message_radio(message, verb)
	return "[verb], <span style='color: #803b56'>\"[capitalize(filter_modify_message(message))]\"</span>"
