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
	name                        = "Standard Ears"
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
	draw_accessory              = FALSE
	grooming_flags              = null

/decl/sprite_accessory/ears/dual_antennae
	name = "Dual Antennae"
	icon_state = "dual_robot_antennae"
	uid = "accessory_ears_dual_antennae"

/decl/sprite_accessory/ears/left_antenna
	name = "Antenna, Left"
	icon_state = "left_robot_antennae"
	uid = "accessory_ears_left_antennae"

/decl/sprite_accessory/ears/right_antenna
	name = "Antenna, Right"
	icon_state = "right_robot_antennae"
	uid = "accessory_ears_right_antennae"

/decl/sprite_accessory/ears/pointed
	name = "Pointed Ears"
	icon_state = "ears_pointy"
	uid = "accessory_ears_pointy"

/decl/sprite_accessory/ears/pointed_long
	name = "Long Pointed Ears"
	icon_state = "ears_pointy_long"
	uid = "accessory_ears_pointy_long"

/decl/sprite_accessory/ears/pointed_down
	name = "Pointed Ears (Downward)"
	icon_state = "ears_pointy_down"
	uid = "accessory_ears_pointy_down"

/decl/sprite_accessory/ears/pointed_long_down
	name = "Long Pointed Ears (Downward)"
	icon_state = "ears_pointy_long_down"
	uid = "accessory_ears_long_down"

/decl/sprite_accessory/ears/elven
	name = "Elven Ears"
	icon_state = "elfs"
	uid = "accessory_ears_elfs"
