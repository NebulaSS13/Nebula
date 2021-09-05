/decl/language/resomi
	name = LANGUAGE_RESOMI
	desc = "A trilling language spoken by the diminutive Resomi."
	speech_verb  = "chirps"
	ask_verb     = "chirrups"
	exclaim_verb = "chirrups"
	whisper_verb = "chirps softly"
	key   = "e"
	flags = WHITELISTED
	shorthand = "SCH"
	syllables = list(
		"ca", "ra", "ma", "sa", "na", "ta", "la", "sha", "scha", "a", "a",
		"ce", "re", "me", "se", "ne", "te", "le", "she", "sche", "e", "e",
		"ci", "ri", "mi", "si", "ni", "ti", "li", "shi", "schi", "i", "i")
	colour = "alien"
	space_chance = 50

/decl/language/resomi/get_random_name(gender)
	return ..(gender, 1, 4, 1.5)
