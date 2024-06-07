/decl/language/corvid
	name = "Crow Cant"
	shorthand = "CR"
	desc = "A rough, loud language spoken by neo-corvids and a number of other post-avian species."
	speech_verb = "chirps"
	ask_verb = "rattles"
	exclaim_verb = "calls"
	colour = "alien"
	key = "v"
	flags = LANG_FLAG_WHITELISTED
	space_chance = 50
	syllables = list(
			"ca", "ra", "ma", "sa", "na", "ta", "la", "sha",
			"ti","hi","ki","ya","ta","ha","ka","ya","chi","cha","kah",
			"skre","ahk","ek","rawk","kraa","ii","kri","ka"
		)
	speech_sounds = list(
		'mods/species/neoavians/sound/crow1.ogg',
		'mods/species/neoavians/sound/crow2.ogg',
		'mods/species/neoavians/sound/crow3.ogg',
		'mods/species/neoavians/sound/crow4.ogg'
	)

/decl/language/corvid/get_random_name(gender)
	. = capitalize((gender == FEMALE) ? pick(global.using_map.first_names_female) : pick(global.using_map.first_names_male))
	. += " [pick(list("Albus","Corax","Corone","Meeki","Insularis","Orru","Sinaloae", "Enca", "Edithae", "Kubaryi"))]"
	. += " [pick(list("Hyperion","Earth","Mars","Venus","Neith","Luna","Halo","Pandora","Neptune","Triton", "Haumea", "Eris", "Makemake"))]"

/decl/language/neoavian
	name = "Neo-Avian Pidgin" // pigeon
	desc = "A cluster of melodic, trilling languages spoken by the majority of neo-avian subcultures."
	speech_verb = "chirps"
	ask_verb = "chirrups"
	exclaim_verb = "trills"
	colour = "alien"
	key = "i"
	flags = LANG_FLAG_WHITELISTED
	space_chance = 50
	syllables = list(
			"ca", "ra", "ma", "sa", "na", "ta", "la", "sha", "scha", "a", "a",
			"ce", "re", "me", "se", "ne", "te", "le", "she", "sche", "e", "e",
			"ci", "ri", "mi", "si", "ni", "ti", "li", "shi", "schi", "i", "i"
		)

/decl/language/neoavian/get_random_name(gender)
	return ..(gender, 2, 4, 1.5)

/decl/cultural_info/culture/neoavian
	name = "Neo-Avian Milieu"
	description = "Neo-avians form a loose coalition of family and flock groupings, and are usually in an extreme minority in human settlements. \
	They tend to cope poorly with confined, crowded spaces like human habs, and often make their homes in hab domes or other spacious facilities."
	language = /decl/language/neoavian
	secondary_langs = list(
		/decl/language/corvid,
		/decl/language/neoavian,
		/decl/language/sign
	)

/decl/cultural_info/culture/neoavian/saurian
	name = "Saurian Revivalism"
	description = "A minority of neo-avians, particularly those subject to genetic modification during the initial uplift of their species, \
	embrace the dinosaur heritage shared by all avians in the form of scales, sharp teeth, slender tails, and other clear visible features of \
	their long-extinct forebears. Many neo-avians consider them a fringe of self-important wannabes, but the movement is still going strong."
