/datum/appearance_descriptor/age/tajaran
	standalone_value_descriptors = list(
		"an infant" =       1,
		"a toddler" =       3,
		"a child" =         7,
		"an adolescent" =  13,
		"a young adult" =  18,
		"an adult" =       30,
		"middle-aged" =    55,
		"aging" =          80,
		"elderly" =       140
	)

/decl/species/tajaran
	name = SPECIES_TAJARA
	name_plural = "Tajaran"
	base_prosthetics_model = null

	description = "A small mammalian carnivore. If you are reading this, you are probably a Tajaran."
	hidden_from_codex = FALSE

	age_descriptor = /datum/appearance_descriptor/age/tajaran

	available_bodytypes = list(/decl/bodytype/feline)

	preview_outfit = /decl/hierarchy/outfit/job/generic/engineer

	spawn_flags = SPECIES_CAN_JOIN

	blood_types = list(
		/decl/blood_type/feline/mplus,
		/decl/blood_type/feline/mminus,
		/decl/blood_type/feline/rplus,
		/decl/blood_type/feline/rminus,
		/decl/blood_type/feline/mrplus,
		/decl/blood_type/feline/mrminus,
		/decl/blood_type/feline/oplus,
		/decl/blood_type/feline/ominus
	)

	flesh_color = "#ae7d32"

	organs_icon = 'mods/species/bayliens/tajaran/icons/organs.dmi'

	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.2
	gluttonous = GLUT_TINY

	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite/sharp
	)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	cold_level_1 = 200
	cold_level_2 = 140
	cold_level_3 = 80

	heat_level_1 = 330
	heat_level_2 = 380
	heat_level_3 = 800

	heat_discomfort_level = 294
	cold_discomfort_level = 230

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)

	available_cultural_info = list(
		TAG_CULTURE = list(
			/decl/cultural_info/culture/tajaran,
			/decl/cultural_info/culture/other
		)
	)

	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway,
		/decl/emote/audible/purr,
		/decl/emote/audible/purrlong
	)

	//Autohiss
	autohiss_basic_map = list(
		"r" = list("rr", "rrr", "rrrr"),
		"р" = list("рр", "ррр", "рррр")//thats not "pi"
	)

	autohiss_exempt = list(LANGUAGE_TAJARA)

/decl/species/tajaran/handle_additional_hair_loss(var/mob/living/carbon/human/H, var/defer_body_update = TRUE)
	. = H && H.change_skin_color(rgb(189, 171, 143))
