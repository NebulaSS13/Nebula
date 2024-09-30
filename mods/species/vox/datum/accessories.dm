/decl/sprite_accessory/hair/vox
	name = "Long Vox Quills"
	icon = 'mods/species/vox/icons/body/soldier/hair.dmi'
	icon_state = "vox_longquills"
	species_allowed = list(SPECIES_VOX)
	uid = "acc_hair_vox_longquills"

/decl/sprite_accessory/hair/vox/get_accessory_icon(obj/item/organ/external/organ)
	var/decl/bodytype/vox/voxtype = organ.bodytype
	if(istype(voxtype))
		return voxtype.vox_hair_icon
	return ..()

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

/decl/sprite_accessory/marking/vox
	name = "Vox Neck Markings"
	icon_state = "neck_markings"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	icon = 'mods/species/vox/icons/body/soldier/markings.dmi'
	color_blend = ICON_MULTIPLY
	uid = "acc_markings_vox_neck"

/decl/sprite_accessory/marking/vox/get_accessory_icon(obj/item/organ/external/organ)
	var/decl/bodytype/vox/voxtype = organ.bodytype
	if(istype(voxtype))
		return voxtype.vox_marking_icon
	return ..()

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
