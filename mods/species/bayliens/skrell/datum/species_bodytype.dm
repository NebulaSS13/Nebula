/decl/bodytype/skrell
	name =                 BODYTYPE_SKRELL
	icon_base =            'mods/species/bayliens/skrell/icons/body/body.dmi'
	bandages_icon =        'icons/mob/bandage.dmi'
	bandages_icon =        'icons/mob/bandage.dmi'
	health_hud_intensity = 1.75
	associated_gender = PLURAL
	eye_darksight_range = 4
	eye_flash_mod = 1.2
	eye_icon = 'mods/species/bayliens/skrell/icons/body/eyes.dmi'
	apply_eye_colour = FALSE

	associated_gender =    PLURAL
	appearance_flags =     HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR
	base_color =         "#006666"
	base_hair_color =    "#006666"
	has_organ = list(
		BP_HEART =   /obj/item/organ/internal/heart,
		BP_STOMACH = /obj/item/organ/internal/stomach,
		BP_LUNGS =   /obj/item/organ/internal/lungs/gills,
		BP_LIVER =   /obj/item/organ/internal/liver,
		BP_KIDNEYS = /obj/item/organ/internal/kidneys,
		BP_BRAIN =   /obj/item/organ/internal/brain,
		BP_EYES =    /obj/item/organ/internal/eyes/skrell
	)
	default_h_style = /decl/sprite_accessory/hair/skrell/short
