/datum/inventory_slot/gripper
	var/hand_sort_priority = 1
	var/can_use_held_item = TRUE
	var/dexterity = DEXTERITY_FULL
	var/covering_slot_flags

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

// Hand subtypes below
/datum/inventory_slot/gripper/mouth
	slot_name = "Mouth"
	slot_id = BP_MOUTH
	requires_organ_tag = BP_HEAD
	can_use_held_item = FALSE
	overlay_slot = BP_MOUTH
	ui_label = "M"
	hand_sort_priority = 3

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
		if(istype(prop, /obj/item/chems/food))
			var/obj/item/chems/food/food = prop
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
