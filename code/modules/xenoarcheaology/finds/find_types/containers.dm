
/decl/archaeological_find/container
	item_type = "container"
	new_icon_state = "box"
	possible_types = list(/obj/item/box)
	engraving_chance = 10

/decl/archaeological_find/container/spawn_item(atom/loc)
	var/obj/item/box/new_box = ..()
	if(new_box?.storage)
		new_box.storage.max_w_class = pick(ITEM_SIZE_TINY,2;ITEM_SIZE_SMALL,3;ITEM_SIZE_NORMAL,4;ITEM_SIZE_LARGE)
		var/storage_amount = BASE_STORAGE_COST(new_box.storage.max_w_class)
		new_box.storage.max_storage_space = rand(storage_amount, storage_amount * 10)
	return new_box
