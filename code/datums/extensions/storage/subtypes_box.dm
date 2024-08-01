/datum/storage/box
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'

/datum/storage/box/make_exact_fit()
	..()
	var/obj/item/box/box = holder
	if(istype(box))
		box.foldable = null //special form fitted boxes should not be foldable.

/datum/storage/box/metal
	use_sound = 'sound/effects/closet_open.ogg'

/datum/storage/box/large
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE

/datum/storage/box/monkey
	can_hold = list(/obj/item/food/monkeycube)

/datum/storage/box/snappop
	can_hold = list(/obj/item/toy/snappop)

/datum/storage/box/matches
	can_hold = list(/obj/item/flame/match)

/datum/storage/box/lights
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/datum/storage/box/checkers
	max_storage_space = 24
	can_hold = list(/obj/item/checker)

/datum/storage/box/freezer
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(
		/obj/item/organ,
		/obj/item/food,
		/obj/item/chems/drinks,
		/obj/item/chems/condiment,
		/obj/item/chems/glass
	)
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/datum/storage/box/cigar
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 7

/datum/storage/box/cigar/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette/cigar) && isatom(holder))
		var/atom/atom_holder = holder
		if(atom_holder.reagents)
			atom_holder.reagents.trans_to_obj(W, (atom_holder.reagents.total_volume/max(1, length(get_contents()))))
	return ..()

/datum/storage/box/cigarettes
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6

/datum/storage/box/cigarettes/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette) && isatom(holder))
		var/atom/atom_holder = holder
		if(atom_holder.reagents)
			atom_holder.reagents.trans_to_obj(W, (atom_holder.reagents.total_volume/max(1, length(get_contents()))))
	return ..()

/datum/storage/box/cigarettes/cigarello
	max_storage_space = 5

/datum/storage/box/parts_pack
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_SMALL)

/datum/storage/box/donut
	max_storage_space = ITEM_SIZE_SMALL * 6
	can_hold = list(/obj/item/food/donut)

/datum/storage/box/glasses
	can_hold = list(/obj/item/chems/drinks/glass2)
	storage_slots = 8

/datum/storage/box/glass_extras
	can_hold = list(/obj/item/glass_extra)
	storage_slots = 14

/datum/storage/box/vials
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12
	max_storage_space = null

/datum/storage/box/egg
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = ITEM_SIZE_SMALL * 12
	can_hold = list(
		/obj/item/food/egg,
		/obj/item/food/boiledegg
	)

/datum/storage/box/crackers
	storage_slots = 6
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = ITEM_SIZE_TINY * 6
	can_hold = list(/obj/item/food/cracker)

/datum/storage/box/crayons
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6

/datum/storage/box/candles
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 7

/datum/storage/box/candles/scented
	max_storage_space = 5

/datum/storage/box/candles/incense
	max_storage_space = 9
