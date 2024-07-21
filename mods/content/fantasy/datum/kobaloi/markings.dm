/obj/item/organ/external/tail/kobaloi
	tail_icon        = 'mods/content/fantasy/icons/kobaloi/body.dmi'
	tail_blend       = ICON_MULTIPLY

/decl/sprite_accessory/marking/kobaloi
	abstract_type    = /decl/sprite_accessory/marking/kobaloi
	icon             = 'mods/content/fantasy/icons/kobaloi/markings.dmi'
	color_blend      = ICON_MULTIPLY
	species_allowed  = list(SPECIES_KOBALOI)
	body_parts       = list(BP_HEAD)
	mask_to_bodypart = FALSE

/decl/sprite_accessory/marking/kobaloi/left_ear
	name             = "Left Ear"
	icon_state       = "left_ear"
	uid              = "acc_kobaloi_ear_left"

/decl/sprite_accessory/marking/kobaloi/right_ear
	name             = "Right Ear"
	icon_state       = "right_ear"
	uid              = "acc_kobaloi_ear_right"

/decl/sprite_accessory/marking/kobaloi/left_ear_floopy
	name             = "Floppy Left Ear"
	icon_state       = "left_ear_floopy"
	uid              = "acc_kobaloi_ear_left_floopy"

/decl/sprite_accessory/marking/kobaloi/right_ear_floopy
	name             = "Floppy Right Ear"
	icon_state       = "right_ear_floopy"
	uid              = "acc_kobaloi_ear_right_floopy"

/decl/sprite_accessory/marking/kobaloi/left_ear_stub
	name             = "Left Ear Stub"
	icon_state       = "left_ear_stub"
	uid              = "acc_kobaloi_ear_stub_left"

/decl/sprite_accessory/marking/kobaloi/right_ear_stub
	name             = "Right Ear Stub"
	icon_state       = "right_ear_stub"
	uid              = "acc_kobaloi_ear_stub_right"

/decl/sprite_accessory/marking/kobaloi/body
	name             = "Mottling"
	icon_state       = "mottling"
	uid              = "acc_kobaloi_mottling"
	mask_to_bodypart = TRUE
	body_parts       = list(BP_CHEST, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT)

/decl/sprite_accessory/marking/kobaloi/body/stripes
	name             = "Stripes"
	icon_state       = "stripes"
	uid              = "acc_kobaloi_stripes"

/decl/sprite_accessory/marking/kobaloi/body/underbelly
	name             = "Underbelly"
	icon_state       = "underbelly"
	uid              = "acc_kobaloi_underbelly"
	body_parts       = list(BP_CHEST, BP_GROIN)

/decl/sprite_accessory/marking/kobaloi/face
	name             = "Muzzle"
	icon_state       = "muzzle"
	uid              = "acc_kobaloi_muzzle"
	mask_to_bodypart = TRUE
	body_parts       = list(BP_HEAD)

/decl/sprite_accessory/marking/kobaloi/face/nose
	name             = "Nose"
	icon_state       = "nose"
	uid              = "acc_kobaloi_nose"

/decl/sprite_accessory/marking/kobaloi/horns
	abstract_type    = /decl/sprite_accessory/marking/kobaloi/horns
	icon             = 'mods/content/fantasy/icons/kobaloi/horns.dmi'

/decl/sprite_accessory/marking/kobaloi/horns/spikes
	name             = "Spikes"
	icon_state       = "spikes"
	uid              = "acc_kobaloi_spikes"

/decl/sprite_accessory/marking/kobaloi/horns/left_horn
	name             = "Left Horn"
	icon_state       = "left_horn"
	uid              = "acc_kobaloi_horn_left"

/decl/sprite_accessory/marking/kobaloi/horns/right_horn
	name             = "Right Horn"
	icon_state       = "right_horn"
	uid              = "acc_kobaloi_horn_right"

/decl/sprite_accessory/marking/kobaloi/horns/left_broken_horn
	name             = "Broken Left Horn"
	icon_state       = "left_broken_horn"
	uid              = "acc_kobaloi_horn_broken_left"

/decl/sprite_accessory/marking/kobaloi/horns/right_broken_horn
	name             = "Broken Right Horn"
	icon_state       = "right_broken_horn"
	uid              = "acc_kobaloi_horn_broken_right"

/decl/sprite_accessory/marking/kobaloi/horns/left_curved_horn
	name             = "Curved Left Horn"
	icon_state       = "left_curved_horn"
	uid              = "acc_kobaloi_horn_curved_left"

/decl/sprite_accessory/marking/kobaloi/horns/right_curved_horn
	name             = "Curved Right Horn"
	icon_state       = "right_curved_horn"
	uid              = "acc_kobaloi_horn_curved_right"

/decl/sprite_accessory/marking/kobaloi/horns/left_antler
	name             = "Left Antler"
	icon_state       = "left_antler"
	uid              = "acc_kobaloi_antler_left"

/decl/sprite_accessory/marking/kobaloi/horns/right_antler
	name             = "Right Antler"
	icon_state       = "right_antler"
	uid              = "acc_kobaloi_antler_right"
