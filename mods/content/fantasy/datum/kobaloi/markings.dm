/obj/item/organ/external/tail/kobaloi
	tail_icon  = 'mods/content/fantasy/icons/kobaloi/body.dmi'
	tail_blend = ICON_MULTIPLY

/decl/sprite_accessory/marking/kobaloi
	abstract_type    = /decl/sprite_accessory/marking/kobaloi
	icon             = 'mods/content/fantasy/icons/kobaloi/markings.dmi'
	color_blend      = ICON_MULTIPLY
	species_allowed  = list(/decl/species/kobaloi::uid)
	body_parts       = list(BP_HEAD)

/decl/sprite_accessory/marking/kobaloi/body
	name             = "Mottling"
	icon_state       = "mottling"
	uid              = "acc_kobaloi_mottling"
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
	body_parts       = list(BP_HEAD)

/decl/sprite_accessory/marking/kobaloi/face/nose
	name             = "Nose"
	icon_state       = "nose"
	uid              = "acc_kobaloi_nose"
