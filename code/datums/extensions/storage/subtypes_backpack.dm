/datum/extension/storage/backpack
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	open_sound = 'sound/effects/storage/unzip.ogg'

/datum/extension/storage/backpack/holding
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 56

/datum/extension/storage/backpack/holding/can_be_inserted(obj/item/W, stop_messages = 0)
	if(istype(W, /obj/item/backpack/holding))
		return 1
	return ..()

/datum/extension/storage/backpack/santa
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 400 // can store a ton of shit!

/datum/extension/storage/backpack/duffle
	max_storage_space = DEFAULT_BACKPACK_STORAGE + 10

/datum/extension/storage/backpack/pocketbook
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE

/datum/extension/storage/backpack/smuggler
	storage_slots = 5
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 15
	cant_hold = list(/obj/item/backpack/satchel/flat) //muh recursive backpacks

/datum/extension/storage/backpack/crow
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
