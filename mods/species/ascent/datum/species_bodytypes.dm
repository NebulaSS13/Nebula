/decl/bodytype/alate
	name =              "alate"
	bodytype_category = BODYTYPE_MANTID_SMALL
	icon_base =         'mods/species/ascent/icons/species/body/alate/body.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/alate/blood_overlays.dmi'
	associated_gender = MALE
	bodytype_flag =     BODY_FLAG_ALATE

/decl/bodytype/gyne
	name =              "gyne"
	bodytype_category = BODYTYPE_MANTID_LARGE
	icon_base =         'mods/species/ascent/icons/species/body/gyne/body.dmi'
	icon_template =     'mods/species/ascent/icons/species/body/gyne/template.dmi'
	damage_overlays =   'mods/species/ascent/icons/species/body/gyne/damage_overlays.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/gyne/blood_overlays.dmi'
	pixel_offset_x =    -4
	antaghud_offset_y = 18
	antaghud_offset_x = 4
	associated_gender = FEMALE
	bodytype_flag =     BODY_FLAG_GYNE

/decl/bodytype/gyne/Initialize()
	equip_adjust = list(
		BP_L_HAND = list(
			"[NORTH]" = list("x" = -4, "y" = 12),
			"[EAST]" = list("x" =  -4, "y" = 12),
			"[SOUTH]" = list("x" = -4, "y" = 12),
			"[WEST]" = list("x" =  -4, "y" = 12)
		)
	)
	. = ..()

