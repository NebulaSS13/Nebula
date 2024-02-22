/datum/extension/storage/excavation
	storage_slots = 7
	can_hold = list(/obj/item/pickaxe/xeno)
	max_storage_space = 18
	max_w_class = ITEM_SIZE_NORMAL
	use_to_pickup = 1

/datum/extension/storage/excavation/handle_item_insertion()
	. = ..()
	var/obj/item/storage/excavation/picks = holder
	if(istype(picks))
		picks.sort_picks()
