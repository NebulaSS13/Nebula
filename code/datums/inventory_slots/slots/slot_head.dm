/datum/inventory_slot/head
	slot_name = "Hat"
	slot_state = "hair"
	ui_loc = ui_head
	slot_id = slot_head_str
	can_be_hidden = TRUE
	requires_organ_tag = BP_HEAD
	covering_flags = SLOT_HEAD
	requires_slot_flags = SLOT_HEAD

/datum/inventory_slot/head/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	if(prop.flags_inv & (HIDEMASK|BLOCK_ALL_HAIR))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.update_hair(0)	//rebuild hair
		user.update_inv_ears(0)
		user.update_inv_wear_mask(0)
	user.update_inv_head(redraw_mob)

/datum/inventory_slot/head/unequipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	. = ..()
	if(. && iscarbon(user))
		var/obj/item/clothing/mask/mask = user.get_equipped_item(slot_wear_mask_str)
		if(!mask || !(mask.item_flags & ITEM_FLAG_AIRTIGHT))
			var/mob/living/carbon/C = user
			C.set_internals(null)

/datum/inventory_slot/head/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		if(user == owner)
			return "You have [_holding.get_examine_line()] on your head."
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] on [pronouns.his] head."
