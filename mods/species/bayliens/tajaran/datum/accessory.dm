//Hairstyles
/decl/sprite_accessory/hair/taj
	name = "Tajaran Rattail"
	icon_state = "hair_rattail"
	species_allowed = list(SPECIES_TAJARA)
	icon = 'mods/species/bayliens/tajaran/icons/hair.dmi'
	color_blend = ICON_MULTIPLY
	uid = "acc_hair_taj_rattail"

/decl/sprite_accessory/hair/taj/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/bald)

/decl/sprite_accessory/hair/taj/straight
	name = "Tajaran Straight Hair"
	icon_state = "hair_straight"
	uid = "acc_hair_taj_straight"

/decl/sprite_accessory/hair/taj/clean
	name = "Tajaran Clean"
	icon_state = "hair_clean"
	uid = "acc_hair_taj_clean"

/decl/sprite_accessory/hair/taj/shaggy
	name = "Tajaran Shaggy"
	icon_state = "hair_shaggy"
	uid = "acc_hair_taj_shaggy"

/decl/sprite_accessory/hair/taj/mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk"
	uid = "acc_hair_taj_mohawk"

/decl/sprite_accessory/hair/taj/plait
	name = "Tajaran Plait"
	icon_state = "hair_plait"
	uid = "acc_hair_taj_plait"

/decl/sprite_accessory/hair/taj/long
	name = "Tajaran Long Hair"
	icon_state = "hair_long"
	uid = "acc_hair_taj_long"

/decl/sprite_accessory/hair/taj/spiky
	name = "Tajaran Spiky"
	icon_state = "hair_tajspiky"
	uid = "acc_hair_taj_spiky"

/decl/sprite_accessory/hair/taj/bangs
	name = "Tajaran Bangs"
	icon_state = "hair_bangs"
	uid = "acc_hair_taj_bangs"

/decl/sprite_accessory/hair/taj/messy
	name = "Tajaran Messy"
	icon_state = "hair_messy"
	uid = "acc_hair_taj_messy"

/decl/sprite_accessory/hair/taj/braid
	name = "Tajaran Braid"
	icon_state = "hair_tbraid"
	uid = "acc_hair_taj_braid"

/decl/sprite_accessory/hair/taj/bob
	name = "Tajaran Bob"
	icon_state = "hair_tbob"
	uid = "acc_hair_taj_bob"

/decl/sprite_accessory/hair/taj/weave
	name = "Tajaran Fingerweave"
	icon_state = "hair_fingerwave"
	uid = "acc_hair_taj_weave"

/decl/sprite_accessory/hair/taj/sidebraid
	name = "Tajaran Sidebraid"
	icon_state = "hair_sidebraid"
	uid = "acc_hair_taj_sidebraid"

/decl/sprite_accessory/hair/taj/ribbons
	name = "Tajaran Ribbons"
	icon_state = "hair_ribbons"
	uid = "acc_hair_taj_ribbons"

/decl/sprite_accessory/hair/taj/combed
	name = "Tajaran Combed"
	icon_state = "hair_combedback"
	uid = "acc_hair_taj_combed"

/decl/sprite_accessory/hair/taj/tailedbangs
	name = "Tajaran Tailed Bangs"
	icon_state = "hair_tailedbangs"
	uid = "acc_hair_taj_tailedbangs"

/decl/sprite_accessory/hair/taj/lynx
	name = "Tajaran Lynx"
	icon_state = "hair_lynx"
	uid = "acc_hair_taj_lynx"

/decl/sprite_accessory/hair/taj/longtail
	name = "Tajaran Long Tail"
	icon_state = "hair_longtail"
	uid = "acc_hair_taj_longtail"

/decl/sprite_accessory/hair/taj/shy
	name = "Tajaran Shy"
	icon_state = "hair_shy"
	uid = "acc_hair_taj_shy"

/decl/sprite_accessory/hair/taj/ponytail
	name = "Tajaran Ponytail"
	icon_state = "hair_ponytail"
	uid = "acc_hair_taj_ponytail"

/decl/sprite_accessory/hair/taj/overeye
	name = "Tajaran Overeye"
	icon_state = "hair_overeye"
	uid = "acc_hair_taj_overeye"

/decl/sprite_accessory/hair/taj/tough
	name = "Tajaran Tough"
	icon_state = "hair_tough"
	uid = "acc_hair_taj_tough"

/decl/sprite_accessory/hair/taj/cuttail
	name = "Tajaran Cut Tail"
	icon_state = "hair_cuttail"
	uid = "acc_hair_taj_cuttail"

/decl/sprite_accessory/hair/taj/dreadlocks
	name = "Tajaran Dreadlocks"
	icon_state = "hair_dreadlocks"
	uid = "acc_hair_taj_deadlocks"

/decl/sprite_accessory/facial_hair/taj
	name = "Tajaran Sideburns"
	icon_state = "facial_sideburns"
	species_allowed = list(SPECIES_TAJARA)
	icon = 'mods/species/bayliens/tajaran/icons/facial.dmi'
	color_blend = ICON_MULTIPLY
	uid = "acc_fhair_taj_sideburns"

/decl/sprite_accessory/facial_hair/taj/mutton
	name = "Tajaran Mutton Chops"
	icon_state = "facial_mutton"
	uid = "acc_fhair_taj_mutton"

/decl/sprite_accessory/facial_hair/taj/pencilstache
	name = "Tajaran Pencil Moustache"
	icon_state = "facial_pencilstache"
	uid = "acc_fhair_taj_pencilstache"

/decl/sprite_accessory/facial_hair/taj/moustache
	name = "Tajaran Moustache"
	icon_state = "facial_moustache"
	uid = "acc_fhair_taj_moustache"

/decl/sprite_accessory/facial_hair/taj/goatee
	name = "Tajaran Goatee"
	icon_state = "facial_goatee"
	uid = "acc_fhair_taj_goatee"

/decl/sprite_accessory/facial_hair/taj/smallstache
	name = "Tajaran Small Moustache"
	icon_state = "facial_smallstache"
	uid = "acc_fhair_taj_smallstache"

/decl/sprite_accessory/marking/tajaran
	name = "Tajaran Nose"
	icon_state = "nose"
	icon = 'mods/species/bayliens/tajaran/icons/markings.dmi'
	species_allowed = list(SPECIES_TAJARA)
	body_parts = list(BP_HEAD)
	color_blend = ICON_MULTIPLY
	uid = "acc_marking_taj_nose"

/decl/sprite_accessory/marking/tajaran/ears
	name = "Tajaran Wide Ears"
	icon_state = "ears_plain"
	mask_to_bodypart = FALSE
	uid = "acc_marking_taj_wideears"

/decl/sprite_accessory/marking/tajaran/ears/wide_inner
	name = "Tajaran Wide Ears Interior"
	icon_state = "ears_plain_inner"
	uid = "acc_marking_taj_wideears_inner"

/decl/sprite_accessory/marking/tajaran/ears/wide_tuft
	name = "Tajaran Wide Ears Tuft"
	icon_state = "ears_plain_tuft"
	uid = "acc_marking_taj_wideears_tuft"

/decl/sprite_accessory/marking/tajaran/ears/narrow
	name = "Tajaran Narrow Ears"
	icon_state = "ears_narrow"
	uid = "acc_marking_taj_narrowears"

/decl/sprite_accessory/marking/tajaran/ears/narrow_inner
	name = "Tajaran Narrow Ears Interior"
	icon_state = "ears_narrow_inner"
	uid = "acc_marking_taj_narrowears_inner"

/decl/sprite_accessory/marking/tajaran/ears/narrow_tuft
	name = "Tajaran Narrow Ears Tuft"
	icon_state = "ears_narrow_tuft"
	uid = "acc_marking_taj_narrowears_tuft"

/decl/sprite_accessory/marking/tajaran/ears/earrings
	name = "Tajaran Earrings"
	icon_state = "taj_earrings"
	uid = "acc_marking_taj_earrings"

/decl/sprite_accessory/marking/tajaran/patches
	name = "Patches (Body)"
	icon_state = "patches"
	body_parts = list(BP_CHEST, BP_GROIN)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_patches"

/decl/sprite_accessory/marking/tajaran/patches/left_arm
	name = "Patches (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	uid = "acc_marking_taj_patches_leftarm"

/decl/sprite_accessory/marking/tajaran/patches/right_arm
	name = "Patches (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_taj_patches_rightarm"

/decl/sprite_accessory/marking/tajaran/patches/left_leg
	name = "Patches (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_taj_patches_leftleg"

/decl/sprite_accessory/marking/tajaran/patches/right_leg
	name = "Patches (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_taj_patches_rightleg"

/decl/sprite_accessory/marking/tajaran/tiger
	name = "Tiger Stripes (Head)"
	icon_state = "tiger"
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_tiger_head"

/decl/sprite_accessory/marking/tajaran/tiger/body
	name = "Tiger Stripes (Body)"
	body_parts = list(BP_CHEST, BP_GROIN)
	uid = "acc_marking_taj_tiger_body"

/decl/sprite_accessory/marking/tajaran/tiger/left_arm
	name = "Tiger Stripes (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	uid = "acc_marking_taj_tiger_leftarm"

/decl/sprite_accessory/marking/tajaran/tiger/right_arm
	name = "Tiger Stripes (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_taj_tiger_rightarm"

/decl/sprite_accessory/marking/tajaran/tiger/left_leg
	name = "Tiger Stripes (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_taj_tiger_leftleg"

/decl/sprite_accessory/marking/tajaran/tiger/right_leg
	name = "Tiger Stripes (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_taj_tiger_rightleg"

/decl/sprite_accessory/marking/tajaran/spots
	name = "Spots (Head)"
	icon_state = "spots"
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_spots_head"

/decl/sprite_accessory/marking/tajaran/spots/body
	name = "Spots (Body)"
	body_parts = list(BP_CHEST, BP_GROIN)
	uid = "acc_marking_taj_spots_body"

/decl/sprite_accessory/marking/tajaran/spots/left_arm
	name = "Spots (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	uid = "acc_marking_taj_spots_leftarm"

/decl/sprite_accessory/marking/tajaran/spots/right_arm
	name = "Spots (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_taj_spots_rightarm"

/decl/sprite_accessory/marking/tajaran/spots/left_leg
	name = "Spots (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_taj_spots_leftleg"

/decl/sprite_accessory/marking/tajaran/spots/right_leg
	name = "Spots (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_taj_spots_rightleg"

/decl/sprite_accessory/marking/tajaran/pawsocks
	name = "Pawsocks (Left Arm)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_pawsocks_leftarm"

/decl/sprite_accessory/marking/tajaran/pawsocks/right_arm
	name = "Pawsocks (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_taj_pawsocks_rightarm"

/decl/sprite_accessory/marking/tajaran/pawsocks/left_leg
	name = "Pawsocks (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_taj_pawsocks_leftleg"

/decl/sprite_accessory/marking/tajaran/pawsocks/right_leg
	name = "Pawsocks (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_taj_pawsocks_rightleg"

/decl/sprite_accessory/marking/tajaran/belly
	name = "Belly"
	icon_state = "belly"
	body_parts = list(BP_CHEST, BP_GROIN)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_belly"
