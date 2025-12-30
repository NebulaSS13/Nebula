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
	uid = "species_tajaran"
	name = "Tajara"
	name_plural = "Tajaran"
	base_external_prosthetics_model = null

	description = "A small mammalian carnivore. If you are reading this, you are probably a Tajaran."
	hidden_from_codex = FALSE
	available_bodytypes = list(
		/decl/bodytype/tajaran,
		/decl/bodytype/tajaran/masculine
	)

	traits = list(/decl/trait/malus/intolerance/caffeine = TRAIT_LEVEL_MAJOR)

	preview_outfit = /decl/outfit/job/generic/engineer

	spawn_flags = SPECIES_CAN_JOIN

	blood_types = list(
		/decl/blood_type/tajaran/mplus,
		/decl/blood_type/tajaran/mminus,
		/decl/blood_type/tajaran/rplus,
		/decl/blood_type/tajaran/rminus,
		/decl/blood_type/tajaran/mrplus,
		/decl/blood_type/tajaran/mrminus,
		/decl/blood_type/tajaran/oplus,
		/decl/blood_type/tajaran/ominus
	)

	flesh_color = "#ae7d32"

	organs_icon = 'mods/species/tajaran/icons/organs.dmi'

	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.2
	thirst_factor = DEFAULT_THIRST_FACTOR * 1.2
	gluttonous = GLUT_TINY

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	available_background_info = list(
		/decl/background_category/heritage = list(
			/decl/background_detail/heritage/tajaran,
			/decl/background_detail/heritage/other
		)
	)

	default_emotes = list(
		/decl/emote/visible/tail/swish,
		/decl/emote/visible/tail/wag,
		/decl/emote/visible/tail/sway,
		/decl/emote/visible/tail/qwag,
		/decl/emote/visible/tail/fastsway,
		/decl/emote/visible/tail/swag,
		/decl/emote/visible/tail/stopsway,
		/decl/emote/audible/purr,
		/decl/emote/audible/purrlong
	)

	//Autohiss
	autohiss_basic_map = list(
		"r" = list("rr", "rrr", "rrrr"),
		"р" = list("рр", "ррр", "рррр")//thats not "pi"
	)

	autohiss_exempt = list(LANGUAGE_TAJARAN)

/decl/species/tajaran/handle_additional_hair_loss(var/mob/living/human/H, var/defer_body_update = TRUE)
	. = H?.set_skin_colour(rgb(189, 171, 143))
