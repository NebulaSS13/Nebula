/obj/item/helpinghands
	name = "back-mounted arms"
	desc = "A pair of arms with an included harness worn on the back, controlled by a noninvasive spinal prosthesis."
	icon = 'icons/mecha/mech_parts_held.dmi'
	icon_state = "light_arms"
	material = /decl/material/solid/metal/steel
	slot_flags = SLOT_BACK
	var/list/slot_types = list(
		/datum/inventory_slot/gripper/left_hand/no_organ/helping,
		/datum/inventory_slot/gripper/right_hand/no_organ/helping
	)

/obj/item/helpinghands/proc/add_hands(mob/user)
	for (var/gripper_type in slot_types)
		user.add_held_item_slot(new gripper_type)

/obj/item/helpinghands/proc/remove_hands(mob/user)
	for (var/datum/inventory_slot/gripper_type as anything in slot_types)
		user.remove_held_item_slot(initial(gripper_type.slot_id))

/obj/item/helpinghands/equipped(mob/user, slot)
	. = ..()
	if(!user)
		return
	switch(slot)
		if(slot_back_str)
			add_hands(user)
		else
			remove_hands(user)

/obj/item/helpinghands/dropped(mob/user)
	. = ..()
	if(user)
		remove_hands(user)

/datum/inventory_slot/gripper/left_hand/no_organ
	requires_organ_tag = null
/datum/inventory_slot/gripper/right_hand/no_organ
	requires_organ_tag = null

/datum/inventory_slot/gripper/left_hand/no_organ/helping
	slot_id = "helping_hand_l"
	hand_overlay = BP_L_HAND
	hand_sort_priority = 4

/datum/inventory_slot/gripper/right_hand/no_organ/helping
	slot_id = "helping_hand_r"
	hand_overlay = BP_R_HAND
	hand_sort_priority = 5