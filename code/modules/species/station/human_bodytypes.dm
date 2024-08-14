/decl/bodytype/human
	name                  = "feminine"
	bodytype_category     = BODYTYPE_HUMANOID
	cosmetics_icon        = 'icons/mob/human_races/species/default_cosmetics.dmi'
	icon_base             = 'icons/mob/human_races/species/human/body_female.dmi'
	icon_deformed         = 'icons/mob/human_races/species/human/deformed_body_female.dmi'
	blood_overlays        = 'icons/mob/human_races/species/human/blood_overlays.dmi'
	bandages_icon         = 'icons/mob/bandage.dmi'
	limb_icon_intensity   = 0.7
	associated_gender     = FEMALE
	onmob_state_modifiers = list(slot_w_uniform_str = "f")
	appearance_flags      = HAS_SKIN_TONE_NORMAL | HAS_UNDERWEAR | HAS_EYE_COLOR
	nail_noun             = "nails"
	uid                   = "bodytype_human_fem"

/decl/bodytype/human/masculine
	name                  = "masculine"
	icon_base             = 'icons/mob/human_races/species/human/body_male.dmi'
	icon_deformed         = 'icons/mob/human_races/species/human/deformed_body_male.dmi'
	associated_gender     = MALE
	uid                   = "bodytype_human_masc"
	onmob_state_modifiers = null
	override_emote_sounds = list(
		"cough" = list(
			'sound/voice/emotes/m_cougha.ogg',
			'sound/voice/emotes/m_coughb.ogg',
			'sound/voice/emotes/m_coughc.ogg'
		),
		"sneeze" = list(
			'sound/voice/emotes/m_sneeze.ogg'
		)
	)
