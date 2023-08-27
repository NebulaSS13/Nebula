//body markings
/decl/sprite_accessory/marking
	icon = 'icons/mob/human_races/species/default_markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD
	abstract_type = /decl/sprite_accessory/marking
	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like IPC optics overlay stuff.
	var/layer_blend = ICON_OVERLAY
	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_CHEST,BP_GROIN,BP_HEAD
	var/draw_target = MARKING_TARGET_SKIN
	var/list/disallows = list() //A list of other marking types to ban from adding when this marking is already added
	var/list/icons = list()
	var/mask_to_bodypart = TRUE

/decl/sprite_accessory/marking/proc/get_cached_marking_icon(var/decl/bodytype/bodytype, var/bodypart, var/color = COLOR_WHITE)
	LAZYINITLIST(icons[bodytype])
	LAZYINITLIST(icons[bodytype][bodypart])
	if(!icons[bodytype][bodypart][color])
		var/icon/marking_icon = icon(icon, icon_state) // make a new one to avoid mutating the base
		if(mask_to_bodypart)
			marking_icon.Blend(get_limb_mask_for(bodytype, bodypart), ICON_MULTIPLY)
		marking_icon.Blend(color, blend)
		icons[bodytype][bodypart][color] = marking_icon
	return icons[bodytype][bodypart][color]

/decl/sprite_accessory/marking/validate()
	. = ..()
	if(!check_state_in_icon(icon_state, icon))
		. += "missing icon state \"[icon_state]\" in [icon]"

/decl/sprite_accessory/marking/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_CHEST)
	uid = "acc_marking_hive"

/decl/sprite_accessory/marking/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_CHEST)
	uid = "acc_marking_nightling"

/decl/sprite_accessory/marking/tat_campbell
	name = "Tattoo (Campbell, R.Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_R_ARM)
	uid = "acc_marking_campbell"

/decl/sprite_accessory/marking/tat_campbell/left
	name = "Tattoo (Campbell, L.Arm)"
	body_parts = list(BP_L_ARM)
	uid = "acc_marking_campbell_leftarm"

/decl/sprite_accessory/marking/tat_tiger1
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tat_tiger"
	body_parts = list(BP_CHEST,BP_GROIN)
	uid = "acc_marking_tiger"

/decl/sprite_accessory/marking/tat_tiger_arm_left
	name = "Tattoo (Tiger Left Arm)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_ARM)
	uid = "acc_marking_tiger_leftarm"

/decl/sprite_accessory/marking/tat_tiger_arm_right
	name = "Tattoo (Tiger Right Arm)"
	icon_state = "tat_tiger"
	body_parts = list(BP_R_ARM)
	uid = "acc_marking_tiger_rightarm"

/decl/sprite_accessory/marking/tat_tiger_leg
	name = "Tattoo (Tiger Left Leg)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_LEG)
	uid = "acc_marking_tiger_leftleg"

/decl/sprite_accessory/marking/tat_tiger_leg/right
	name = "Tattoo (Tiger Right Leg)"
	icon_state = "tat_tiger"
	body_parts = list(BP_R_LEG)
	uid = "acc_marking_tiger_rightleg"

/decl/sprite_accessory/marking/tigerhead
	name = "Tattoo (Tiger Head)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)
	uid = "acc_marking_tiger_head"

/decl/sprite_accessory/marking/tat_bands_body
	name = "Tattoo (Bands Body)"
	icon_state = "bands"
	body_parts = list(BP_CHEST,BP_GROIN)
	uid = "acc_marking_bands"

/decl/sprite_accessory/marking/tat_bands_arm_right
	name = "Tattoo (Bands Right Arm)"
	icon_state = "bands"
	body_parts = list(BP_R_ARM)
	uid = "acc_marking_bands_rightarm"

/decl/sprite_accessory/marking/tat_bands_arm_left
	name = "Tattoo (Bands Left Arm)"
	icon_state = "bands"
	body_parts = list(BP_L_ARM)
	uid = "acc_marking_bands_leftarm"

/decl/sprite_accessory/marking/tat_bands_hand_right
	name = "Tattoo (Bands Right Hand)"
	icon_state = "bands"
	body_parts = list(BP_R_HAND)
	uid = "acc_marking_bands_righthand"

/decl/sprite_accessory/marking/tat_bands_hand_left
	name = "Tattoo (Bands Left Hand)"
	icon_state = "bands"
	body_parts = list(BP_L_HAND)
	uid = "acc_marking_bands_lefthand"

/decl/sprite_accessory/marking/tat_bands_leg_right
	name = "Tattoo (Bands Right Leg)"
	icon_state = "bands"
	body_parts = list(BP_R_LEG)
	uid = "acc_marking_bands_rightleg"

/decl/sprite_accessory/marking/tat_bands_leg_left
	name = "Tattoo (Bands Left Leg)"
	icon_state = "bands"
	body_parts = list(BP_L_LEG)
	uid = "acc_marking_bands_leftleg"
