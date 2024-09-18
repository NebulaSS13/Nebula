/datum/appearance_descriptor/age/tajaran
	standalone_value_descriptors = list(
		"an infant" =       1,
		"a toddler" =       3,
		"a child" =         7,
		"an adolescent" =  13,
		"a young adult" =  18,
		"an adult" =       30,
		"middle-aged" =    50,
		"aging" =          65,
		"elderly" =        80
	)

/decl/species/tajaran
	name = SPECIES_TAJARA
	name_plural = "Tajaran"
	base_external_prosthetics_model = null

	description = "The Tajaran are a mammalian species roughly resembling felines, \
	hailing from Meralar in the Rarkajar system. \
	While they were becoming multiplanetary in their home system, \
	the humans established first contact and engaged them in peaceful trade, \
	and have accelerated the fledgling spacefarers into the interstellar age. \
	Their history is full of conflict and highly fractious governments, \
	a tradition alive and well in the modern era. \
	They prefer colder, tundra-like climates, much like their home world, \
	and speak a variety of languages, most notably Siik and Akhani."

	hidden_from_codex = FALSE
	available_bodytypes = list(/decl/bodytype/feline)

	preview_outfit = /decl/outfit/job/generic/engineer

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

	organs_icon = 'mods/species/tajaran/icons/organs.dmi'

	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.2
	thirst_factor = DEFAULT_THIRST_FACTOR * 1.2
	gluttonous = GLUT_TINY

	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite/sharp
	)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

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

	autohiss_exempt = list(LANGUAGE_TAJARA)

/decl/species/tajaran/Initialize()
	. = ..()
	LAZYINITLIST(available_background_info)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/citizenship], /decl/background_detail/citizenship/pearlshield)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/tajaran)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/tajaran/njarir)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/tajaran/rhemazar)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/tajaran/spacer)

/decl/species/tajaran/handle_additional_hair_loss(var/mob/living/human/H, var/defer_body_update = TRUE)
	. = H?.set_skin_colour(rgb(189, 171, 143))
