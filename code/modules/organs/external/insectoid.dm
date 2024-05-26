/obj/item/organ/external/arm/insectoid
	name = "left forelimb"
	amputation_point = "coxa"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/arm/right/insectoid
	name = "right forelimb"
	amputation_point = "coxa"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/leg/insectoid
	encased = "carapace"

/obj/item/organ/external/leg/right/insectoid
	encased = "carapace"

/obj/item/organ/external/foot/insectoid
	encased = "carapace"

/obj/item/organ/external/foot/right/insectoid
	encased = "carapace"

/obj/item/organ/external/hand/insectoid
	name = "left grasper"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/hand/right/insectoid
	name = "right grasper"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/groin/insectoid
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"

/obj/item/organ/external/head/insectoid
	name = "head"
	encased = "carapace"

/obj/item/organ/external/chest/insectoid
	name = "thorax"
	encased = "carapace"

/obj/item/organ/external/hand/insectoid/midlimb
	name = "central grasper"
	joint = "central wrist"
	organ_tag = BP_M_HAND
	parent_organ = BP_CHEST
	amputation_point = "central wrist"
	icon_position = 0
	encased = "carapace"
	gripper_type = /datum/inventory_slot/gripper/midlimb

/obj/item/organ/external/hand/insectoid/upper
	name = "left raptorial"
	joint = "upper left wrist"
	amputation_point = "upper left shoulder"
	organ_tag = BP_L_HAND_UPPER
	parent_organ = BP_CHEST
	gripper_type = /datum/inventory_slot/gripper/upper_left_hand

/obj/item/organ/external/hand/insectoid/upper/get_manual_dexterity()
	return (..() & ~(DEXTERITY_WEAPONS|DEXTERITY_COMPLEX_TOOLS))

/obj/item/organ/external/hand/right/insectoid/upper
	name = "right raptorial"
	joint = "upper right wrist"
	amputation_point = "upper right shoulder"
	organ_tag = BP_R_HAND_UPPER
	parent_organ = BP_CHEST
	gripper_type = /datum/inventory_slot/gripper/upper_right_hand

/obj/item/organ/external/hand/right/insectoid/upper/get_manual_dexterity()
	return (..() & ~(DEXTERITY_WEAPONS|DEXTERITY_COMPLEX_TOOLS))
