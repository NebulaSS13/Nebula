/datum/inventory_slot/suit_storage
	slot_name = "Suit Storage"
	slot_state = "suitstore"
	ui_loc = ui_sstore1
	slot_id = slot_s_store_str
	requires_organ_tag = BP_CHEST

/datum/inventory_slot/suit_storage/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_s_store(redraw_mob)

/datum/inventory_slot/suit_storage/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning, var/ignore_equipped)
	. = ..()
	if(.)
		// They need a suit to use suit storage.
		var/datum/inventory_slot/check_slot = user.get_inventory_slot_datum(slot_wear_suit_str)
		var/obj/item/clothing/suit/suit = check_slot?.get_equipped_item()
		if(!check_slot || !istype(suit))
			if(!disable_warning)
				to_chat(user, SPAN_WARNING("You need a suit before you can attach \the [prop]."))
			return FALSE
		if(istype(prop, /obj/item/modular_computer/pda) || istype(prop, /obj/item/pen))
			return TRUE
		return is_type_in_list(prop, suit.allowed)

/datum/inventory_slot/suit_storage/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding && !(hideflags & HIDESUITSTORAGE))
		if(user == owner)
			return "[.]\nYou are carrying [_holding.get_examine_line()] on your [_holding.name]."
		return "[.]\n[pronouns.He] [pronouns.is] carrying [_holding.get_examine_line()] on [pronouns.his] [_holding.name]."
