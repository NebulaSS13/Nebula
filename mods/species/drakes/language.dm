// TODO: some way to handle this with a voicebox organ or something along those lines.
/decl/language
	var/drake_compatible = FALSE

// These languages shouldn't care about the speaker bodytype.
/decl/language/noise
	drake_compatible = null
/decl/language/cult
	drake_compatible = null
/decl/language/cultcommon
	drake_compatible = null
/decl/language/binary
	drake_compatible = null
/decl/language/alium
	drake_compatible = null

/decl/language/can_be_spoken_properly_by(var/mob/speaker)
	. = ..()
	if(. != SPEECH_RESULT_INCAPABLE && !isnull(drake_compatible) && istype(speaker?.get_bodytype(), /decl/bodytype/quadruped/grafadreka) != drake_compatible)
		return SPEECH_RESULT_INCAPABLE

/decl/language/grafadreka
	name = "Drake Language"
	shorthand = "DR"
	desc = "Hiss hiss, feed me siffets."
	speech_verb = "hisses"
	ask_verb = "chirps"
	exclaim_verb = "rumbles"
	colour = "alien"
	key = "l" // l is for lizard, probably
	flags = LANG_FLAG_RESTRICTED
	machine_understands = 0
	space_chance = 30
	syllables = list("hss", "ssh", "khs", "hrr", "rrr", "rrn")
	drake_compatible = TRUE

/decl/language/grafadreka/get_random_name()
	var/static/list/drake_names = list(
		"Almond",     "Pepper",      "Pear",        "Apple",       "Apricot",
		"Crabapple",  "Berry",       "Quince",      "Hawthorn",    "Rowan",
		"Cherry",     "Mango",       "Plum",        "Peach",       "Jelly",
		"Gooseberry", "Olive",       "Silverberry", "Elderberry",  "Coffee",
		"Bearberry",  "Currant",     "Cactus",      "Guava",       "Banana",
		"Kiwifruit",  "Lingonberry", "Papaya",      "Persimmon",   "Huckleberry",
		"Tamarillo",  "Dragonfruit", "Wolfberry",   "Melon",       "Orange",
		"Lemon",      "Lime",        "Tamarind",    "Juniper",     "Rhubarb",
		"Acorn",      "Candlenut",   "Hazlenut",    "Peanut",      "Kola",
		"Bopple",     "Cashew",      "Hazel",       "Coconut",     "Pistachio",
		"Walnut",     "Macadamia",   "Soybean",     "Mandarin",    "Tangelo",
		"Raspberry",  "Cloudberry",  "Mulberry",    "Salmonberry", "Strawberry",
		"Fig",        "Duiran",      "Vanilla",     "Pepper",      "Allspice",
		"Anise",      "Basil",       "Bayleaf",     "Caper",       "Cilantro",
		"Cinnamon",   "Clove",       "Cardamom",    "Chives",      "Chili",
		"Curry",      "Coriander",   "Celery",      "Dill",        "Fennel",
		"Garlic",     "Ginger",      "Horseradish", "Jasmine",     "Lavender",
		"Lemongrass", "Licorice",    "Marjoram",    "Mustard",     "Nutmeg",
		"Oregano",    "Pennyroyal",  "Peppermint",  "Poppyseed",   "Parsley",
		"Rosemary",   "Tarragon",    "Spearmint",   "Thyme",       "Tumeric",
		"Wasabi"
	)
	return pick(drake_names)
