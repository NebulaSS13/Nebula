/datum/storage/sheets
	storage_ui = /datum/storage_ui/default/sheetsnatcher
	storage_slots = 7
	allow_quick_empty = TRUE
	use_to_pickup = TRUE
	/// the number of sheets it can carry.
	var/capacity = 300

/datum/storage/sheets/robot
	capacity = 500 //Borgs get more because >specialization

/datum/storage/sheets/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	if(!istype(W,/obj/item/stack/material))
		if(!stop_messages)
			to_chat(user, "\The [holder] does not accept [W].")
		return FALSE
	var/current = 0
	for(var/obj/item/stack/material/S in get_contents())
		current += S.amount
	if(capacity == current)//If it's full, you're done
		if(!stop_messages)
			to_chat(user, "<span class='warning'>\The [holder] is full.</span>")
		return FALSE
	return TRUE

// Modified handle_item_insertion.  Would prefer not to, but...
/datum/storage/sheets/handle_item_insertion(mob/user, obj/item/W, prevent_warning, skip_update, click_params)
	var/obj/item/stack/material/S = W
	if(!istype(S))
		return FALSE
	var/amount
	var/inserted = 0
	var/current = 0
	for(var/obj/item/stack/material/S2 in get_contents())
		current += S2.amount
	if(capacity < current + S.amount)//If the stack will fill it up
		amount = capacity - current
	else
		amount = S.amount
	for(var/obj/item/stack/material/sheet in get_contents())
		if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
			sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
			S.amount -= amount
			inserted = 1
			break
	if(!inserted || !S.amount)
		usr.drop_from_inventory(S, holder)
		if(!S.amount)
			qdel(S)
	prepare_ui(usr)
	if(isatom(holder))
		var/atom/atom_holder = holder
		atom_holder.update_icon()
	return TRUE

// Modified quick_empty verb drops appropriate sized stacks
/datum/storage/sheets/quick_empty(mob/user, var/turf/dump_loc)
	for(var/obj/item/stack/material/S in get_contents())
		while(S.amount)
			var/obj/item/stack/material/N = new S.type(dump_loc)
			var/stacksize = min(S.amount,N.max_amount)
			N.amount = stacksize
			S.amount -= stacksize
		if(!S.amount)
			qdel(S) // todo: there's probably something missing here
	prepare_ui()
	if(usr.active_storage)
		usr.active_storage.show_to(usr)
	if(isatom(holder))
		var/atom/atom_holder = holder
		atom_holder.update_icon()

// Instead of removing
/datum/storage/sheets/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	var/obj/item/stack/material/S = W
	if(!istype(S))
		return FALSE

	//I would prefer to drop a new stack, but the item/attack_hand code
	// that calls this can't recieve a different object than you clicked on.
	//Therefore, make a new stack internally that has the remainder.
	// -Sayu

	if(S.amount > S.max_amount)
		var/obj/item/stack/material/temp = new S.type(holder)
		temp.amount = S.amount - S.max_amount
		S.amount = S.max_amount
	return ..(user, S, new_location)
