/datum/inventory_slot/gripper/midlimb
	slot_name = "Midlimb"
	slot_id = BP_M_HAND
	requires_organ_tag = BP_M_HAND
	ui_label = "M"
	ui_loc = "CENTER,BOTTOM+1:14"
	covering_slot_flags = SLOT_HAND_LEFT|SLOT_HAND_RIGHT // todo: generalize?

/obj/item/organ/external/hand/insectoid/midlimb
	name = "central grasper"
	joint = "central wrist"
	organ_tag = BP_M_HAND
	parent_organ = BP_CHEST
	amputation_point = "central wrist"
	icon_position = 0
	encased = "carapace"
	gripper_type = /datum/inventory_slot/gripper/midlimb

/datum/inventory_slot/gripper/upper_left_hand
	slot_name = "Left Upper Hand"
	slot_id = BP_L_HAND_UPPER
	requires_organ_tag = BP_L_HAND_UPPER
	ui_label = "UL"
	hand_sort_priority = 2
	covering_slot_flags = SLOT_HAND_LEFT

/obj/item/organ/external/hand/insectoid/upper
	name = "left raptorial"
	joint = "upper left wrist"
	amputation_point = "upper left shoulder"
	organ_tag = BP_L_HAND_UPPER
	parent_organ = BP_CHEST
	gripper_type = /datum/inventory_slot/gripper/upper_left_hand

/obj/item/organ/external/hand/insectoid/upper/get_manual_dexterity()
	return (..() & ~(DEXTERITY_WEAPONS|DEXTERITY_COMPLEX_TOOLS))

/datum/inventory_slot/gripper/upper_right_hand
	slot_name = "Right Upper Hand"
	slot_id = BP_R_HAND_UPPER
	requires_organ_tag = BP_R_HAND_UPPER
	ui_label = "UR"
	hand_sort_priority = 2
	covering_slot_flags = SLOT_HAND_RIGHT

/obj/item/organ/external/hand/right/insectoid/upper
	name = "right raptorial"
	joint = "upper right wrist"
	amputation_point = "upper right shoulder"
	organ_tag = BP_R_HAND_UPPER
	parent_organ = BP_CHEST
	gripper_type = /datum/inventory_slot/gripper/upper_right_hand

/obj/item/organ/external/hand/right/insectoid/upper/get_manual_dexterity()
	return (..() & ~(DEXTERITY_WEAPONS|DEXTERITY_COMPLEX_TOOLS))

/obj/item/organ/internal/egg_sac/insectoid
	name = "gyne egg-sac"
	action_button_name = "Produce Egg"
	organ_tag = BP_EGG
	var/egg_metabolic_cost = 100

/obj/item/organ/internal/egg_sac/insectoid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "egg-on"
		action.button?.update_icon()

/obj/item/organ/internal/egg_sac/insectoid/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/H = user
	if(.)
		if(H.incapacitated())
			to_chat(H, SPAN_WARNING("You can't produce eggs in your current state."))
			return
		if(H.nutrition < egg_metabolic_cost)
			to_chat(H, SPAN_WARNING("You are too ravenously hungry to produce more eggs."))
			return
		if(do_after(H, 5 SECONDS, H, FALSE))
			H.adjust_nutrition(-1 * egg_metabolic_cost)
			H.visible_message(SPAN_NOTICE("\icon[H] [H] carelessly deposits an egg on \the [get_turf(src)]."))
			var/obj/structure/insectoid_egg/egg = new(get_turf(H)) // splorp
			egg.lineage = H.dna.lineage

/obj/item/organ/external/foot/insectoid/mantid
	name = "left tail tip"

/obj/item/organ/external/foot/right/insectoid/mantid
	name = "right tail tip"

/obj/item/organ/external/leg/insectoid/mantid
	name = "left tail side"

/obj/item/organ/external/leg/right/insectoid/mantid
	name = "right tail side"
