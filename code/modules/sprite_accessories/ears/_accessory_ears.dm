/decl/sprite_accessory_category/ears
	name                 = "Ears"
	base_accessory_type  = /decl/sprite_accessory/ears
	default_accessory    = /decl/sprite_accessory/ears/none
	uid                  = "acc_cat_ears"

/decl/sprite_accessory/ears
	hidden_by_gear_slot  = slot_head_str
	hidden_by_gear_flag  = BLOCK_HEAD_HAIR
	body_parts           = list(BP_HEAD)
	sprite_overlay_layer = FLOAT_LAYER
	is_heritable         = TRUE
	icon                 = 'icons/mob/human_races/species/default_ears.dmi'
	accessory_category   = SAC_EARS
	abstract_type        = /decl/sprite_accessory/ears
	color_blend          = ICON_MULTIPLY

/decl/sprite_accessory/ears/none
	name                        = "Default Ears"
	icon_state                  = "none"
	uid                         = "acc_ears_none"
	bodytypes_allowed           = null
	bodytypes_denied            = null
	species_allowed             = null
	subspecies_allowed          = null
	bodytype_categories_allowed = null
	bodytype_categories_denied  = null
	body_flags_allowed          = null
	body_flags_denied           = null
	grooming_flags              = null
	draw_accessory              = FALSE

/*
// Leaving this in for reference.
/decl/sprite_accessory/ears/debug
	name = "Debug Two-Tone Ears"
	uid = "acc_ears_debug"
	icon_state = "debug"
	accessory_metadata_types = list(SAM_COLOR, SAM_COLOR_INNER)
*/