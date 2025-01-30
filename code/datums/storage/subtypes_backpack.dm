/datum/storage/backpack
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	open_sound = 'sound/effects/storage/unzip.ogg'

/datum/storage/backpack/holding
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 56

/datum/storage/backpack/holding/can_be_inserted(obj/item/W, mob/user, stop_messages = 0, click_params)
	if(istype(W, /obj/item/backpack/holding))
		return 1
	return ..()

/datum/storage/backpack/santa
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 400 // can store a ton of shit!

/datum/storage/backpack/duffle
	max_storage_space = DEFAULT_BACKPACK_STORAGE + 10

/datum/storage/backpack/pocketbook
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE

/datum/storage/backpack/smuggler
	storage_slots = 5
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 15
	cant_hold = list(/obj/item/backpack/satchel/flat) //muh recursive backpacks

/datum/storage/backpack/crow
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
