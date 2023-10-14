/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!usr.canClick() || usr.incapacitated())
		return TRUE

	if(name == "swap" || name == "hand")
		usr.swap_hand()
	else if(name in usr.get_held_item_slots())
		if(name == usr.get_active_held_item_slot())
			usr.attack_empty_hand()
		else
			usr.select_held_item_slot(name)
	else if(usr.attack_ui(slot_id))
		usr.update_inhand_overlays(FALSE)

	return TRUE
