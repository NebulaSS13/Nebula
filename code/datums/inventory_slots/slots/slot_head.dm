/datum/inventory_slot/head
	slot_name = "Hat"
	slot_state = "hair"
	ui_loc = ui_head
	slot_id = slot_head_str
	can_be_hidden = TRUE
	requires_organ_tag = BP_HEAD
	covering_flags = SLOT_HEAD
	requires_slot_flags = SLOT_HEAD
	mob_overlay_layer = HO_HEAD_LAYER
	quick_equip_priority = 9
	fluid_height = FLUID_OVER_MOB_HEAD

/datum/inventory_slot/head/simple
	requires_organ_tag = null
	can_be_hidden = FALSE
	ui_loc = "LEFT+1:16,BOTTOM:5"

/datum/inventory_slot/head/update_mob_equipment_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop?.flags_inv & (HIDEMASK|BLOCK_ALL_HAIR))
		user.update_hair(FALSE)
		user.update_equipment_overlay(slot_l_ear_str, FALSE)
		user.update_equipment_overlay(slot_r_ear_str, FALSE)
		user.update_equipment_overlay(slot_wear_mask_str, FALSE)
	..()

/datum/inventory_slot/head/unequipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	. = ..()
	if(. && istype(user))
		var/obj/item/clothing/mask/mask = user.get_equipped_item(slot_wear_mask_str)
		if(!mask || !(mask.item_flags & ITEM_FLAG_AIRTIGHT))
			user.set_internals(null)

/datum/inventory_slot/head/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		if(user == owner)
			return "You have [_holding.get_examine_line()] on your head."
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] on [pronouns.his] head."
