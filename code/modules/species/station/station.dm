/decl/species/human
	name = SPECIES_HUMAN
	name_plural = "Humans"
	primitive_form = SPECIES_MONKEY
	unarmed_attacks = list(/decl/natural_attack/stomp, /decl/natural_attack/kick, /decl/natural_attack/punch, /decl/natural_attack/bite)
	description = "A medium-sized creature prone to great ambition. If you are reading this, you are probably a human."
	min_age = 17
	max_age = 100
	hidden_from_codex = FALSE
	bandages_icon = 'icons/mob/bandage.dmi'
	bodytype = BODYTYPE_HUMANOID
	limb_icon_intensity = 0.7

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_NORMAL | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	sexybits_location = BP_GROIN

	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_OTHER,
			CULTURE_HUMAN
		)
	)

/decl/species/human/get_root_species_name(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN

/decl/species/human/get_ssd(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS)
		return "staring blankly, not reacting to your presence"
	return ..()
