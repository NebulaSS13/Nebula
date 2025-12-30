//Hairstyles
/decl/sprite_accessory/hair/taj
	name = "Tajaran Rattail"
	icon_state = "hair_rattail_s_noear"
	species_allowed = list(/decl/species/tajaran::uid)
	icon = 'mods/species/tajaran/icons/hair.dmi'
	color_blend = ICON_MULTIPLY
	uid = "acc_hair_taj_rattail"

/decl/sprite_accessory/hair/taj/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/bald)


/decl/sprite_accessory/hair/taj/clean
	name = "Tajaran Clean"
	icon_state = "hair_clean_s_noear"
	uid = "acc_hair_taj_clean"

/decl/sprite_accessory/hair/taj/bangs
	name = "Tajara Bangs"
	icon_state = "hair_bangs_s_noear"
	uid = "acc_hair_taj_bangs"

/decl/sprite_accessory/hair/taj/braid
	name = "Tajara Braid"
	icon_state = "hair_tbraid_s_noear"
	uid = "acc_hair_taj_braid"

/decl/sprite_accessory/hair/taj/shaggy
	name = "Tajara Shaggy"
	icon_state = "hair_shaggy_s_noear"
	uid = "acc_hair_taj_shaggy"

/decl/sprite_accessory/hair/taj/mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk_s_noear"
	uid = "acc_hair_taj_mohawk"

/decl/sprite_accessory/hair/taj/plait
	name = "Tajara Plait"
	icon_state = "hair_plait_s_noear"
	uid = "acc_hair_taj_plait"

/decl/sprite_accessory/hair/taj/straight
	name = "Tajara Straight"
	icon_state = "hair_straight_s_noear"
	uid = "acc_hair_taj_straight"

/decl/sprite_accessory/hair/taj/long
	name = "Tajara Long"
	icon_state = "hair_long_s_noear"
	uid = "acc_hair_taj_long"

/decl/sprite_accessory/hair/taj/spiky
	name = "Tajara Spiky"
	icon_state = "hair_tajspiky_s_noear"
	uid = "acc_hair_taj_spiky"

/decl/sprite_accessory/hair/taj/messy
	name = "Tajara Messy"
	icon_state = "hair_messy_s_noear"
	uid = "acc_hair_taj_messy"

/decl/sprite_accessory/hair/taj/bob
	name = "Tajara Bob"
	icon_state = "hair_tbob_s_noear"
	uid = "acc_hair_taj_bob"

/decl/sprite_accessory/hair/taj/sidebraid
	name = "Tajara Sidebraid"
	icon_state = "hair_sidebraid_s_noear"
	uid = "acc_hair_taj_sidebraid"


/decl/sprite_accessory/hair/taj/ribbons
	name = "Tajara Ribbons"
	icon_state = "hair_ribbons_s_noear"
	uid = "acc_hair_taj_ribbons"

/decl/sprite_accessory/hair/taj/combedback
	name = "Tajara Combedback"
	icon_state = "hair_combedback_s_noear"
	uid = "acc_hair_taj_combedback"

/decl/sprite_accessory/hair/taj/tailedbangs
	name = "Tajara Tailedbangs"
	icon_state = "hair_tailedbangs_s_noear"
	uid = "acc_hair_taj_tailedbangs"

/decl/sprite_accessory/hair/taj/longtail
	name = "Tajara Longtail"
	icon_state = "hair_longtail_s_noear"
	uid = "acc_hair_taj_longtail"

/decl/sprite_accessory/hair/taj/shy
	name = "Tajara Shy"
	icon_state = "hair_shy_s_noear"
	uid = "acc_hair_taj_shy"

/decl/sprite_accessory/hair/taj/ponytail
	name = "Tajara Ponytail"
	icon_state = "hair_ponytail_s_noear"
	uid = "acc_hair_taj_ponytail"

/decl/sprite_accessory/hair/taj/overeye
	name = "Tajara Overeye"
	icon_state = "hair_overeye_s_noear"
	uid = "acc_hair_taj_overeye"

/decl/sprite_accessory/hair/taj/tough
	name = "Tajara Tough"
	icon_state = "hair_tough_s_noear"
	uid = "acc_hair_taj_tough"

/decl/sprite_accessory/hair/taj/cuttail
	name = "Tajara Cuttail"
	icon_state = "hair_cuttail_s_noear"
	uid = "acc_hair_taj_cuttail"

/decl/sprite_accessory/hair/taj/dreadlocks
	name = "Tajara Dreadlocks"
	icon_state = "hair_dreadlocks_s_noear"
	uid = "acc_hair_taj_dreadlocks"

/decl/sprite_accessory/hair/taj/fingerwave
	name = "Tajaran Fingerwave"
	icon_state = "hair_fingerwave_s_noear"
	uid = "acc_hair_taj_fingerwave"

/decl/sprite_accessory/hair/taj/lynx
	name = "Tajaran Lynx"
	icon_state = "hair_lynx_s_noear"
	uid = "acc_hair_taj_lynx"

//Facial hs

/decl/sprite_accessory/facial_hair/taj
	name = "Tajara Sideburns"
	icon_state = "facial_sideburns"
	species_allowed = list(/decl/species/tajaran::uid)
	icon = 'mods/species/tajaran/icons/facial.dmi'
	uid = "acc_fhair_taj_sideburns"

/decl/sprite_accessory/facial_hair/taj/mutton
	name = "Tajara Mutton"
	icon_state = "facial_mutton"
	uid = "acc_fhair_taj_mutton"

/decl/sprite_accessory/facial_hair/taj/pencilstache
	name = "Tajara Pencilstache"
	icon_state = "facial_pencilstache"
	uid = "acc_fhair_taj_pencilstache"

/decl/sprite_accessory/facial_hair/taj/moustache
	name = "Tajara Moustache"
	icon_state = "facial_moustache"
	uid = "acc_fhair_taj_moustache"

/decl/sprite_accessory/facial_hair/taj/goatee
	name = "Tajara Goatee"
	icon_state = "facial_goatee"
	uid = "acc_fhair_taj_goatee"

/decl/sprite_accessory/facial_hair/taj/smallstache
	name = "Tajara Smallsatche"
	icon_state = "facial_smallstache"
	uid = "acc_fhair_taj_smallstache"

//Markings
/decl/sprite_accessory/marking/tajaran
	name = "Tajaran Nose"
	icon_state = "nose"
	icon = 'mods/species/tajaran/icons/markings.dmi'
	species_allowed = list(/decl/species/tajaran::uid)
	body_parts = list(BP_HEAD)
	color_blend = ICON_MULTIPLY
	uid = "acc_marking_taj_nose"

/decl/sprite_accessory/ears/tajaran
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	icon = 'mods/species/tajaran/icons/ears.dmi'
	mask_to_bodypart = FALSE
	uid = "acc_marking_taj_wideears"
	species_allowed = list(/decl/species/tajaran::uid)

/decl/sprite_accessory/ears/tajaran/inner
	name = "Tajaran Ears Interior"
	icon_state = "earsin"
	uid = "acc_marking_taj_wideears_inner"

/decl/sprite_accessory/ears/tajaran/outer
	name = "Tajaran Ears Exterior"
	icon_state = "earsout"
	uid = "acc_marking_taj_wideears_outer"

/decl/sprite_accessory/ears/tajaran/wide_tuft
	name = "Tajaran Ear Tufts"
	icon_state = "earsout_tuft"
	uid = "acc_marking_taj_wideears_tuft"

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

/decl/sprite_accessory/marking/tajaran/patches/head
	name = "Patches (Head)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)
	uid = "acc_marking_taj_patches_head"


/decl/sprite_accessory/marking/tajaran/tiger
	name = "Tiger Stripes (Body)"
	icon_state = "tiger"
	accessory_flags = HAIR_LOSS_VULNERABLE
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

/decl/sprite_accessory/marking/tajaran/tiger/head
	name = "Tiger Stripes (Head)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)
	uid = "acc_marking_taj_tiger_head"

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

/decl/sprite_accessory/marking/tajaran/tuxedo
	name = "Tuxedo (Body, Legs, Feet)"
	icon_state = "tuxedo"
	body_parts = list(BP_CHEST, BP_GROIN, BP_R_LEG, BP_R_FOOT, BP_L_LEG, BP_L_FOOT)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_tuxedo_body"

/decl/sprite_accessory/marking/tajaran/tuxedo/right_arm
	name = "Tuxedo (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)
	uid = "acc_marking_taj_tuxedo_rightarm"

/decl/sprite_accessory/marking/tajaran/tuxedo/left_arm
	name = "Tuxedo (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	uid = "acc_marking_taj_tuxedo_leftarm"

/decl/sprite_accessory/marking/tajaran/belly
	name = "Belly Full (Body)"
	icon_state = "bellyfull"
	body_parts = list(BP_CHEST, BP_GROIN)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_belly"

/decl/sprite_accessory/marking/tajaran/belly/upper
	name = "Belly Upper (Body)"
	icon_state = "crest"
	body_parts = list(BP_CHEST)
	uid = "acc_marking_taj_bellyupper"

/decl/sprite_accessory/marking/tajaran/belly/lower
	name = "Belly Lower (Body)"
	icon_state = "belly"
	uid = "acc_marking_taj_bellylower"

/decl/sprite_accessory/marking/tajaran/backstripe
	name = "Back Stripe (Body)"
	icon_state = "backstripe"
	body_parts = list(BP_CHEST, BP_GROIN)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_backstripe"

/decl/sprite_accessory/marking/tajaran/muzzle
	name = "Muzzle Coloration (Head)"
	icon_state = "muzzle"
	body_parts = list(BP_HEAD)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_muzzle"

/decl/sprite_accessory/marking/tajaran/chin
	name = "Chin Coloration (Head)"
	icon_state = "chin"
	body_parts = list(BP_HEAD)
	accessory_flags = HAIR_LOSS_VULNERABLE
	uid = "acc_marking_taj_chin"