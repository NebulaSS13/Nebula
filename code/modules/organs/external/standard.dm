/****************************************************
			   ORGAN DEFINES
****************************************************/

//Make sure that w_class is set as if the parent mob was medium sized! This is because w_class is adjusted automatically for mob_size in New()

/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_CHEST
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_HUGE //Used for dismembering thresholds, in addition to storage. Humans are w_class 6, so it makes sense that chest is w_class 5.
	cavity_max_w_class = ITEM_SIZE_NORMAL
	body_part = SLOT_UPPER_BODY
	amputation_point = "spine"
	joint = "neck"
	parent_organ = null
	encased = "ribcage"
	artery_name = "aorta"
	cavity_name = "thoracic"
	limb_flags = ORGAN_FLAG_HEALS_OVERKILL | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/chest/proc/get_current_skin()
	return

/obj/item/organ/external/get_scan_results()
	. = ..()
	var/obj/item/organ/internal/lungs/L = locate() in src
	if( L && L.is_bruised())
		. += "Lung ruptured"

/obj/item/organ/external/chest/die()
	//Special handling for synthetics
	if(BP_IS_PROSTHETIC(src) || BP_IS_CRYSTAL(src))
		return
	. = ..()

/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	max_damage = 100
	min_broken_damage = 35
	w_class = ITEM_SIZE_LARGE
	cavity_max_w_class = ITEM_SIZE_SMALL
	body_part = SLOT_LOWER_BODY
	parent_organ = BP_CHEST
	amputation_point = "lumbar"
	joint = "hip"
	artery_name = "iliac artery"
	cavity_name = "abdominal"
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/groin/die()
	//Special handling for synthetics
	if(BP_IS_PROSTHETIC(src) || BP_IS_CRYSTAL(src))
		return
	. = ..()

/obj/item/organ/external/arm
	organ_tag = BP_L_ARM
	name = "left arm"
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	body_part = SLOT_ARM_LEFT
	parent_organ = BP_CHEST
	joint = "left elbow"
	amputation_point = "left shoulder"
	tendon_name = "palmaris longus tendon"
	artery_name = "basilic vein"
	arterial_bleed_severity = 0.75
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE

/obj/item/organ/external/arm/right
	organ_tag = BP_R_ARM
	name = "right arm"
	body_part = SLOT_ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	organ_tag = BP_L_LEG
	name = "left leg"
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	body_part = SLOT_LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	tendon_name = "cruciate ligament"
	artery_name = "femoral artery"
	arterial_bleed_severity = 0.75
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE

/obj/item/organ/external/leg/right
	organ_tag = BP_R_LEG
	name = "right leg"
	body_part = SLOT_LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	organ_tag = BP_L_FOOT
	name = "left foot"
	max_damage = 30
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL
	body_part = SLOT_FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	tendon_name = "Achilles tendon"
	arterial_bleed_severity = 0.5
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE

/obj/item/organ/external/foot/right
	organ_tag = BP_R_FOOT
	name = "right foot"
	body_part = SLOT_FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	organ_tag = BP_L_HAND
	name = "left hand"
	icon_position = LEFT
	max_damage = 30
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL
	body_part = SLOT_HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	tendon_name = "carpal ligament"
	arterial_bleed_severity = 0.5
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_FINGERPRINT | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE
	var/gripper_type = /datum/inventory_slot/gripper/left_hand

/obj/item/organ/external/hand/do_install(mob/living/carbon/human/target, affected, in_place, update_icon, detached)
	. = ..()
	if(. && owner && gripper_type)
		owner.add_held_item_slot(new gripper_type)

/obj/item/organ/external/hand/do_uninstall(in_place, detach, ignore_children, update_icon)
	owner?.remove_held_item_slot(organ_tag)
	. = ..()

/obj/item/organ/external/hand/right
	organ_tag = BP_R_HAND
	name = "right hand"
	icon_position = RIGHT
	body_part = SLOT_HAND_RIGHT
	parent_organ = BP_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"
	gripper_type = /datum/inventory_slot/gripper/right_hand
