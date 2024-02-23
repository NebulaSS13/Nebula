/datum/extension/storage
	base_type = /datum/extension/storage
	expected_type = /atom

	/// Has the storage been opened?
	var/opened = FALSE
	/// What sound do we make when opened?
	var/open_sound
	/// List of objects which this item can store (if set, it can't store anything else)
	var/list/can_hold  = list()
	/// List of objects which this item can't store (in effect only if can_hold isn't set)
	var/list/cant_hold = list()
	/// Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_w_class = ITEM_SIZE_SMALL 
	/// Total storage cost of items this can hold. Will be autoset based on storage_slots if left null.
	var/max_storage_space
	/// The number of storage slots in this container.
	var/storage_slots
	/// Set this boolean variable to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/use_to_pickup 
	/// Set this boolean variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_empty 
	/// Set this boolean variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/allow_quick_gather 
	/// FALSE = pick one at a time, TRUE = pick all on tile
	var/collection_mode = TRUE
	/// sound played when used. null for no sound.
	var/use_sound = "rustle" 
	/// What storage UI do we use?
	var/datum/storage_ui/storage_ui = /datum/storage_ui/default

/datum/extension/storage/New()
	if(isnull(max_storage_space) && !isnull(storage_slots))
		max_storage_space = storage_slots * BASE_STORAGE_COST(max_w_class)
	storage_ui = new storage_ui(src)
	prepare_ui()
	..()

/datum/extension/storage/Destroy()
	if(istype(storage_ui))
		QDEL_NULL(storage_ui)
	. = ..()

/datum/extension/storage/proc/get_contents()
	var/atom/atom_holder = isatom(holder) ? holder : null
	return atom_holder?.get_stored_inventory()

/datum/extension/storage/proc/return_inv()
	. = get_contents()
	for(var/obj/item/thing in .)
		var/datum/extension/storage/storage = get_extension(thing, /datum/extension/storage)
		var/list/storage_inv = storage?.return_inv()
		if(storage_inv)
			LAZYDISTINCTADD(., storage_inv)

/datum/extension/storage/proc/show_to(mob/user)
	if(storage_ui)
		storage_ui.show_to(user)

/datum/extension/storage/proc/hide_from(mob/user)
	if(storage_ui)
		storage_ui.hide_from(user)

/datum/extension/storage/proc/open(mob/user)
	if(!opened)
		opened = TRUE
		if(isatom(holder))
			var/atom/atom_holder = holder
			playsound(atom_holder.loc, open_sound, 50, 0, -5)
			atom_holder.queue_icon_update()
	if (use_sound)
		playsound(holder, use_sound, 50, 0, -5)
	if (isrobot(user) && user.hud_used)
		var/mob/living/silicon/robot/robot = user
		if(robot.shown_robot_modules) //The robot's inventory is open, need to close it first.
			robot.hud_used.toggle_show_robot_modules()

	prepare_ui()
	storage_ui.on_open(user)
	storage_ui.show_to(user)

/datum/extension/storage/proc/prepare_ui()
	storage_ui.prepare_ui()

/datum/extension/storage/proc/close(mob/user)
	hide_from(user)
	if(storage_ui)
		storage_ui.after_close(user)

/datum/extension/storage/proc/close_all()
	if(storage_ui)
		storage_ui.close_all()

/datum/extension/storage/proc/storage_space_used()
	. = 0
	for(var/obj/item/I in get_contents())
		. += I.get_storage_cost()

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/datum/extension/storage/proc/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(user && !user.canUnEquip(W))
		return 0

	var/atom/atom_holder = holder
	if(!isatom(atom_holder) || atom_holder.loc == W)
		return 0 //Means the item is already in the storage item

	if(storage_slots != null && length(get_contents()) >= storage_slots)
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [holder] is full, make some space."))
		return 0 //Storage item is full

	if(W.anchored)
		return 0

	if(can_hold.len)
		if(!is_type_in_list(W, can_hold))
			if(!stop_messages && ! istype(W, /obj/item/hand_labeler))
				to_chat(user, SPAN_WARNING("\The [holder] cannot hold \the [W]."))
			return 0
		var/max_instances = can_hold[W.type]
		if(max_instances && instances_of_type_in_list(W, get_contents()) >= max_instances)
			if(!stop_messages && !istype(W, /obj/item/hand_labeler))
				to_chat(user, SPAN_WARNING("\The [holder] has no more space specifically for \the [W]."))
			return 0

	//If attempting to lable the storage item, silently fail to allow it
	if(istype(W, /obj/item/hand_labeler) && user?.a_intent != I_HELP)
		return FALSE
	//Prevent package wrapper from being inserted by default
	if(istype(W, /obj/item/stack/package_wrap) && user?.a_intent != I_HELP)
		return FALSE

	// Don't allow insertion of unsafed compressed matter implants
	// Since they are sucking something up now, their afterattack will delete the storage
	if(istype(W, /obj/item/implanter/compressed))
		var/obj/item/implanter/compressed/impr = W
		if(!impr.safe)
			stop_messages = 1
			return 0

	if(cant_hold.len && is_type_in_list(W, cant_hold))
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [holder] cannot hold \the [W]."))
		return 0

	if (max_w_class != null && W.w_class > max_w_class)
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [W] is too big for \the [holder]."))
		return 0

	var/total_storage_space = W.get_storage_cost()
	if(total_storage_space >= ITEM_SIZE_NO_CONTAINER)
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [W] cannot be placed in \the [holder]."))
		return 0

	total_storage_space += storage_space_used() //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(total_storage_space > max_storage_space)
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [holder] is too full, make some space."))
		return 0

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/datum/extension/storage/proc/handle_item_insertion(var/obj/item/W, var/prevent_warning = 0, var/NoUpdate = 0)
	if(!istype(W))
		return 0
	if(ismob(W.loc))
		var/mob/M = W.loc
		if(!M.try_unequip(W))
			return
	W.forceMove(holder)
	W.on_enter_storage(src)
	var/atom/atom_holder = holder
	if(usr)
		if(istype(atom_holder))
			atom_holder.add_fingerprint(usr)
		if(!prevent_warning)
			for(var/mob/M in viewers(usr, null))
				if (M == usr)
					to_chat(usr, SPAN_NOTICE("You put \the [W] into [holder]."))
				else if (get_dist(holder, M) <= 1) //If someone is standing close enough, they can tell what it is...
					M.show_message(SPAN_NOTICE("\The [usr] puts [W] into [holder]."), VISIBLE_MESSAGE)
				else if (W && W.w_class >= ITEM_SIZE_NORMAL) //Otherwise they can only see large or normal items from a distance...
					M.show_message(SPAN_NOTICE("\The [usr] puts [W] into [holder]."), VISIBLE_MESSAGE)
		if(!NoUpdate)
			update_ui_after_item_insertion()
	if(istype(atom_holder))
		atom_holder.update_icon()
	return 1

/datum/extension/storage/proc/update_ui_after_item_insertion()
	prepare_ui()
	if(storage_ui)
		storage_ui.on_insertion(usr)

/datum/extension/storage/proc/update_ui_after_item_removal()
	prepare_ui()
	if(storage_ui)
		storage_ui.on_post_remove(usr)

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/datum/extension/storage/proc/remove_from_storage(obj/item/W, atom/new_location, var/NoUpdate = 0)
	if(!istype(W)) 
		return 0
	new_location = new_location || get_turf(holder)
	if(storage_ui)
		storage_ui.on_pre_remove(usr, W)
	if(isatom(holder))
		var/atom/atom_holder = holder
		if(ismob(atom_holder.loc))
			W.dropped(usr)
	if(ismob(new_location))
		W.hud_layerise()
	else
		W.reset_plane_and_layer()
	W.forceMove(new_location)
	if(usr && !NoUpdate)
		update_ui_after_item_removal()
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	if(!NoUpdate && isatom(holder))
		var/atom/atom_holder = holder
		atom_holder.update_icon()
	return 1

// Only do ui functions for now; the obj is responsible for anything else.
/datum/extension/storage/proc/on_item_pre_deletion(obj/item/W)
	if(storage_ui)
		storage_ui.on_pre_remove(null, W) // Supposed to be able to handle null user.

// Only do ui functions for now; the obj is responsible for anything else.
/datum/extension/storage/proc/on_item_post_deletion(obj/item/W)
	if(storage_ui)
		update_ui_after_item_removal()
	if(isatom(holder))
		var/atom/atom_holder = holder
		atom_holder.queue_icon_update()

//Run once after using remove_from_storage with NoUpdate = 1
/datum/extension/storage/proc/finish_bulk_removal()
	update_ui_after_item_removal()
	if(isatom(holder))
		var/atom/atom_holder = holder
		atom_holder.update_icon()

/datum/extension/storage/proc/gather_all(var/turf/T, var/mob/user)
	var/success = 0
	var/failure = 0
	for(var/obj/item/I in T)
		if(!can_be_inserted(I, user, 0))	// Note can_be_inserted still makes noise when the answer is no
			failure = 1
			continue
		success = 1
		handle_item_insertion(I, 1, 1) // First 1 is no messages, second 1 is no ui updates
	if(success && !failure)
		to_chat(user, SPAN_NOTICE("You put everything into \the [holder]."))
		update_ui_after_item_insertion()
	else if(success)
		to_chat(user, SPAN_NOTICE("You put some things into \the [holder]."))
		update_ui_after_item_insertion()
	else
		to_chat(user, SPAN_NOTICE("You fail to pick anything up with \the [holder]."))

/datum/extension/storage/proc/scoop_inside(mob/living/scooped, mob/living/user)
	if(!istype(scooped))
		return FALSE
	var/atom/atom_holder = holder
	if(!istype(atom_holder) || !scooped.holder_type || scooped.buckled || LAZYLEN(scooped.pinned) || scooped.mob_size > MOB_SIZE_SMALL || scooped != user || atom_holder.loc == scooped)
		return FALSE
	if(!do_after(user, 1 SECOND, holder))
		return FALSE
	if(!istype(atom_holder) || !atom_holder.Adjacent(scooped) || scooped.incapacitated())
		return
	var/obj/item/holder/H = new scooped.holder_type(get_turf(scooped))
	if(H)
		if(can_be_inserted(H))
			scooped.forceMove(H)
			H.sync(scooped)
			handle_item_insertion(H)
			return TRUE
		qdel(H)
	return FALSE

/datum/extension/storage/proc/make_exact_fit()
	var/list/contents = get_contents()
	var/contents_length = length(contents)
	if(contents_length <= 0)
		log_warning("[type]/[holder?.type] is calling make_exact_fit() while completely empty! This is likely a mistake.")
	storage_slots = contents_length
	can_hold.Cut()
	max_w_class = ITEM_SIZE_MIN
	max_storage_space = 0
	for(var/obj/item/I in contents)
		can_hold[I.type]++
		max_w_class = max(I.w_class, max_w_class)
		max_storage_space += I.get_storage_cost()

/datum/extension/storage/proc/quick_empty(mob/user, var/turf/dump_loc)
	hide_from(user)
	for(var/obj/item/I in get_contents())
		remove_from_storage(I, dump_loc, 1)
	finish_bulk_removal()
