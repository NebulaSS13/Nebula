/datum/storage/firstaid
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'

/datum/storage/firstaid/surgery
	storage_slots = 14
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = null
	use_sound = 'sound/effects/storage/briefcase.ogg'
	can_hold = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/sutures,
		/obj/item/stack/medical/bandage/advanced,
		/obj/item/stack/nanopaste
	)

/datum/storage/firstaid/surgery/ghetto
	can_hold = list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/tool/axe/hatchet,
		/obj/item/utensil/fork,
		/obj/item/shard,
		/obj/item/flame/fuelled/lighter,
		/obj/item/stack/cable_coil
	)
