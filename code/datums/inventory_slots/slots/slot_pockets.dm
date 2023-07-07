/datum/inventory_slot/pocket
	slot_name = "Left Pocket"
	slot_state = "pocket"
	ui_loc = ui_storage1
	slot_id = slot_l_store_str
	skip_on_inventory_display = TRUE
	skip_on_strip_display = TRUE
	requires_organ_tag = BP_CHEST
	requires_slot_flags = SLOT_POCKET

/datum/inventory_slot/pocket/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_pockets(redraw_mob)

/datum/inventory_slot/pocket/prop_can_fit_in_slot(var/obj/item/prop)
	return ..() || prop.w_class <= ITEM_SIZE_SMALL

/datum/inventory_slot/pocket/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning, var/ignore_equipped)
	. = ..()
	if(.)
		// If they have a uniform slot, they need a uniform to have pockets.
		var/datum/inventory_slot/check_slot = user.get_inventory_slot_datum(slot_w_uniform_str)
		if(check_slot && !check_slot.get_equipped_item())
			if(!disable_warning)
				to_chat(user, SPAN_WARNING("You need to be wearing something before you can put \the [prop] in your pocket."))
			return FALSE
		return prop.get_storage_cost() < ITEM_SIZE_NO_CONTAINER

/datum/inventory_slot/pocket/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	return

/datum/inventory_slot/pocket/right
	slot_name = "Right Pocket"
	ui_loc = ui_storage2
	slot_id = slot_r_store_str
