/datum/extension/storage/box
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'

/datum/extension/storage/box/make_exact_fit()
	..()
	var/obj/item/box/box = holder
	if(istype(box))
		box.foldable = null //special form fitted boxes should not be foldable.

/datum/extension/storage/box/metal
	use_sound = 'sound/effects/closet_open.ogg'

/datum/extension/storage/box/large
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE

/datum/extension/storage/box/monkey
	can_hold = list(/obj/item/chems/food/monkeycube)

/datum/extension/storage/box/snappop
	can_hold = list(/obj/item/toy/snappop)

/datum/extension/storage/box/matches
	can_hold = list(/obj/item/flame/match)

/datum/extension/storage/box/lights
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/datum/extension/storage/box/checkers
	max_storage_space = 24
	can_hold = list(/obj/item/checker)

/datum/extension/storage/box/freezer
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(
		/obj/item/organ, 
		/obj/item/chems/food, 
		/obj/item/chems/drinks, 
		/obj/item/chems/condiment, 
		/obj/item/chems/glass
	)
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/datum/extension/storage/box/cigar
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 7

/datum/extension/storage/box/cigar/remove_from_storage(obj/item/W, atom/new_location)
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette/cigar) && istype(holder, /atom))
		var/atom/atom_holder = holder
		if(atom_holder.reagents)
			atom_holder.reagents.trans_to_obj(W, (atom_holder.reagents.total_volume/max(1, length(get_contents()))))
	return ..()

/datum/extension/storage/box/cigarettes
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6

/datum/extension/storage/box/cigarettes/remove_from_storage(obj/item/W, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette) && istype(holder, /atom))
		var/atom/atom_holder = holder
		if(atom_holder.reagents)
			atom_holder.reagents.trans_to_obj(W, (atom_holder.reagents.total_volume/max(1, length(get_contents()))))
	return ..()

/datum/extension/storage/box/cigarettes/cigarello
	max_storage_space = 5

/datum/extension/storage/box/parts_pack
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_SMALL)

/datum/extension/storage/box/donut
	max_storage_space = ITEM_SIZE_SMALL * 6
	can_hold = list(/obj/item/chems/food/donut)

/datum/extension/storage/box/glasses
	can_hold = list(/obj/item/chems/drinks/glass2)
	storage_slots = 8

/datum/extension/storage/box/glass_extras
	can_hold = list(/obj/item/glass_extra)
	storage_slots = 14

/datum/extension/storage/box/vials
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12
	max_storage_space = null

/datum/extension/storage/box/egg
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = ITEM_SIZE_SMALL * 12
	can_hold = list(
		/obj/item/chems/food/egg,
		/obj/item/chems/food/boiledegg
	)

/datum/extension/storage/box/crackers
	storage_slots = 6
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = ITEM_SIZE_TINY * 6
	can_hold = list(/obj/item/chems/food/cracker)

/datum/extension/storage/box/crayons
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6

/datum/extension/storage/box/candles
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 7

/datum/extension/storage/box/candles/scented
	max_storage_space = 5

/datum/extension/storage/box/incense
	max_storage_space = 9
