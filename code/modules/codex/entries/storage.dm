/obj/item/get_lore_info()
	return desc

/obj/item/get_mechanics_info()
	. = ..()
	var/list/storage_info_list = list()
	if(storage)
		storage_info_list += "Storage items are holdable or wearable objects used for storing items. You can hold an appropriate item in your hand and click on the storage item to put the item inside. You can then take items out by accessing the storage UI. To do this, either hold the storage in your hand and click it with the other, or click+drag the storage item onto yourself (this works if the storage item is not being held too!).<BR>"

		if(storage.can_hold.len)
			storage_info_list += "* It can only hold specific items."

		switch(storage.max_w_class)
			if(ITEM_SIZE_TINY)
				storage_info_list += "* It can only hold tiny sized items."
			if(ITEM_SIZE_SMALL)
				storage_info_list += "* It can hold small sized items, and tiny sized items."
			if(ITEM_SIZE_NORMAL)
				storage_info_list += "* It can hold normal sized items, and anything smaller."
			if(ITEM_SIZE_LARGE)
				storage_info_list += "* It can hold large sized items, and anything smaller."
			if(ITEM_SIZE_HUGE)
				storage_info_list += "* It can hold huge sized items, and anything smaller."
			if(ITEM_SIZE_GARGANTUAN)
				storage_info_list += "* It can hold gargantuan sized items, and anything smaller!"
		if(storage.max_storage_space)
			storage_info_list += "* It has a capacity of [storage.max_storage_space]. (That means it could potentially hold that many tiny items, or half that many small items.)"
		if(storage.storage_slots)
			storage_info_list += "* It has [storage.storage_slots] slots for items."

		if(storage.use_to_pickup)
			storage_info_list += "* You can hold this storage item in your hand and click on valid items with it to put them into the storage item."
		if(storage.allow_quick_empty)
			storage_info_list += "* It can use the 'empty' object verb to drop all the contents where you stand."
		if(storage.allow_quick_gather)
			storage_info_list += "* It can use the 'toggle-mode' object verb which allows gathering all valid objects at a location by clicking on the turf under them."

	var/list/slots = list()
	for(var/name in string_slot_flags)
		if(slot_flags & string_slot_flags[name])
			slots += name
	if(slots.len)
		storage_info_list += "* It can be worn on your [english_list(slots)] by holding the item and clicking on the appropriate slot."
		if (("back" || "waist") in slots)
			storage_info_list += "* Storage items worn on the back or waist can be accessed with a simple empty handed click. To remove storage items in these slots, drag the storage item to an empty hand."
	else
		storage_info_list += "* It cannot be worn on your body. Please don't try."

	return jointext(storage_info_list, "<BR>")



/obj/item/plate/tray/get_mechanics_info()
	. = ..()
	. += "<BR><BR>Trays, when put down on a tables, drop all their contents onto the table. If you drop the tray in any other way or hit someone with it, all the items it holds will fall off and scatter. You can also examine a tray to see the contents."
/obj/item/plate/tray/get_lore_info()
	. = ..()
	. += "<BR><BR>A simple tool allowing for multiple items to be carried at once while keeping the load more accessible than a box or bag. Used primarily by hospitality workers and other service staff."