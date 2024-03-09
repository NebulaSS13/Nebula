/decl/sprite_accessory_category/frills
	name                 = "Frills"
	base_accessory_type  = /decl/sprite_accessory/frills
	default_accessory    = /decl/sprite_accessory/frills/none
	uid                  = "acc_cat_frills"

/decl/sprite_accessory/frills
	hidden_by_gear_slot  = slot_head_str
	hidden_by_gear_flag  = BLOCK_HEAD_HAIR
	body_parts           = list(BP_HEAD)
	sprite_overlay_layer = FLOAT_LAYER
	is_heritable         = TRUE
	icon                 = 'icons/mob/human_races/species/default_frills.dmi'
	accessory_category   = SAC_FRILLS
	abstract_type        = /decl/sprite_accessory/frills

/decl/sprite_accessory/frills/none
	name                        = "No Frills"
	icon_state                  = "none"
	uid                         = "acc_frills_none"
	bodytypes_allowed           = null
	bodytypes_denied            = null
	species_allowed             = null
	subspecies_allowed          = null
	bodytype_categories_allowed = null
	bodytype_categories_denied  = null
	body_flags_allowed          = null
	body_flags_denied           = null
	draw_accessory              = FALSE
	grooming_flags              = null
