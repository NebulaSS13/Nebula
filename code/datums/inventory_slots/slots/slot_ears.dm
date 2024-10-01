/datum/inventory_slot/ear
	slot_name = "Left Ear"
	slot_id = slot_l_ear_str
	slot_state = "ears"
	ui_loc = ui_l_ear
	covering_slots = slot_head_str
	covering_flags = SLOT_EARS
	can_be_hidden = TRUE
	requires_organ_tag = BP_HEAD
	requires_slot_flags = SLOT_EARS
	mob_overlay_layer = HO_L_EAR_LAYER
	quick_equip_priority = 7

/datum/inventory_slot/ear/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	for(var/slot in global.airtight_slots)
		var/obj/item/gear = get_equipped_item(slot)
		if(gear?.flags_inv & BLOCK_ALL_HAIR)
			user.set_current_mob_overlay(mob_overlay_layer, null, redraw_mob)
			return
	..()

/datum/inventory_slot/ear/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEEARS))
		if(user == owner)
			return "You have [_holding.get_examine_line()] on your [lowertext(slot_name)]."
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] on [pronouns.his] [lowertext(slot_name)]."

/datum/inventory_slot/ear/unequipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	. = ..()
	if(.)
		for(var/slot in global.ear_slots)
			if(slot == slot_id)
				continue
			var/datum/inventory_slot/inv_slot = user.get_inventory_slot_datum(slot)
			if(inv_slot?.get_equipped_item() == prop)
				inv_slot.clear_slot()

/datum/inventory_slot/ear/prop_can_fit_in_slot(var/obj/item/prop)
	return ..() || (prop.w_class <= ITEM_SIZE_TINY && !(prop.obj_flags & OBJ_FLAG_NO_STORAGE))

/datum/inventory_slot/ear/right
	slot_name = "Right Ear"
	slot_id = slot_r_ear_str
	ui_loc = ui_r_ear
	mob_overlay_layer = HO_R_EAR_LAYER
	quick_equip_priority = 6
