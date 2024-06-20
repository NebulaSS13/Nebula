/datum/storage/bag
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1

/datum/storage/bag/handle_item_insertion(mob/user, obj/item/W, prevent_warning, skip_update)
	. = ..()
	if(. && istype(holder, /obj/item/bag))
		var/obj/item/bag/bag = holder
		bag.update_w_class()

/datum/storage/bag/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	. = ..()
	if(. && istype(holder, /obj/item/bag))
		var/obj/item/bag/bag = holder
		bag.update_w_class()

/datum/storage/bag/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	var/mob/living/human/H = ishuman(user) ? user : null // if we're human, then we need to check if bag in a pocket
	if(holder.loc?.storage || H?.is_in_pocket(holder))
		if(!stop_messages)
			to_chat(user, SPAN_NOTICE("Take \the [holder] out of [istype(holder.loc, /obj) ? "\the [holder.loc]" : "the pocket"] first."))
		return 0 //causes problems if the bag expands and becomes larger than src.loc can hold, so disallow it
	. = ..()

/datum/storage/bag/sack
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	can_hold = list()

/datum/storage/bag/trash
	max_w_class = ITEM_SIZE_HUGE //can fit a backpack inside a trash bag, seems right
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	can_hold = list() // any

/datum/storage/bag/trash/advanced
	max_storage_space = 56

/datum/storage/bag/cash
	max_storage_space = 100
	max_w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/coin, /obj/item/cash)

/datum/storage/bag/cash/infinite/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	. = ..()
	if(. && istype(W,/obj/item/cash)) //only matters if its spacecash.
		handle_item_insertion(null, new /obj/item/cash/c1000, TRUE)

/datum/storage/bag/quantum
	storage_slots = 56
	max_w_class = 400

/datum/storage/bag/plastic
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE
	can_hold = list() // any

/datum/storage/bag/fossils
	storage_slots = 50
	max_storage_space = 200
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/fossil)
