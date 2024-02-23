
/decl/archaeological_find/container
	item_type = "container"
	new_icon_state = "box"
	possible_types = list(/obj/item/box)
	engraving_chance = 10

/decl/archaeological_find/container/spawn_item(atom/loc)
	var/obj/item/box/new_box = ..()
	var/datum/extension/storage/storage = get_extension(new_box, /datum/extension/storage)
	if(storage)
		storage.max_w_class = pick(ITEM_SIZE_TINY,2;ITEM_SIZE_SMALL,3;ITEM_SIZE_NORMAL,4;ITEM_SIZE_LARGE)
		var/storage_amount = BASE_STORAGE_COST(storage.max_w_class)
		storage.max_storage_space = rand(storage_amount, storage_amount * 10)
	return new_box
