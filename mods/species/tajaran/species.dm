/decl/species/tajaran
	name = SPECIES_TAJARA
	name_plural = "Tajaran"

	description = "A small mammalian carnivore. If you are reading this, you are probably a Tajaran."
	hidden_from_codex = FALSE
	bodytype = BODYTYPE_FELINE
	sexybits_location = BP_GROIN
	limb_blend = ICON_MULTIPLY

	min_age = 17
	max_age = 140

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	icobase = 'mods/species/tajaran/icons/body.dmi'
	deform =  'mods/species/tajaran/icons/deformed_body.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	preview_icon = 'mods/species/tajaran/icons/preview.dmi'
	lip_icon = 'mods/species/tajaran/icons/lips.dmi'
	tail_animation = 'mods/species/tajaran/icons/tail.dmi'
	tail = "tajtail"
	tail_blend = ICON_MULTIPLY

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

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes/taj
	)

/decl/species/tajaran/New()
	equip_adjust = list(
		BP_L_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		BP_R_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_wear_id_str =    list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_wear_suit_str =  list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_w_uniform_str =  list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_back_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_belt_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_underpants_str = list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_undershirt_str = list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2))
	)
	. = ..()
	

/obj/item/organ/internal/eyes/taj
	eye_blend = ICON_MULTIPLY
	eye_icon = 'mods/species/tajaran/icons/eyes.dmi'

/decl/species/tajaran/handle_additional_hair_loss(var/mob/living/carbon/human/H, var/defer_body_update = TRUE)
	. = H && H.change_skin_color(189, 171, 143)

/decl/species/tajaran/handle_post_species_pref_set(var/datum/preferences/pref)
	pref.body_markings = pref.body_markings || list()
	if(!pref.body_markings["Tajaran Wide Ears"])
		pref.body_markings["Tajaran Wide Ears"] = "#888888"
	pref.skin_colour = "#787878"
	pref.hair_colour = "#515151"
	pref.facial_hair_colour = "#515151"
	pref.eye_colour = "#00aa00"