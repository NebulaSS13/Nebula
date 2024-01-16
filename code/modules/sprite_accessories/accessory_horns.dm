/decl/sprite_accessory_category/horns
	name                = "Horns"
	base_accessory_type = /decl/sprite_accessory/horns
	default_accessory   = /decl/sprite_accessory/horns/none

/decl/sprite_accessory/horns
	hidden_by_gear_slot  = slot_head_str
	hidden_by_gear_flag  = BLOCK_HEAD_HAIR
	body_parts           = list(BP_HEAD)
	sprite_overlay_layer = FLOAT_LAYER
	is_heritable         = TRUE
	icon                 = 'icons/mob/human_races/species/human/horns.dmi'
	accessory_category   = /decl/sprite_accessory_category/horns
	abstract_type        = /decl/sprite_accessory/horns

/decl/sprite_accessory/horns/none
	name       = "No Horns"
	icon_state = "none"
