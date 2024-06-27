/decl/sprite_accessory_category/markings
	name                  = "Markings"
	single_selection      = FALSE
	base_accessory_type   = /decl/sprite_accessory/marking
	uid                   = "acc_cat_markings"
	always_apply_defaults = TRUE
	clear_in_pref_apply   = TRUE

/decl/sprite_accessory/marking
	icon                  = 'icons/mob/human_races/species/default_markings.dmi'
	abstract_type         = /decl/sprite_accessory/marking
	mask_to_bodypart      = TRUE
	accessory_category    = SAC_MARKINGS

/decl/sprite_accessory/marking/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_body()

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
