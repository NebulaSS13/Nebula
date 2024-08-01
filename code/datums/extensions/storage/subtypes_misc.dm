/datum/storage/bible
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 4

/datum/storage/briefcase
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	open_sound = 'sound/items/containers/briefcase_unlock.ogg'
	close_sound = 'sound/items/containers/briefcase_lock.ogg'

/datum/storage/briefcase/inflatables
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	can_hold = list(/obj/item/inflatable)

/datum/storage/laundry_basket
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE //20 for clothes + a bit of additional space for non-clothing items that were worn on body
	storage_slots = 14
	use_to_pickup = 1
	allow_quick_empty = 1
	allow_quick_gather = 1
	collection_mode = 1

/datum/storage/laundry_basket/show_to(mob/user)
	return

/datum/storage/laundry_basket/open(mob/user)
	return

/datum/storage/lockbox
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 32 //The sum of the w_classes of all the items in this storage item.
	expected_type = /obj/item/lockbox

/datum/storage/lockbox/show_to(mob/user)
	var/obj/item/lockbox/container = holder
	if(istype(container) && container.locked)
		to_chat(user, SPAN_WARNING("\The [holder] is locked!"))
		return
	return ..()

/datum/storage/lunchbox
	max_storage_space = 8 //slightly smaller than a toolbox
	max_w_class = ITEM_SIZE_SMALL

/datum/storage/med_pouch
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'

/datum/storage/med_pouch/open(mob/user)
	if(!opened)
		user.visible_message(
			SPAN_NOTICE("\The [user] tears open \the [holder], breaking the vacuum seal!"),
			SPAN_NOTICE("You tear open \the [holder], breaking the vacuum seal!")
		)
	. = ..()

/datum/storage/cigpapers
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 10

/datum/storage/chewables
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6

/datum/storage/chewables/rollable
	max_storage_space = 8

/datum/storage/chewables/cookies
	max_storage_space = 6

/datum/storage/chewables/gum
	max_storage_space = 8

/datum/storage/chewables/lollipops
	max_storage_space = 20

/datum/storage/pouches
	storage_slots = 2

/datum/storage/pouches/large
	storage_slots = 4

/datum/storage/barrel
	max_w_class       = ITEM_SIZE_GARGANTUAN
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_GARGANTUAN)

/datum/storage/hopper
	max_w_class = ITEM_SIZE_NORMAL          // Hopper intake size.
	max_storage_space = DEFAULT_BOX_STORAGE // Total internal storage size.

/datum/storage/hopper/small
	max_w_class = ITEM_SIZE_TINY

/datum/storage/hopper/industrial
	max_w_class       = ITEM_SIZE_GARGANTUAN
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_NORMAL)

/datum/storage/hopper/industrial/compost
	can_hold = list(/obj/item)
	expected_type = /obj/structure/reagent_dispensers/compost_bin

/datum/storage/hopper/industrial/compost/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	. = ..()
	if(!.)
		return
	if(istype(W, /obj/item/food/worm) && istype(holder, /obj/structure/reagent_dispensers/compost_bin))
		var/worms = 0
		for(var/obj/item/food/worm/worm in get_contents())
			worms++
		return worms < COMPOST_MAX_WORMS
	return W.is_compostable()

/datum/storage/photo_album
	storage_slots = DEFAULT_BOX_STORAGE //yes, that's storage_slots. Photos are w_class 1 so this has as many slots equal to the number of photos you could put in a box
	can_hold = list(/obj/item/photo)

/datum/storage/picnic_basket
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BOX_STORAGE

/datum/storage/toolbox
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE //enough to hold all starting contents
	use_sound = 'sound/effects/storage/toolbox.ogg'

/datum/storage/mech
	max_w_class = ITEM_SIZE_LARGE
	storage_slots = 4
	use_sound = 'sound/effects/storage/toolbox.ogg'
