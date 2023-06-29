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

/datum/inventory_slot/ear/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_ears(redraw_mob)

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
	return ..() || prop.w_class <= ITEM_SIZE_TINY

/datum/inventory_slot/ear/right
	slot_name = "Right Ear"
	slot_id = slot_r_ear_str
	ui_loc = ui_r_ear
