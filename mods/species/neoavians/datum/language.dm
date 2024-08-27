/decl/language/neoavian
	name = "Schechi"
	desc = "A trilling language spoken by the diminutive Teshari."
	speech_verb = "chirps"
	ask_verb = "chirrups"
	exclaim_verb = "trills"
	colour = "alien"
	key = "v"
	shorthand = "Sch"
	flags = LANG_FLAG_WHITELISTED
	space_chance = 50
	partial_understanding = list(/decl/language/human/common = 5, /decl/language/skrell = 15)
	syllables = list(
			"ca", "ra", "ma", "sa", "na", "ta", "la", "sha", "scha", "a", "a",
			"ce", "re", "me", "se", "ne", "te", "le", "she", "sche", "e", "e",
			"ci", "ri", "mi", "si", "ni", "ti", "li", "shi", "schi", "i", "i"
		)

/decl/language/neoavian/get_random_language_name(gender, name_count=2, syllable_count=4, syllable_divisor=2)
	return ..(gender, 2, 4, 1.5)
