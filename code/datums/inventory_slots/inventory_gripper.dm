/datum/inventory_slot/gripper
	var/hand_sort_priority = 1
	var/dexterity = DEXTERITY_FULL
	var/covering_slot_flags
	/// If set, use this icon_state for the hand slot overlay; otherwise, use slot_id.
	var/hand_overlay
	quick_equip_priority = null // you quick-equip stuff by holding it in a gripper, so this ought to be skipped
	fluid_height = (FLUID_SHALLOW + FLUID_OVER_MOB_HEAD) / 2 // halfway between waist and top of head, so roughly chest level, reasoning that you can just hold it up out of the water

	// For reference, grippers do not use ui_loc, they have it set dynamically during /datum/hud/proc/rebuild_hands()

/datum/inventory_slot/gripper/proc/get_dexterity(var/silent)
	return dexterity

/datum/inventory_slot/gripper/GetCloneArgs()
	return list(slot_id, ui_loc, overlay_slot, ui_label)

/datum/inventory_slot/gripper/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inhand_overlays(redraw_mob)

/datum/inventory_slot/gripper/equipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE, var/delete_old_item = TRUE)
	. = ..()
	if(.)
		prop.update_held_icon()

/datum/inventory_slot/gripper/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(owner, slot_id)
		if(user == owner)
			return "You are holding [_holding.get_examine_line()] in your [E?.name || lowertext(slot_name)]."
		return "[pronouns.He] [pronouns.is] holding [_holding.get_examine_line()] in [pronouns.his] [E?.name || lowertext(slot_name)]."

/datum/inventory_slot/gripper/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning)
	return ..() && user.check_dexterity(DEXTERITY_EQUIP_ITEM, silent = disable_warning)

// Stub definitions for future work and to pass CI.
/datum/inventory_slot/gripper/robot
	abstract_type = /datum/inventory_slot/gripper/robot

/datum/inventory_slot/gripper/robot/one
	ui_label = "1"

/datum/inventory_slot/gripper/robot/two
	ui_label = "2"

/datum/inventory_slot/gripper/robot/three
	ui_label = "3"
