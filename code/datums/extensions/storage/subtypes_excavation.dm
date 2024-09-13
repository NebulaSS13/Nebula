/datum/storage/excavation
	storage_slots = 7
	can_hold = list(/obj/item/tool/xeno)
	max_storage_space = 18
	max_w_class = ITEM_SIZE_NORMAL
	use_to_pickup = 1

/datum/storage/excavation/handle_item_insertion(mob/user, obj/item/W, prevent_warning, skip_update, click_params)
	. = ..()
	var/obj/item/excavation/picks = holder
	if(istype(picks))
		picks.sort_picks()
