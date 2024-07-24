/decl/bodytype/feline
	name                 = "humanoid"
	bodytype_category    = BODYTYPE_FELINE
	limb_blend           = ICON_MULTIPLY
	icon_template        = 'mods/species/bayliens/tajaran/icons/template.dmi'
	icon_base            = 'mods/species/bayliens/tajaran/icons/body.dmi'
	icon_deformed        = 'mods/species/bayliens/tajaran/icons/deformed_body.dmi'
	bandages_icon        = 'icons/mob/bandage.dmi'
	skeletal_icon        = 'mods/species/bayliens/tajaran/icons/skeleton.dmi'
	cosmetics_icon       = 'mods/species/bayliens/tajaran/icons/cosmetics.dmi'
	health_hud_intensity = 1.75
	bodytype_flag        = BODY_FLAG_FELINE
	movement_slowdown    = -0.5
	appearance_flags     = HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	base_color           = "#ae7d32"
	base_eye_color       = "#00aa00"
	nail_noun            = "claws"

	age_descriptor = /datum/appearance_descriptor/age/tajaran

	eye_darksight_range  = 7
	eye_flash_mod        = 2
	eye_blend            = ICON_MULTIPLY
	eye_icon             = 'mods/species/bayliens/tajaran/icons/eyes.dmi'
	eye_low_light_vision_effectiveness    = 0.15
	eye_low_light_vision_adjustment_speed = 0.3

	override_limb_types = list(
		BP_TAIL = /obj/item/organ/external/tail/cat
	)

	default_sprite_accessories = list(
		SAC_HAIR     = list(/decl/sprite_accessory/hair/taj/lynx        = "#46321c"),
		SAC_MARKINGS = list(/decl/sprite_accessory/marking/tajaran/ears = "#ae7d32")
	)

	cold_level_1 = 200
	cold_level_2 = 140
	cold_level_3 = 80

	heat_level_1 = 330
	heat_level_2 = 380
	heat_level_3 = 800

	heat_discomfort_level   = 294
	cold_discomfort_level   = 230
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)

/decl/bodytype/feline/Initialize()
	equip_adjust = list(
		slot_glasses_str =   list("[NORTH]" = list(0, 2), "[EAST]" = list(0, 2), "[SOUTH]" = list( 0, 2),  "[WEST]" = list(0, 2)),
		slot_wear_mask_str = list("[NORTH]" = list(0, 2), "[EAST]" = list(0, 2), "[SOUTH]" = list( 0, 2),  "[WEST]" = list(0, 2)),
		slot_head_str =      list("[NORTH]" = list(0, 2), "[EAST]" = list(0, 2), "[SOUTH]" = list( 0, 2),  "[WEST]" = list(0, 2))
	)
	. = ..()

/decl/bodytype/feline/get_default_grooming_results(obj/item/organ/external/limb, obj/item/grooming/tool)
	if(tool?.grooming_flags & GROOMABLE_BRUSH)
		return list(
			"success"    = GROOMING_RESULT_SUCCESS,
			"descriptor" = "[limb.name] fur"
		)
	return ..()

/obj/item/organ/external/tail/cat
	tail_icon  = 'mods/species/bayliens/tajaran/icons/tail.dmi'
	tail_blend = ICON_MULTIPLY
	tail_animation_states = 1
