/datum/stored_items
	var/item_name = "name"	//Name of the item(s) displayed
	var/item_path = null	// The original amount held
	var/amount = 0
	var/list/instances		//What items are actually stored
	var/atom/storing_object

/datum/stored_items/New(atom/_storing_object, _path, _name, _amount = 0)
	if(_storing_object)
		storing_object = _storing_object
	if(!istype(storing_object))
		CRASH("Unexpected storing object: [storing_object]")
	if(_path)
		item_path = _path
	if(!ispath(item_path))
		CRASH("Unexpected item path: [item_path || "NULL"]")
	item_name = _name || atom_info_repository.get_name_for(item_path)
	amount = _amount
	..()

/datum/stored_items/Destroy()
	storing_object = null
	QDEL_NULL_LIST(instances)
	. = ..()

/datum/stored_items/dd_SortValue()
	return item_name

/datum/stored_items/proc/get_amount()
	return amount

/datum/stored_items/proc/add_product(var/atom/movable/product)
	if(product.type != item_path)
		return 0
	if(product in instances)
		return 0
	product.forceMove(storing_object)
	LAZYADD(instances, product)
	amount++
	return 1

/datum/stored_items/proc/get_product(var/product_location)
	if(!get_amount() || !product_location)
		return

	var/atom/movable/product
	if(LAZYLEN(instances))
		product = instances[instances.len]	// Remove the last added product
		LAZYREMOVE(instances, product)
	else
		product = new item_path(storing_object)

	amount--
	if(!QDELETED(product)) // Some spawners will qdel after vending.
		product.forceMove(product_location)
	return product

/datum/stored_items/proc/get_specific_product(var/product_location, var/atom/movable/product)
	if(!get_amount() || !instances || !product_location || !product)
		return FALSE

	. = instances.Remove(product)
	if(.)
		product.forceMove(product_location)

/datum/stored_items/proc/merge(datum/stored_items/other)
	if(other.item_path != item_path)
		return FALSE
	for(var/atom/movable/thing in other.instances)
		other.instances -= thing
		if(thing in instances)
			amount-- // Don't double-count
		else
			thing.forceMove(storing_object)
			LAZYADD(instances, thing)
	amount += other.amount
	qdel(other)
	return TRUE

/datum/stored_items/proc/migrate(atom/new_storing_obj)
	storing_object = new_storing_obj
	for(var/atom/movable/thing in instances)
		thing.forceMove(new_storing_obj)

/datum/stored_items/proc/get_combined_matter(include_instances = TRUE, include_reagents = TRUE)
	var/virtual_amount = amount - length(instances)
	if(virtual_amount)
		. = atom_info_repository.get_matter_for(item_path)?.Copy()
		for(var/key in .)
			.[key] *= virtual_amount
	else
		. = list()
	if(include_instances)
		for(var/atom/instance in instances)
			. = MERGE_ASSOCS_WITH_NUM_VALUES(., instance.get_contained_matter(include_reagents))