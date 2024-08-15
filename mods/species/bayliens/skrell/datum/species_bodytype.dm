/decl/bodytype/skrell
	name                 = "skrellian body"
	icon_base            = 'mods/species/bayliens/skrell/icons/body/body.dmi'
	bandages_icon        = 'icons/mob/bandage.dmi'
	health_hud_intensity = 1.75
	associated_gender    = PLURAL
	eye_darksight_range  = 4
	eye_flash_mod        = 1.2
	eye_icon             = 'mods/species/bayliens/skrell/icons/body/eyes.dmi'
	apply_eye_colour     = FALSE
	uid                  = "bodytype_skrell"
	appearance_flags     = HAS_UNDERWEAR | HAS_SKIN_COLOR
	base_color           = "#006666"

	default_sprite_accessories = list(
		SAC_HAIR = list(
			/decl/sprite_accessory/hair/skrell/short = list(SAM_COLOR = "#006666")
		)
	)
	appearance_descriptors = list(
		/datum/appearance_descriptor/height = 1,
		/datum/appearance_descriptor/build = 0.8,
		/datum/appearance_descriptor/headtail_length = 1
	)

	has_organ = list(
		BP_HEART =   /obj/item/organ/internal/heart,
		BP_STOMACH = /obj/item/organ/internal/stomach,
		BP_LUNGS =   /obj/item/organ/internal/lungs/gills,
		BP_LIVER =   /obj/item/organ/internal/liver,
		BP_KIDNEYS = /obj/item/organ/internal/kidneys,
		BP_BRAIN =   /obj/item/organ/internal/brain,
		BP_EYES =    /obj/item/organ/internal/eyes/skrell
	)

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120
	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000
	cold_discomfort_level = 292 //Higher than perhaps it should be, to avoid big speed reduction at normal room temp
	heat_discomfort_level = 368
