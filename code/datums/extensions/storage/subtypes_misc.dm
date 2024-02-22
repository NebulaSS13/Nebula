/datum/extension/storage/bible
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 4

/datum/extension/storage/briefcase
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE

/datum/extension/storage/briefcase/inflatables
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	can_hold = list(/obj/item/inflatable)

/datum/extension/storage/laundry_basket
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE //20 for clothes + a bit of additional space for non-clothing items that were worn on body
	storage_slots = 14
	use_to_pickup = 1
	allow_quick_empty = 1
	allow_quick_gather = 1
	collection_mode = 1

/datum/extension/storage/laundry_basket/show_to(mob/user)
	return

/datum/extension/storage/laundry_basket/open(mob/user)
	return

/datum/extension/storage/lockbox
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 32 //The sum of the w_classes of all the items in this storage item.
	expected_type = /obj/item/storage/lockbox

/datum/extension/storage/lockbox/show_to(mob/user)
	var/obj/item/storage/lockbox/container = holder
	if(istype(container) && container.locked)
		to_chat(user, SPAN_WARNING("\The [holder] is locked!"))
		return
	return ..()

/datum/extension/storage/lunchbox
	max_storage_space = 8 //slightly smaller than a toolbox
	max_w_class = ITEM_SIZE_SMALL

/datum/extension/storage/med_pouch
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'

/datum/extension/storage/med_pouch/open(mob/user)
	if(!opened)
		user.visible_message("<span class='notice'>\The [user] tears open [src], breaking the vacuum seal!</span>", "<span class='notice'>You tear open [src], breaking the vacuum seal!</span>")
	. = ..()

/datum/extension/storage/cigpapers
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 10

/datum/extension/storage/chewables
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6

/datum/extension/storage/chewables/rollable
	max_storage_space = 8

/datum/extension/storage/chewables/cookies
	max_storage_space = 6

/datum/extension/storage/chewables/gum
	max_storage_space = 8

/datum/extension/storage/chewables/lollipops
	max_storage_space = 20

/datum/extension/storage/pouches
	storage_slots = 2

/datum/extension/storage/pouches/large
	storage_slots = 4

/datum/extension/storage/hopper
	max_w_class = ITEM_SIZE_NORMAL          // Hopper intake size.
	max_storage_space = DEFAULT_BOX_STORAGE // Total internal storage size.

/datum/extension/storage/hopper/small
	max_w_class = ITEM_SIZE_TINY

/datum/extension/storage/photo_album
	storage_slots = DEFAULT_BOX_STORAGE //yes, that's storage_slots. Photos are w_class 1 so this has as many slots equal to the number of photos you could put in a box
	can_hold = list(/obj/item/photo)

/datum/extension/storage/picnic_basket
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE

/datum/extension/storage/toolbox
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE //enough to hold all starting contents
	use_sound = 'sound/effects/storage/toolbox.ogg'

/datum/extension/storage/mech
	max_w_class = ITEM_SIZE_LARGE
	storage_slots = 4
	use_sound = 'sound/effects/storage/toolbox.ogg'
