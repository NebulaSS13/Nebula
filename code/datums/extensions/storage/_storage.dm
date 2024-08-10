/datum/storage
	var/atom/holder
	var/expected_type = /atom

	/// Has the storage been opened?
	var/opened = FALSE
	/// What sound do we make when opened?
	var/open_sound
	///Sound played when the storage ui is closed.
	var/close_sound
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


#ifdef UNIT_TEST
var/global/list/_test_storage_items = list()
#endif

/datum/storage/New(atom/_holder)

#ifdef UNIT_TEST
	global._test_storage_items += src
#endif

	if(!istype(_holder))
		PRINT_STACK_TRACE("Storage datum initialized with non-atom holder '[_holder || "NULL"].")
		qdel(src)
		return

	holder = _holder
	if(isnull(max_storage_space) && !isnull(storage_slots))
		max_storage_space = storage_slots * BASE_STORAGE_COST(max_w_class)
	storage_ui = new storage_ui(src)
	prepare_ui()
	..()

/datum/storage/Destroy()

#ifdef UNIT_TEST
	global._test_storage_items -= src
#endif

	if(holder)
		if(holder.storage == src)
			holder.storage = null
		holder = null
	if(istype(storage_ui))
		QDEL_NULL(storage_ui)
	. = ..()

/datum/storage/proc/get_contents()
	return holder?.get_stored_inventory()

/datum/storage/proc/return_inv()
	. = get_contents()
	for(var/atom/thing in .)
		var/list/storage_inv = thing.storage?.return_inv()
		if(storage_inv)
			LAZYDISTINCTADD(., storage_inv)

/datum/storage/proc/show_to(mob/user)
	if(storage_ui)
		storage_ui.show_to(user)

/datum/storage/proc/hide_from(mob/user)
	if(storage_ui)
		storage_ui.hide_from(user)

/datum/storage/proc/open(mob/user)
	if(!opened)
		opened = TRUE
		play_open_sound()
		holder?.queue_icon_update()
	play_use_sound()
	if (isrobot(user) && user.hud_used)
		var/mob/living/silicon/robot/robot = user
		if(robot.shown_robot_modules) //The robot's inventory is open, need to close it first.
			robot.hud_used.toggle_show_robot_modules()

	prepare_ui()
	storage_ui.on_open(user)
	storage_ui.show_to(user)

/datum/storage/proc/prepare_ui()
	storage_ui.prepare_ui()

/datum/storage/proc/close(mob/user)
	if(opened)
		opened = FALSE
		play_close_sound()
		holder?.queue_icon_update()
	hide_from(user)
	if(storage_ui)
		storage_ui.after_close(user)

/datum/storage/proc/close_all()
	if(storage_ui)
		storage_ui.close_all()

/datum/storage/proc/storage_space_used()
	. = 0
	for(var/obj/item/I in get_contents())
		. += I.get_storage_cost()

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/datum/storage/proc/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(user && !user.canUnEquip(W))
		return 0

	if(!holder || holder.loc == W)
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

	if(W.obj_flags & OBJ_FLAG_NO_STORAGE)
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [W] cannot be placed in \the [holder]."))
		return 0

	var/total_storage_space = W.get_storage_cost() + storage_space_used() //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(total_storage_space > max_storage_space)
		if(!stop_messages)
			to_chat(user, SPAN_WARNING("\The [holder] is too full, make some space."))
		return 0

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/datum/storage/proc/handle_item_insertion(mob/user, obj/item/W, prevent_warning, skip_update)
	if(!istype(W))
		return 0
	if(ismob(W.loc))
		var/mob/M = W.loc
		if(!M.try_unequip(W))
			return

	if(holder.reagents?.total_volume)
		W.fluid_act(holder.reagents)
		if(QDELETED(W))
			return

	W.forceMove(holder)
	W.on_enter_storage(src)
	if(user)
		holder.add_fingerprint(user)
		if(!prevent_warning)
			for(var/mob/M in viewers(user, null))
				if (M == user)
					to_chat(user, SPAN_NOTICE("You put \the [W] into [holder]."))
				else if (get_dist(holder, M) <= 1) //If someone is standing close enough, they can tell what it is...
					M.show_message(SPAN_NOTICE("\The [user] puts [W] into [holder]."), VISIBLE_MESSAGE)
				else if (W && W.w_class >= ITEM_SIZE_NORMAL) //Otherwise they can only see large or normal items from a distance...
					M.show_message(SPAN_NOTICE("\The [user] puts [W] into [holder]."), VISIBLE_MESSAGE)
		// Run this regardless of update flag, as it impacts our remaining storage space.
		consolidate_stacks()
		if(!skip_update)
			update_ui_after_item_insertion()
	holder.storage_inserted()
	if(!skip_update)
		holder.update_icon()
	return 1

/datum/storage/proc/consolidate_stacks()

	// Collect all stacks.
	var/list/stacks = list()
	for(var/obj/item/stack/stack in get_contents())
		stacks += stack

	// Try to merge them with each other.
	for(var/obj/item/stack/stack as anything in stacks)
		for(var/obj/item/stack/other_stack as anything in stacks)
			if(stack == other_stack)
				continue
			if(other_stack.get_amount() >= other_stack.get_max_amount())
				stacks -= other_stack
				continue
			if(!stack.can_merge_stacks(other_stack) && !other_stack.can_merge_stacks(stack))
				continue
			stack.transfer_to(other_stack)
			if(!stack.amount || QDELETED(stack))
				break
		if(!stack.amount || QDELETED(stack))
			stacks -= stack

/datum/storage/proc/update_ui_after_item_insertion()
	prepare_ui()
	storage_ui?.on_insertion()

/datum/storage/proc/update_ui_after_item_removal()
	prepare_ui()
	storage_ui?.on_post_remove()

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/datum/storage/proc/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	if(!istype(W))
		return FALSE
	new_location = new_location || get_turf(holder)
	storage_ui?.on_pre_remove(W)
	if(ismob(holder?.loc))
		W.dropped(user)
	if(ismob(new_location))
		W.hud_layerise()
	else
		W.reset_plane_and_layer()
	W.forceMove(new_location)
	if(!skip_update)
		update_ui_after_item_removal()
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	if(!skip_update && holder)
		holder.update_icon()
	return TRUE

// Only do ui functions for now; the obj is responsible for anything else.
/datum/storage/proc/on_item_pre_deletion(obj/item/W)
	storage_ui?.on_pre_remove(W) // Supposed to be able to handle null user.

// Only do ui functions for now; the obj is responsible for anything else.
/datum/storage/proc/on_item_post_deletion(obj/item/W)
	update_ui_after_item_removal()
	holder?.queue_icon_update()

//Run once after using remove_from_storage with skip_update = 1
/datum/storage/proc/finish_bulk_removal()
	update_ui_after_item_removal()
	holder?.queue_icon_update()

//Run once after using handle_item_insertion with skip_update = 1
/datum/storage/proc/finish_bulk_insertion()
	update_ui_after_item_insertion()
	holder?.queue_icon_update()

/datum/storage/proc/gather_all(var/turf/T, var/mob/user)
	var/success = 0
	var/failure = 0
	for(var/obj/item/I in T)
		if(!can_be_inserted(I, user, 0))	// Note can_be_inserted still makes noise when the answer is no
			failure = 1
			continue
		success = 1
		handle_item_insertion(user, I, TRUE, TRUE) // First 1 is no messages, second 1 is no ui updates
	if(success)
		if(failure)
			to_chat(user, SPAN_NOTICE("You put some things into \the [holder]."))
		else
			to_chat(user, SPAN_NOTICE("You put everything into \the [holder]."))
		finish_bulk_insertion()
	else
		to_chat(user, SPAN_NOTICE("You fail to pick anything up with \the [holder]."))

/datum/storage/proc/scoop_inside(mob/living/scooped, mob/living/user)
	if(!istype(scooped))
		return FALSE
	if(!istype(holder) || !scooped.holder_type || scooped.buckled || LAZYLEN(scooped.pinned) || scooped.mob_size > MOB_SIZE_SMALL || scooped != user || holder.loc == scooped)
		return FALSE
	if(!do_after(user, 1 SECOND, holder))
		return FALSE
	if(!istype(holder) || !holder.Adjacent(scooped) || scooped.incapacitated())
		return
	var/obj/item/holder/H = new scooped.holder_type(get_turf(scooped))
	if(H)
		if(can_be_inserted(H))
			scooped.forceMove(H)
			H.sync(scooped)
			handle_item_insertion(user, H)
			return TRUE
		qdel(H)
	return FALSE

/datum/storage/proc/make_exact_fit()
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

/datum/storage/proc/quick_empty(mob/user, var/turf/dump_loc)
	hide_from(user)
	for(var/obj/item/I in get_contents())
		remove_from_storage(user, I, dump_loc, TRUE)
	finish_bulk_removal()

/datum/storage/proc/handle_mouse_drop(mob/user, obj/over_object, params)
	var/atom/atom = holder
	if(!istype(atom))
		return FALSE
	if (ishuman(user) || issmall(user)) //so monkeys can take off their backpacks -- Urist
		if(over_object == user && atom.Adjacent(user)) // this must come before the screen objects only block
			open(user)
			return FALSE
		if(!istype(over_object, /obj/screen/inventory))
			return TRUE
		//makes sure master_item is equipped before putting it in hand, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this...
		if(!user.isEquipped(holder) || !isitem(holder))
			return FALSE
		if(!user.incapacitated())
			var/obj/screen/inventory/inv = over_object
			atom.add_fingerprint(user)
			if(user.try_unequip(holder))
				user.equip_to_slot_if_possible(holder, inv.slot_id)
			return FALSE
	return FALSE

/datum/storage/proc/can_view(mob/viewer)
	return (holder in viewer.contents) || viewer.Adjacent(holder)

///Overridable sound playback parameters. Since not all sounds are created equal.
/datum/storage/proc/play_open_sound(volume = 50)
	if(!length(open_sound) || !holder)
		return
	playsound(holder, open_sound, volume, FALSE, -5)

///Plays the close sound for this storage. volume as arg so it can be overriden. Since not all sounds are created equal.
/datum/storage/proc/play_close_sound(volume = 50)
	if(!length(close_sound) || !holder)
		return
	playsound(holder, close_sound, volume, FALSE, -5)

///Plays the use sound for this storage. volume as arg so it can be overriden. Since not all sounds are created equal.
/datum/storage/proc/play_use_sound(volume = 50)
	if(!length(use_sound) || !holder)
		return
	playsound(holder, use_sound, volume, FALSE, -5)
