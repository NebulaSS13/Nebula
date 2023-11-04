/datum/inventory_slot/belt
	slot_name = "Belt"
	slot_state = "belt"
	slot_id = slot_belt_str
	ui_loc = ui_belt
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_LOWER_BODY
	mob_overlay_layer = HO_BELT_LAYER
	alt_mob_overlay_layer = HO_BELT_LAYER_ALT
	quick_equip_priority = 4

/datum/inventory_slot/belt/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning, var/ignore_equipped)
	. = ..()
	if(.)
		// Things with this flag can be worn on the belt slot without a uniform.
		if(prop.item_flags & ITEM_FLAG_IS_BELT)
			return TRUE
		// Otherwise, if they have a uniform slot, they need a uniform to wear a belt.
		var/datum/inventory_slot/check_slot = user.get_inventory_slot_datum(slot_w_uniform_str)
		if(!check_slot || check_slot.get_equipped_item())
			return TRUE
		if(!disable_warning)
			to_chat(user, SPAN_WARNING("You need to be wearing something on your body before you can wear \the [prop]."))
		return FALSE

/datum/inventory_slot/belt/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		if(user == owner)
			return "You have [_holding.get_examine_line()] about your waist."
		return "[pronouns.He] [pronouns.has] [_holding.get_examine_line()] about [pronouns.his] waist."
