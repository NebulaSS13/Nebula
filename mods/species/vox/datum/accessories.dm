/decl/sprite_accessory/hair/vox
	name = "Long Vox Quills"
	icon = 'mods/species/vox/icons/body/soldier/hair.dmi'
	icon_state = "vox_longquills"
	species_allowed = list(SPECIES_VOX)
	body_flags_allowed = BODY_EQUIP_FLAG_VOX
	bodytype_categories_allowed = list(BODYTYPE_VOX)
	uid = "acc_hair_vox_longquills"

/decl/sprite_accessory/hair/vox/short
	name = "Short Vox Quills"
	icon_state = "vox_shortquills"
	uid = "acc_hair_vox_shortquills"

/decl/sprite_accessory/hair/vox/mohawk
	name = "Vox Mohawk"
	icon_state = "vox_mohawk"
	uid = "acc_hair_vox_mohawk"

/decl/sprite_accessory/hair/vox/stubble
	name = "Vox Stubble"
	icon_state = "vox_stubble"
	uid = "acc_hair_vox_stubble"

/decl/sprite_accessory/hair/vox/servitor
	icon = 'mods/species/vox/icons/body/servitor/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_hair_vox_longquills_servitor"

/decl/sprite_accessory/hair/vox/short/servitor
	icon = 'mods/species/vox/icons/body/servitor/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_hair_vox_shortquills_servitor"

/decl/sprite_accessory/hair/vox/mohawk/servitor
	icon = 'mods/species/vox/icons/body/servitor/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_hair_vox_mohawk_servitor"

/decl/sprite_accessory/hair/vox/stubble/servitor
	icon = 'mods/species/vox/icons/body/servitor/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_hair_vox_stubble_servitor"

/decl/sprite_accessory/hair/vox/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_hair_vox_longquills_clockvox"

/decl/sprite_accessory/hair/vox/short/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_hair_vox_shortquills_clockvox"

/decl/sprite_accessory/hair/vox/mohawk/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_hair_vox_mohawk_clockvox"

/decl/sprite_accessory/hair/vox/stubble/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/hair.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_hair_vox_stubble_clockvox"

/decl/sprite_accessory/marking/vox
	name = "Vox Neck Markings"
	icon_state = "neck_markings"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	body_flags_allowed = BODY_EQUIP_FLAG_VOX
	bodytype_categories_allowed = list(BODYTYPE_VOX)
	icon = 'mods/species/vox/icons/body/soldier/markings.dmi'
	color_blend = ICON_MULTIPLY
	uid = "acc_markings_vox_neck"

/decl/sprite_accessory/marking/vox/claws
	name = "Vox Claws"
	icon_state = "claws"
	body_parts = list(BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_CHEST)
	uid = "acc_markings_vox_claws"

/decl/sprite_accessory/marking/vox/beak
	name = "Vox Beak"
	icon_state = "beak"
	uid = "acc_markings_vox_beak"

/decl/sprite_accessory/marking/vox/scutes
	name = "Vox Scutes"
	icon_state = "scutes"
	body_parts = list(BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	uid = "acc_markings_vox_scutes"

/decl/sprite_accessory/marking/vox/arm_markings
	name = "Vox Arm Markings (Left)"
	icon_state = "arm_markings"
	body_parts = list(BP_L_ARM)
	uid = "acc_markings_vox_leftarm"

/decl/sprite_accessory/marking/vox/arm_markings/right
	name = "Vox Arm Markings (Right)"
	body_parts = list(BP_R_ARM)
	uid = "acc_markings_vox_rightarm"

/decl/sprite_accessory/marking/vox/crest
	name = "Vox Crest Colouration"
	icon_state = "crest"
	uid = "acc_markings_vox_crest"

/decl/sprite_accessory/marking/vox/servitor
	icon = 'mods/species/vox/icons/body/servitor/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_markings_vox_neck_servitor"

/decl/sprite_accessory/marking/vox/claws/servitor
	icon = 'mods/species/vox/icons/body/servitor/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_markings_vox_claws_servitor"

/decl/sprite_accessory/marking/vox/beak/servitor
	icon = 'mods/species/vox/icons/body/servitor/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_markings_vox_beak_servitor"

/decl/sprite_accessory/marking/vox/scutes/servitor
	icon = 'mods/species/vox/icons/body/servitor/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_markings_vox_scutes_servitor"

/decl/sprite_accessory/marking/vox/arm_markings/servitor
	icon = 'mods/species/vox/icons/body/servitor/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_markings_vox_leftarm_servitor"

/decl/sprite_accessory/marking/vox/arm_markings/right/servitor
	icon = 'mods/species/vox/icons/body/servitor/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_markings_vox_rightarm_servitor"

/decl/sprite_accessory/marking/vox/crest/servitor
	icon = 'mods/species/vox/icons/body/servitor/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_HUMANOID)
	uid = "acc_markings_vox_crest_servitor"

/decl/sprite_accessory/marking/vox/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_markings_vox_neck_clockvox"

/decl/sprite_accessory/marking/vox/claws/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_markings_vox_claws_clockvox"

/decl/sprite_accessory/marking/vox/beak/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_markings_vox_beak_clockvox"

/decl/sprite_accessory/marking/vox/scutes/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_markings_vox_scutes_clockvox"

/decl/sprite_accessory/marking/vox/arm_markings/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_markings_vox_leftarm_clockvox"

/decl/sprite_accessory/marking/vox/arm_markings/right/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_markings_vox_rightarm_clockvox"

/decl/sprite_accessory/marking/vox/crest/stanchion
	icon = 'mods/species/vox/icons/body/stanchion/markings.dmi'
	bodytype_categories_allowed = list(BODYTYPE_VOX_LARGE)
	uid = "acc_markings_vox_crest_clockvox"
