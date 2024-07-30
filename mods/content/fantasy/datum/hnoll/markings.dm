//Hairstyles
/decl/sprite_accessory/hair/hnoll
	name = "Hnoll Rattail"
	icon_state = "hair_rattail"
	species_allowed = list(SPECIES_HNOLL)
	icon = 'mods/content/fantasy/icons/hnoll/hair.dmi'
	color_blend = ICON_MULTIPLY
	uid = "acc_hair_hnoll_rattail"

/decl/sprite_accessory/hair/hnoll/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/bald)

/decl/sprite_accessory/hair/hnoll/straight
	name = "Hnoll Straight Hair"
	icon_state = "hair_straight"
	uid = "acc_hair_hnoll_straight"

/decl/sprite_accessory/hair/hnoll/clean
	name = "Hnoll Clean"
	icon_state = "hair_clean"
	uid = "acc_hair_hnoll_clean"

/decl/sprite_accessory/hair/hnoll/shaggy
	name = "Hnoll Shaggy"
	icon_state = "hair_shaggy"
	uid = "acc_hair_hnoll_shaggy"

/decl/sprite_accessory/hair/hnoll/mohawk
	name = "Hnoll Mohawk"
	icon_state = "hair_mohawk"
	uid = "acc_hair_hnoll_mohawk"

/decl/sprite_accessory/hair/hnoll/plait
	name = "Hnoll Plait"
	icon_state = "hair_plait"
	uid = "acc_hair_hnoll_plait"

/decl/sprite_accessory/hair/hnoll/long
	name = "Hnoll Long Hair"
	icon_state = "hair_long"
	uid = "acc_hair_hnoll_long"

/decl/sprite_accessory/hair/hnoll/spiky
	name = "Hnoll Spiky"
	icon_state = "hair_spiky"
	uid = "acc_hair_hnoll_spiky"

/decl/sprite_accessory/hair/hnoll/bangs
	name = "Hnoll Bangs"
	icon_state = "hair_bangs"
	uid = "acc_hair_hnoll_bangs"

/decl/sprite_accessory/hair/hnoll/messy
	name = "Hnoll Messy"
	icon_state = "hair_messy"
	uid = "acc_hair_hnoll_messy"

/decl/sprite_accessory/hair/hnoll/braid
	name = "Hnoll Braid"
	icon_state = "hair_tbraid"
	uid = "acc_hair_hnoll_braid"

/decl/sprite_accessory/hair/hnoll/bob
	name = "Hnoll Bob"
	icon_state = "hair_tbob"
	uid = "acc_hair_hnoll_bob"

/decl/sprite_accessory/hair/hnoll/weave
	name = "Hnoll Fingerweave"
	icon_state = "hair_fingerwave"
	uid = "acc_hair_hnoll_weave"

/decl/sprite_accessory/hair/hnoll/sidebraid
	name = "Hnoll Sidebraid"
	icon_state = "hair_sidebraid"
	uid = "acc_hair_hnoll_sidebraid"

/decl/sprite_accessory/hair/hnoll/ribbons
	name = "Hnoll Ribbons"
	icon_state = "hair_ribbons"
	uid = "acc_hair_hnoll_ribbons"

/decl/sprite_accessory/hair/hnoll/combed
	name = "Hnoll Combed"
	icon_state = "hair_combedback"
	uid = "acc_hair_hnoll_combed"

/decl/sprite_accessory/hair/hnoll/tailedbangs
	name = "Hnoll Tailed Bangs"
	icon_state = "hair_tailedbangs"
	uid = "acc_hair_hnoll_tailedbangs"

/decl/sprite_accessory/hair/hnoll/lynx
	name = "Hnoll Lynx"
	icon_state = "hair_lynx"
	uid = "acc_hair_hnoll_lynx"

/decl/sprite_accessory/hair/hnoll/longtail
	name = "Hnoll Long Tail"
	icon_state = "hair_longtail"
	uid = "acc_hair_hnoll_longtail"

/decl/sprite_accessory/hair/hnoll/shy
	name = "Hnoll Shy"
	icon_state = "hair_shy"
	uid = "acc_hair_hnoll_shy"

/decl/sprite_accessory/hair/hnoll/ponytail
	name = "Hnoll Ponytail"
	icon_state = "hair_ponytail"
	uid = "acc_hair_hnoll_ponytail"

/decl/sprite_accessory/hair/hnoll/overeye
	name = "Hnoll Overeye"
	icon_state = "hair_overeye"
	uid = "acc_hair_hnoll_overeye"

/decl/sprite_accessory/hair/hnoll/tough
	name = "Hnoll Tough"
	icon_state = "hair_tough"
	uid = "acc_hair_hnoll_tough"

/decl/sprite_accessory/hair/hnoll/cuttail
	name = "Hnoll Cut Tail"
	icon_state = "hair_cuttail"
	uid = "acc_hair_hnoll_cuttail"

/decl/sprite_accessory/hair/hnoll/dreadlocks
	name = "Hnoll Dreadlocks"
	icon_state = "hair_dreadlocks"
	uid = "acc_hair_hnoll_deadlocks"

/decl/sprite_accessory/facial_hair/hnoll
	name = "Hnoll Sideburns"
	icon_state = "facial_sideburns"
	species_allowed = list(SPECIES_HNOLL)
	icon = 'mods/content/fantasy/icons/hnoll/facial.dmi'
	color_blend = ICON_MULTIPLY
	uid = "acc_fhair_hnoll_sideburns"

/decl/sprite_accessory/facial_hair/hnoll/mutton
	name = "Hnoll Mutton Chops"
	icon_state = "facial_mutton"
	uid = "acc_fhair_hnoll_mutton"

/decl/sprite_accessory/facial_hair/hnoll/pencilstache
	name = "Hnoll Pencil Moustache"
	icon_state = "facial_pencilstache"
	uid = "acc_fhair_hnoll_pencilstache"

/decl/sprite_accessory/facial_hair/hnoll/moustache
	name = "Hnoll Moustache"
	icon_state = "facial_moustache"
	uid = "acc_fhair_hnoll_moustache"

/decl/sprite_accessory/facial_hair/hnoll/goatee
	name = "Hnoll Goatee"
	icon_state = "facial_goatee"
	uid = "acc_fhair_hnoll_goatee"

/decl/sprite_accessory/facial_hair/hnoll/smallstache
	name = "Hnoll Small Moustache"
	icon_state = "facial_smallstache"
	uid = "acc_fhair_hnoll_smallstache"

/decl/sprite_accessory/marking/hnoll
	name = "Hnoll Nose"
	icon_state = "nose"
	icon = 'mods/content/fantasy/icons/hnoll/markings.dmi'
	species_allowed = list(SPECIES_HNOLL)
	body_parts = list(BP_HEAD)
	color_blend = ICON_MULTIPLY
	uid = "acc_marking_hnoll_nose"

/decl/sprite_accessory/marking/hnoll/ears
	name = "Hnoll Wide Ears"
	icon_state = "ears_plain"
	mask_to_bodypart = FALSE
	uid = "acc_marking_hnoll_wideears"

/decl/sprite_accessory/marking/hnoll/ears/wide_inner
	name = "Hnoll Wide Ears Interior"
	icon_state = "ears_plain_inner"
	uid = "acc_marking_hnoll_wideears_inner"

/decl/sprite_accessory/marking/hnoll/ears/wide_tuft
	name = "Hnoll Wide Ears Tuft"
	icon_state = "ears_plain_tuft"
	uid = "acc_marking_hnoll_wideears_tuft"

/decl/sprite_accessory/marking/hnoll/ears/narrow
	name = "Hnoll Narrow Ears"
	icon_state = "ears_narrow"
	uid = "acc_marking_hnoll_narrowears"

/decl/sprite_accessory/marking/hnoll/ears/narrow_inner
	name = "Hnoll Narrow Ears Interior"
	icon_state = "ears_narrow_inner"
	uid = "acc_marking_hnoll_narrowears_inner"

/decl/sprite_accessory/marking/hnoll/ears/narrow_tuft
	name = "Hnoll Narrow Ears Tuft"
	icon_state = "ears_narrow_tuft"
	uid = "acc_marking_hnoll_narrowears_tuft"

/decl/sprite_accessory/marking/hnoll/ears/earrings
	name = "Hnoll Earrings"
	icon_state = "earrings"
	uid = "acc_marking_hnoll_earrings"

/decl/sprite_accessory/marking/hnoll/patches
	name = "Patches (Body)"
	icon_state = "patches"
	body_parts = list(BP_CHEST, BP_GROIN)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_hnoll_patches"

/decl/sprite_accessory/marking/hnoll/patches/left_arm
	name = "Patches (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	uid = "acc_marking_hnoll_patches_leftarm"

/decl/sprite_accessory/marking/hnoll/patches/right_arm
	name = "Patches (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_hnoll_patches_rightarm"

/decl/sprite_accessory/marking/hnoll/patches/left_leg
	name = "Patches (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_hnoll_patches_leftleg"

/decl/sprite_accessory/marking/hnoll/patches/right_leg
	name = "Patches (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_hnoll_patches_rightleg"

/decl/sprite_accessory/marking/hnoll/tiger
	name = "Tiger Stripes (Head)"
	icon_state = "tiger"
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_hnoll_tiger_head"

/decl/sprite_accessory/marking/hnoll/tiger/body
	name = "Tiger Stripes (Body)"
	body_parts = list(BP_CHEST, BP_GROIN)
	uid = "acc_marking_hnoll_tiger_body"

/decl/sprite_accessory/marking/hnoll/tiger/left_arm
	name = "Tiger Stripes (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	uid = "acc_marking_hnoll_tiger_leftarm"

/decl/sprite_accessory/marking/hnoll/tiger/right_arm
	name = "Tiger Stripes (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_hnoll_tiger_rightarm"

/decl/sprite_accessory/marking/hnoll/tiger/left_leg
	name = "Tiger Stripes (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_hnoll_tiger_leftleg"

/decl/sprite_accessory/marking/hnoll/tiger/right_leg
	name = "Tiger Stripes (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_hnoll_tiger_rightleg"

/decl/sprite_accessory/marking/hnoll/spots
	name = "Spots (Head)"
	icon_state = "spots"
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_hnoll_spots_head"

/decl/sprite_accessory/marking/hnoll/spots/body
	name = "Spots (Body)"
	body_parts = list(BP_CHEST, BP_GROIN)
	uid = "acc_marking_hnoll_spots_body"

/decl/sprite_accessory/marking/hnoll/spots/left_arm
	name = "Spots (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	uid = "acc_marking_hnoll_spots_leftarm"

/decl/sprite_accessory/marking/hnoll/spots/right_arm
	name = "Spots (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_hnoll_spots_rightarm"

/decl/sprite_accessory/marking/hnoll/spots/left_leg
	name = "Spots (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_hnoll_spots_leftleg"

/decl/sprite_accessory/marking/hnoll/spots/right_leg
	name = "Spots (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_hnoll_spots_rightleg"

/decl/sprite_accessory/marking/hnoll/pawsocks
	name = "Pawsocks (Left Arm)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_hnoll_pawsocks_leftarm"

/decl/sprite_accessory/marking/hnoll/pawsocks/right_arm
	name = "Pawsocks (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_hnoll_pawsocks_rightarm"

/decl/sprite_accessory/marking/hnoll/pawsocks/left_leg
	name = "Pawsocks (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)
	uid = "acc_marking_hnoll_pawsocks_leftleg"

/decl/sprite_accessory/marking/hnoll/pawsocks/right_leg
	name = "Pawsocks (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)
	uid = "acc_marking_hnoll_pawsocks_rightleg"

/decl/sprite_accessory/marking/hnoll/belly
	name = "Belly"
	icon_state = "belly"
	body_parts = list(BP_CHEST, BP_GROIN)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_hnoll_belly"
