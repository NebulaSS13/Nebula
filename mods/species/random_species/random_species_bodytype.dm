/decl/bodytype/alium
	name              = "humanoid"
	bodytype_category = BODYTYPE_HUMANOID
	icon_base         = 'icons/mob/human_races/species/humanoid/body.dmi'
	bandages_icon     = 'icons/mob/bandage.dmi'
	limb_blend        = ICON_MULTIPLY
	appearance_flags  = HAS_SKIN_COLOR
	body_flags        = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	uid               = "bodytype_alium"

/decl/bodytype/alium/Initialize()
	if(prob(10))
		movement_slowdown += pick(-1,1)
	if(prob(5))
		body_flags |= BODY_FLAG_NO_PAIN
	base_color  = RANDOM_RGB
	MULT_BY_RANDOM_COEF(eye_flash_mod, 0.5, 1.5)
	eye_darksight_range = rand(1,8)
	var/temp_comfort_shift = rand(-50,50)
	cold_level_1 += temp_comfort_shift
	cold_level_2 += temp_comfort_shift
	cold_level_3 += temp_comfort_shift
	heat_level_1 += temp_comfort_shift
	heat_level_2 += temp_comfort_shift
	heat_level_3 += temp_comfort_shift
	heat_discomfort_level += temp_comfort_shift
	cold_discomfort_level += temp_comfort_shift
	. = ..()