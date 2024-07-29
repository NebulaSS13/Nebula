/datum/inventory_slot/gripper/mouth
	slot_name = "Mouth"
	slot_id = BP_MOUTH
	requires_organ_tag = BP_HEAD
	can_use_held_item = FALSE
	overlay_slot = BP_MOUTH
	ui_label = "M"
	hand_sort_priority = 3
	dexterity = DEXTERITY_SIMPLE_MACHINES | DEXTERITY_GRAPPLE | DEXTERITY_HOLD_ITEM | DEXTERITY_EQUIP_ITEM | DEXTERITY_KEYBOARDS | DEXTERITY_TOUCHSCREENS

/datum/inventory_slot/gripper/mouth/simple
	requires_organ_tag = null

/datum/inventory_slot/gripper/mouth/can_equip_to_slot(mob/user, obj/item/prop, disable_warning, ignore_equipped)
	. = ..() && prop.w_class <= user.can_pull_size

// Mouths are used by diona nymphs and Ascent babies to eat stuff, not just hold stuff in the mouth.
/datum/inventory_slot/gripper/mouth/nymph
	requires_organ_tag = null

/datum/inventory_slot/gripper/mouth/nymph/equipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE, var/delete_old_item = TRUE)
	. = ..()
	if(.)

		// This means critters can hoover up beakers as a kind of impromptu chem disposal
		// technique, so long as they're okay with the reagents reacting inside them.
		if(prop.reagents?.total_volume)
			prop.reagents.trans_to_mob(src, prop.reagents.total_volume, CHEM_INGEST)

		// It also means they can do the old school cartoon schtick of eating
		// an entire sandwich and spitting up an empty plate. Ptooie.
		if(istype(prop, /obj/item/food))
			var/obj/item/food/food = prop
			var/trash = food.trash
			_holding = null
			qdel(prop)
			if(trash)
				equipped(user, new trash(user))

/datum/inventory_slot/gripper/left_hand
	slot_name = "Left Hand"
	slot_id = BP_L_HAND
	requires_organ_tag = BP_L_HAND
	overlay_slot = BP_L_HAND
	ui_label = "L"
	covering_slot_flags = SLOT_HAND_LEFT

/datum/inventory_slot/gripper/right_hand
	slot_name = "Right Hand"
	slot_id = BP_R_HAND
	requires_organ_tag = BP_R_HAND
	overlay_slot = BP_R_HAND
	ui_label = "R"
	covering_slot_flags = SLOT_HAND_RIGHT

/datum/inventory_slot/gripper/midlimb
	slot_name = "Midlimb"
	slot_id = BP_M_HAND
	requires_organ_tag = BP_M_HAND
	ui_label = "M"
	ui_loc = "CENTER,BOTTOM+1:14"
	covering_slot_flags = SLOT_HAND_LEFT|SLOT_HAND_RIGHT // todo: generalize?

/datum/inventory_slot/gripper/upper_left_hand
	slot_name = "Left Upper Hand"
	slot_id = BP_L_HAND_UPPER
	requires_organ_tag = BP_L_HAND_UPPER
	ui_label = "UL"
	hand_sort_priority = 2
	covering_slot_flags = SLOT_HAND_LEFT

/datum/inventory_slot/gripper/upper_right_hand
	slot_name = "Right Upper Hand"
	slot_id = BP_R_HAND_UPPER
	requires_organ_tag = BP_R_HAND_UPPER
	ui_label = "UR"
	hand_sort_priority = 2
	covering_slot_flags = SLOT_HAND_RIGHT
