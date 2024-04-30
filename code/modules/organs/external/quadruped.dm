/obj/item/organ/external/leg/quadruped
	name = "left hindleg"
	joint = "rear left knee"

/obj/item/organ/external/leg/right/quadruped
	name = "right hindleg"
	joint = "rear right knee"

/obj/item/organ/external/foot/quadruped
	name = "left hindpaw"
	joint = "rear left ankle"

/obj/item/organ/external/foot/right/quadruped
	name = "right hindpaw"
	joint = "rear right ankle"

/obj/item/organ/external/arm/quadruped
	name = "left foreleg"
	joint = "front left knee"
	amputation_point = "front left knee"
	tendon_name = "cruciate ligament"
	artery_name = "femoral artery"
	organ_category = ORGAN_CATEGORY_STANCE_ROOT
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE

/obj/item/organ/external/arm/right/quadruped
	name = "right foreleg"
	joint = "front right knee"
	amputation_point = "front right knee"
	tendon_name = "cruciate ligament"
	artery_name = "femoral artery"
	organ_category = ORGAN_CATEGORY_STANCE_ROOT
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE

/obj/item/organ/external/hand/quadruped
	name = "left forepaw"
	joint = "front left ankle"
	amputation_point = "front left ankle"
	tendon_name = "Achilles tendon"
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE
	organ_category = ORGAN_CATEGORY_STANCE
	gripper_type = null

/obj/item/organ/external/hand/right/quadruped
	name = "right forepaw"
	joint = "front right ankle"
	amputation_point = "front right ankle"
	tendon_name = "Achilles tendon"
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE
	organ_category = ORGAN_CATEGORY_STANCE
	gripper_type = null
