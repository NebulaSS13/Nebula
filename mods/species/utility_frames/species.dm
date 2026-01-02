/datum/appearance_descriptor/age/utility_frame
	chargen_min_index = 1
	chargen_max_index = 4
	standalone_value_descriptors = list(
		"brand new"           = 1,
		"worn"                = 5,
		"an older model"      = 15,
		"nearing end-of-life" = 25,
		"entirely obsolete"   = 40
	)

/decl/species/utility_frame
	uid                  = "species_frame"
	name                 = "Drone"
	name_plural          = "Drones"
	description          = "AI-driven synthetics of varying complexity are widely used for many tasks in human space."
	cyborg_noun          = null
	blood_types          = list(/decl/blood_type/coolant)
	available_bodytypes  = list(/decl/bodytype/prosthetic/utility_frame)
	hidden_from_codex    = FALSE
	species_flags        = SPECIES_FLAG_NO_POISON
	spawn_flags          = SPECIES_CAN_JOIN
	strength             = STR_HIGH
	warning_low_pressure = 50
	hazard_low_pressure  = -1
	flesh_color          = COLOR_GUNMETAL
	body_temperature     = null
	passive_temp_gain    = 5  // stabilize at ~80 C in a 20 C environment.
	blood_volume         = 0
	base_external_prosthetics_model = null

	preview_outfit = null

	available_pronouns = list(
		/decl/pronouns/pseudoplural,
		/decl/pronouns/neuter
	)

	exertion_effect_chance = 10
	exertion_charge_scale = 1
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)

/decl/species/utility_frame/Initialize()
	LAZYSET(available_background_info, /decl/background_category/heritage, list(/decl/background_detail/heritage/synthetic))
	. = ..()

/obj/item/organ/external/head/utility_frame
	glowing_eyes = TRUE

/decl/species/utility_frame/disfigure_msg(var/mob/living/human/H)
	. = SPAN_DANGER("The faceplate is dented and cracked!\n")

//Positronics

/datum/appearance_descriptor/age/positronic
	chargen_min_index = 1
	chargen_max_index = 4
	standalone_value_descriptors = list(
		"newly instantiated" = 1,
		"lightly worn"       = 5,
		"aged"               = 40,
		"well-worn"          = 70,
		"near-quiescent"     = 100
	)

/decl/species/utility_frame/positronic
	uid                 = "species_positronic"
	name                = "Positronic"
	name_plural         = "Positronics"
	description         = "Artificial people manufactured from enigmatic ancient technology, and raised among organic life and cultures."
	available_bodytypes = list(/decl/bodytype/prosthetic/utility_frame/positronic)
