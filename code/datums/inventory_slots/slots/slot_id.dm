/datum/inventory_slot/id
	slot_name = "ID"
	slot_state = "id"
	ui_loc = ui_id
	slot_id = slot_wear_id_str
	requires_slot_flags = SLOT_ID

/datum/inventory_slot/id/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_wear_id(redraw_mob)

/datum/inventory_slot/id/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning, var/ignore_equipped)
	. = ..()
	if(.)
		// If they have a uniform slot, they need a uniform to wear an ID card.
		var/datum/inventory_slot/check_slot = user.get_inventory_slot_datum(slot_w_uniform_str)
		if(check_slot && !check_slot.get_equipped_item())
			if(!disable_warning)
				to_chat(user, SPAN_WARNING("You need to be wearing something on your body before you can wear \the [prop]."))
			return FALSE
