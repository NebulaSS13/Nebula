// Dumping the stock of a vending machine causes lots of items and client lag, so use this thing instead.

/obj/structure/vending_refill
	name = "vendor restock"
	desc = "A large sealed container containing items sold from a vending machine."
	icon = 'icons/obj/closets/bases/large_crate.dmi'
	icon_state = "base"
	color = COLOR_BEASTY_BROWN
	w_class = ITEM_SIZE_HUGE
	var/expected_type
	var/list/product_records

/obj/structure/vending_refill/Destroy()
	QDEL_NULL_LIST(product_records)
	. = ..()

/obj/structure/vending_refill/get_lore_info()
	return "Vendor restock containers are notoriously difficult to open, representing the pinnacle of humanity's antitheft technologies."

/obj/structure/vending_refill/get_mechanics_info()
	return "Drag to a vendor to restock. Generally can not be opened."

/obj/structure/vending_refill/handle_mouse_drop(atom/over, mob/user, params)
	if(istype(over, /obj/machinery/vending))
		var/obj/machinery/vending/vendor = over
		var/target_type = vendor.base_type || vendor.type
		if(ispath(expected_type, target_type))
			for(var/datum/stored_items/product_record in product_records)
				for(var/datum/stored_items/record in vendor.product_records)
					if(record.merge(product_record))
						break
				if(!QDELETED(product_record))
					product_record.migrate(over)
					vendor.product_records += product_record
			product_records = null
			SSnano.update_uis(vendor)
			qdel(src)
			return TRUE
	. = ..()

/obj/structure/vending_refill/get_contained_matter(include_reagents = TRUE)
	. = ..()
	for(var/datum/stored_items/vending_products/record in product_records)
		. = MERGE_ASSOCS_WITH_NUM_VALUES(., record.get_combined_matter(include_instances = FALSE))

/obj/machinery/vending/get_contained_matter(include_reagents = TRUE)
	. = ..()
	for(var/datum/stored_items/vending_products/record in product_records)
		. = MERGE_ASSOCS_WITH_NUM_VALUES(., record.get_combined_matter(include_instances = FALSE))

/obj/machinery/vending/dismantle()
	var/obj/structure/vending_refill/dump = new(loc)
	dump.SetName("[dump.name] ([name])")
	dump.expected_type = base_type || type
	for(var/datum/stored_items/vending_products/product_record in product_records)
		product_record.migrate(dump)
	dump.product_records = product_records
	product_records = null
	. = ..()