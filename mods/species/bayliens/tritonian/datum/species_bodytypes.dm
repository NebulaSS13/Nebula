/decl/bodytype/human/tritonian
	icon_base = 'mods/species/bayliens/tritonian/icons/body_female.dmi'
	movement_slowdown = 0.5
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_TRITON | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	override_organ_types = list(
		BP_LUNGS = /obj/item/organ/internal/lungs/gills
	)

/decl/bodytype/human/tritonian/masculine
	name =                   "masculine"
	icon_base =              'mods/species/bayliens/tritonian/icons/body_male.dmi'
	icon_deformed =          'icons/mob/human_races/species/human/deformed_body_male.dmi'
	associated_gender =      MALE
	uniform_state_modifier = null