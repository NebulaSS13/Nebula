/datum/inventory_slot/belt
	slot_name = "Belt"
	slot_state = "belt"
	slot_id = slot_belt_str
	ui_loc = ui_belt
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_LOWER_BODY

/datum/inventory_slot/belt/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_belt(redraw_mob)

/datum/inventory_slot/belt/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/slot, var/disable_warning, var/force)
	. = ..()
	if(.)
		if(prop.item_flags & ITEM_FLAG_IS_BELT)
			return TRUE
		// If they have a uniform slot, they need a uniform to wear a belt.
		var/datum/inventory_slot/check_slot = user.get_inventory_slot_datum(slot_w_uniform_str)
		if(check_slot && !check_slot.get_equipped_item())
			if(!disable_warning)
				to_chat(user, SPAN_WARNING("You need a uniform before you can wear \the [prop]."))
			return FALSE
		return TRUE

/datum/inventory_slot/belt/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] about [pronouns.his] waist."
