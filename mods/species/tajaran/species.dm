/decl/species/tajaran
	name = SPECIES_TAJARA
	name_plural = "Tajaran"

	description = "A small mammalian carnivore. If you are reading this, you are probably a tajaran."
	hidden_from_codex = FALSE
	bodytype = BODYTYPE_HUMANOID
	sexybits_location = BP_GROIN

	min_age = 17
	max_age = 140

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	icobase = 'mods/species/tajaran/icons/body.dmi'
	deform =  'mods/species/tajaran/icons/deformed_body.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	preview_icon = 'mods/species/tajaran/icons/preview.dmi'
	tail_animation = 'mods/species/tajaran/icons/tail.dmi'
	tail = "tajtail"

	flesh_color = "#afa59e"
	base_color = "#333333"
	blood_color = "#862a51"
	organs_icon = 'mods/species/tajaran/icons/organs.dmi'

	default_h_style = "Tajaran Ears"

	darksight_range = 7
	darksight_tint = DARKTINT_GOOD
	slowdown = -0.5
	flash_mod = 2

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
			CULTURE_TAJARA
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
		"r" = list("rr", "rrr", "rrrr")
	)

	autohiss_exempt = list(LANGUAGE_TAJARA)
