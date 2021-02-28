//Hairstyles

/datum/sprite_accessory/facial_hair/shaved/New()
	..()
	species_allowed |= SPECIES_TAJARA

/datum/sprite_accessory/hair/shaved/New()
	..()
	species_allowed |= SPECIES_TAJARA

/datum/sprite_accessory/hair/taj
	name = "Tajaran Rattail"
	icon_state = "hair_rattail"
	species_allowed = list(SPECIES_TAJARA)
	icon = 'mods/species/tajaran/icons/hair.dmi'
	blend = ICON_MULTIPLY

/datum/sprite_accessory/hair/taj/straight
	name = "Tajaran Straight Hair"
	icon_state = "hair_straight"

/datum/sprite_accessory/hair/taj/clean
	name = "Tajaran Clean"
	icon_state = "hair_clean"

/datum/sprite_accessory/hair/taj/shaggy
	name = "Tajaran Shaggy"
	icon_state = "hair_shaggy"

/datum/sprite_accessory/hair/taj/mohawk
	name = "Tajaran Mohawk"
	icon_state = "hair_mohawk"

/datum/sprite_accessory/hair/taj/plait
	name = "Tajaran Plait"
	icon_state = "hair_plait"

/datum/sprite_accessory/hair/taj/long
	name = "Tajaran Long Hair"
	icon_state = "hair_long"

/datum/sprite_accessory/hair/taj/spiky
	name = "Tajaran Spiky"
	icon_state = "hair_tajspiky"

/datum/sprite_accessory/hair/taj/bangs
	name = "Tajaran Bangs"
	icon_state = "hair_bangs"

/datum/sprite_accessory/hair/taj/messy
	name = "Tajaran Messy"
	icon_state = "hair_messy"

/datum/sprite_accessory/hair/taj/braid
	name = "Tajaran Braid"
	icon_state = "hair_tbraid"

/datum/sprite_accessory/hair/taj/bob
	name = "Tajaran Bob"
	icon_state = "hair_tbob"

/datum/sprite_accessory/hair/taj/weave
	name = "Tajaran Fingerweave"
	icon_state = "hair_fingerwave"

/datum/sprite_accessory/hair/taj/sidebraid
	name = "Tajaran Sidebraid"
	icon_state = "hair_sidebraid"

/datum/sprite_accessory/hair/taj/ribbons
	name = "Tajaran Ribbons"
	icon_state = "hair_ribbons"

/datum/sprite_accessory/hair/taj/combed
	name = "Tajaran Combed"
	icon_state = "hair_combedback"

/datum/sprite_accessory/hair/taj/tailedbangs
	name = "Tajaran Tailed Bangs"
	icon_state = "hair_tailedbangs"

/datum/sprite_accessory/hair/taj/lynx
	name = "Tajaran Lynx"
	icon_state = "hair_lynx"

/datum/sprite_accessory/hair/taj/longtail
	name = "Tajaran Long Tail"
	icon_state = "hair_longtail"

/datum/sprite_accessory/hair/taj/shy
	name = "Tajaran Shy"
	icon_state = "hair_shy"

/datum/sprite_accessory/hair/taj/ponytail
	name = "Tajaran Ponytail"
	icon_state = "hair_ponytail"

/datum/sprite_accessory/hair/taj/overeye
	name = "Tajaran Overeye"
	icon_state = "hair_overeye"

/datum/sprite_accessory/hair/taj/tough
	name = "Tajaran Tough"
	icon_state = "hair_tough"

/datum/sprite_accessory/hair/taj/cuttail
	name = "Tajaran Cut Tail"
	icon_state = "hair_cuttail"

/datum/sprite_accessory/hair/taj/dreadlocks
	name = "Tajaran Dreadlocks"
	icon_state = "hair_dreadlocks"

/datum/sprite_accessory/facial_hair/taj
	name = "Tajaran Sideburns"
	icon_state = "facial_sideburns"
	species_allowed = list(SPECIES_TAJARA)
	icon = 'mods/species/tajaran/icons/facial.dmi'
	gender = null
	blend = ICON_MULTIPLY

/datum/sprite_accessory/facial_hair/taj/mutton
	name = "Tajaran Mutton Chops"
	icon_state = "facial_mutton"

/datum/sprite_accessory/facial_hair/taj/pencilstache
	name = "Tajaran Pencil Moustache"
	icon_state = "facial_pencilstache"

/datum/sprite_accessory/facial_hair/taj/moustache
	name = "Tajaran Moustache"
	icon_state = "facial_moustache"

/datum/sprite_accessory/facial_hair/taj/goatee
	name = "Tajaran Goatee"
	icon_state = "facial_goatee"

/datum/sprite_accessory/facial_hair/taj/smallstache
	name = "Tajaran Small Moustache"
	icon_state = "facial_smallstache"

/datum/sprite_accessory/skin/tajaran
	name = "Default Tajaran skin"
	icon_state = "default"
	icon = 'mods/species/tajaran/icons/body.dmi'
	species_allowed = list(SPECIES_TAJARA)

/datum/sprite_accessory/marking/tajaran
	name = "Tajaran Wide Ears"
	icon = 'mods/species/tajaran/icons/markings.dmi'
	species_allowed = list(SPECIES_TAJARA)
	body_parts = list(BP_HEAD)
	icon_state = "ears_plain"
	blend = ICON_MULTIPLY

/datum/sprite_accessory/marking/tajaran/nose
	name = "Tajaran Nose"
	icon_state = "nose"

/datum/sprite_accessory/marking/tajaran/wide_ears_inner
	name = "Tajaran Wide Ears Interior"
	icon_state = "ears_plain_inner"

/datum/sprite_accessory/marking/tajaran/wide_ears_tuft
	name = "Tajaran Wide Ears Tuft"
	icon_state = "ears_plain_tuft"

/datum/sprite_accessory/marking/tajaran/narrow_ears
	name = "Tajaran Narrow Ears"
	icon_state = "ears_narrow"

/datum/sprite_accessory/marking/tajaran/narrow_ears_inner
	name = "Tajaran Narrow Ears Interior"
	icon_state = "ears_narrow_inner"

/datum/sprite_accessory/marking/tajaran/narrow_ears_tuft
	name = "Tajaran Narrow Ears Tuft"
	icon_state = "ears_narrow_tuft"

/datum/sprite_accessory/marking/tajaran/earrings
	name = "Tajaran Earrings"
	icon_state = "taj_earrings"

/datum/sprite_accessory/marking/tajaran/patches
	name = "Patches (Body)"
	icon_state = "patches"
	body_parts = list(BP_CHEST, BP_GROIN)
	flags = HAIR_LOSS_VULNERABLE

/datum/sprite_accessory/marking/tajaran/patches/left_arm
	name = "Patches (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)

/datum/sprite_accessory/marking/tajaran/patches/right_arm
	name = "Patches (Right Arm"
	body_parts = list(BP_R_ARM, BP_R_HAND)

/datum/sprite_accessory/marking/tajaran/patches/left_leg
	name = "Patches (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)

/datum/sprite_accessory/marking/tajaran/patches/right_leg
	name = "Patches (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)

/datum/sprite_accessory/marking/tajaran/tiger
	name = "Tiger Stripes (Head)"
	icon_state = "tiger"
	flags = HAIR_LOSS_VULNERABLE

/datum/sprite_accessory/marking/tajaran/tiger/body
	name = "Tiger Stripes (Body)"
	body_parts = list(BP_CHEST, BP_GROIN)

/datum/sprite_accessory/marking/tajaran/tiger/left_arm
	name = "Tiger Stripes (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)

/datum/sprite_accessory/marking/tajaran/tiger/right_arm
	name = "Tiger Stripes (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)

/datum/sprite_accessory/marking/tajaran/tiger/left_leg
	name = "Tiger Stripes (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)

/datum/sprite_accessory/marking/tajaran/tiger/right_leg
	name = "Tiger Stripes (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)

/datum/sprite_accessory/marking/tajaran/spots
	name = "Spots (Head)"
	icon_state = "spots"
	flags = HAIR_LOSS_VULNERABLE

/datum/sprite_accessory/marking/tajaran/spots/body
	name = "Spots (Body)"
	body_parts = list(BP_CHEST, BP_GROIN)

/datum/sprite_accessory/marking/tajaran/spots/left_arm
	name = "Spots (Left Arm)"
	body_parts = list(BP_L_ARM, BP_L_HAND)

/datum/sprite_accessory/marking/tajaran/spots/right_arm
	name = "Spots (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)

/datum/sprite_accessory/marking/tajaran/spots/left_leg
	name = "Spots (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)

/datum/sprite_accessory/marking/tajaran/spots/right_leg
	name = "Spots (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)

/datum/sprite_accessory/marking/tajaran/pawsocks
	name = "Pawsocks (Left Arm)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_ARM, BP_L_HAND)
	flags = HAIR_LOSS_VULNERABLE

/datum/sprite_accessory/marking/tajaran/pawsocks/right_arm
	name = "Pawsocks (Right Arm)"
	body_parts = list(BP_R_ARM, BP_R_HAND)

/datum/sprite_accessory/marking/tajaran/pawsocks/left_leg
	name = "Pawsocks (Left Leg)"
	body_parts = list(BP_L_LEG, BP_L_FOOT)

/datum/sprite_accessory/marking/tajaran/pawsocks/right_leg
	name = "Pawsocks (Right Leg)"
	body_parts = list(BP_R_LEG, BP_R_FOOT)

/datum/sprite_accessory/marking/tajaran/belly
	name = "Belly"
	icon_state = "belly"
	body_parts = list(BP_CHEST, BP_GROIN)
	flags = HAIR_LOSS_VULNERABLE
