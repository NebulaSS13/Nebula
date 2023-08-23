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
	mob_overlay_layer = HO_FACEMASK_LAYER

/datum/inventory_slot/mask/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop?.flags_inv & BLOCK_ALL_HAIR)
		user.update_hair(0)
		user.update_equipment_overlay(slot_l_ear_str, FALSE)
		user.update_equipment_overlay(slot_r_ear_str, FALSE)
	..()

/datum/inventory_slot/mask/equipped(mob/living/user, obj/item/prop, redraw_mob, delete_old_item)
	. = ..()
	if(!_holding || !(_holding.item_flags & ITEM_FLAG_AIRTIGHT))
		user.set_internals(null)

/datum/inventory_slot/mask/unequipped(mob/living/user, obj/item/prop, redraw_mob)
	. = ..()
	if(!_holding || !(_holding.item_flags & ITEM_FLAG_AIRTIGHT))
		user.set_internals(null)

/datum/inventory_slot/mask/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDEMASK))
		if(user == owner)
			return "You are wearing [_holding.get_examine_line()] on your face."
		return "[pronouns.He] [pronouns.is] wearing [_holding.get_examine_line()] on [pronouns.his] face."
