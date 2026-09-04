/datum/storage/ore
	max_storage_space = 200
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/stack/material/ore)
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE

/datum/storage/evidence
	max_storage_space = 100
	max_w_class = ITEM_SIZE_SMALL
	can_hold = list(
		/obj/item/forensics/sample,
		/obj/item/evidencebag,
		/obj/item/forensics,
		/obj/item/photo,
		/obj/item/paper,
		/obj/item/paper_bundle
	)
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE

/datum/storage/plants
	max_storage_space = 100
	max_w_class = ITEM_SIZE_SMALL
	can_hold = list(
		/obj/item/food/grown,
		/obj/item/seeds
	)
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	use_to_pickup = TRUE
