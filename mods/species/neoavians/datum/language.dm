/decl/language/corvid
	name = "Crow Cant"
	shorthand = "CR"
	desc = "A rough, loud language spoken by neo-corvids and other post-avian species."
	speech_verb = "chirps"
	ask_verb = "rattles"
	exclaim_verb = "calls"
	colour = "alien"
	key = "v"
	flags = WHITELISTED
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
	. = capitalize((gender == FEMALE) ? pick(GLOB.first_names_female) : pick(GLOB.first_names_male))
	. += " [pick(list("Albus","Corax","Corone","Meeki","Insularis","Orru","Sinaloae", "Enca", "Edithae", "Kubaryi"))]"
	. += " [pick(list("Hyperion","Earth","Mars","Venus","Neith","Luna","Halo","Pandora","Neptune","Triton", "Haumea", "Eris", "Makemake"))]"
