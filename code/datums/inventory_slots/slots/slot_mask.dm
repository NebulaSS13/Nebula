/datum/inventory_slot/mask
	slot_name = "Mask"
	slot_state = "mask"
	ui_loc = ui_mask
	slot_id = slot_wear_mask_str
	covering_slots = slot_head_str
	covering_flags = SLOT_FACE
	requires_organ_tag = BP_HEAD
	requires_slot_flags = SLOT_FACE
	can_be_hidden = TRUE

/datum/inventory_slot/mask/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop.flags_inv & BLOCK_ALL_HAIR)
		user.update_hair(0)
		user.update_inv_ears(0)
	user.update_inv_wear_mask(redraw_mob)

/datum/inventory_slot/mask/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEMASK))
		if(user == owner)
			return "You are wearing [_holding.get_examine_line()] on your face."
		return "[pronouns.He] [pronouns.is] wearing [_holding.get_examine_line()] on [pronouns.his] face."
