/decl/sprite_accessory_category/horns
	name                 = "Horns"
	base_accessory_type  = /decl/sprite_accessory/horns
	default_accessory    = /decl/sprite_accessory/horns/none
	uid                  = "acc_cat_horns"

/decl/sprite_accessory/horns
	hidden_by_gear_slot  = slot_head_str
	hidden_by_gear_flag  = BLOCK_HEAD_HAIR
	body_parts           = list(BP_HEAD)
	sprite_overlay_layer = FLOAT_LAYER
	is_heritable         = TRUE
	icon                 = 'icons/mob/human_races/species/default_horns.dmi'
	accessory_category   = SAC_HORNS
	abstract_type        = /decl/sprite_accessory/horns
	grooming_flags       = GROOMABLE_FILE

/decl/sprite_accessory/horns/get_grooming_descriptor(grooming_result, obj/item/organ/external/organ, obj/item/grooming/tool)
	return grooming_result == GROOMING_RESULT_PARTIAL ? "nubs" : "horns"

/decl/sprite_accessory/horns/none
	name                        = "No Horns"
	icon_state                  = "none"
	uid                         = "acc_horns_none"
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
