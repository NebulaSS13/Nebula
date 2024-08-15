/decl/bodytype/human/tritonian
	icon_base             = 'mods/species/bayliens/tritonian/icons/body_female.dmi'
	movement_slowdown     = 0.5
	appearance_flags      = HAS_SKIN_TONE_TRITON | HAS_UNDERWEAR | HAS_EYE_COLOR
	uid                   = "bodytype_tritonian_fem"
	override_organ_types  = list(
		BP_LUNGS = /obj/item/organ/internal/lungs/gills
	)

/decl/bodytype/human/tritonian/masculine
	name                  = "masculine"
	icon_base             = 'mods/species/bayliens/tritonian/icons/body_male.dmi'
	icon_deformed         = 'icons/mob/human_races/species/human/deformed_body_male.dmi'
	associated_gender     = MALE
	onmob_state_modifiers = null
	uid                   = "bodytype_tritonian_masc"
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
