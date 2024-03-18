//CONTAINS: Evidence bags and fingerprint cards

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/items/evidencebag.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic
	obj_flags = OBJ_FLAG_HOLLOW
	var/obj/item/stored_item = null

/obj/item/evidencebag/handle_mouse_drop(atom/over, mob/user, params)
	if(user.get_empty_hand_slot() && isitem(over))

		var/obj/item/I = over

		if(I.anchored)
			return ..()

		if(istype(I, /obj/item/evidencebag))
			to_chat(user, SPAN_WARNING("You find putting an evidence bag in another evidence bag to be slightly absurd."))
			return TRUE

		if(I.w_class > ITEM_SIZE_NORMAL)
			to_chat(user, SPAN_WARNING("\The [I] won't fit in \the [src]."))
			return TRUE

		if(stored_item)
			to_chat(user, SPAN_WARNING("\The [src] already has something inside it."))
			return TRUE

		if(isturf(I.loc))
			if(!user.Adjacent(I))
				return ..()
		else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
			if(I.loc?.storage)	//in a container.
				return ..()
			
			var/sdepth = I.storage_depth(user)
			if (sdepth == -1 || sdepth > 1)
				return ..() //too deeply nested to access
			
			user.drop_from_inventory(I)

		user.visible_message( \
			SPAN_NOTICE("\The [user] puts \the [I] into \the [src]."), \
			SPAN_NOTICE("You put \the [I] inside \the [src]."), \
			"You hear a rustle as someone puts something into a plastic bag.")
		if(!user.skill_check(SKILL_FORENSICS, SKILL_BASIC))
			I.add_fingerprint(user)
		store_item(I)
		return TRUE
	. = ..()

/obj/item/evidencebag/proc/store_item(obj/item/I)
	I.forceMove(src)
	stored_item = I
	w_class = I.w_class
	update_icon()

/obj/item/evidencebag/on_update_icon()
	. = ..()
	if(stored_item)
		icon_state = "evidence"
		//copy the item's appearance and make its layer relative to its parent.
		var/image/img = image("icon"=stored_item, "layer"=FLOAT_LAYER) // (necessary to stop the underlays appearing under our inventory-HUD slots ~Carn
		img.pixel_x = 0
		img.pixel_y = 0
		add_overlay(img)
		add_overlay("evidence")	//should look nicer for transparent stuff. not really that important, but hey.

		desc = "An evidence bag containing [stored_item]."
	else
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."

/obj/item/evidencebag/attack_self(mob/user)
	if(stored_item)
		user.visible_message("[user] takes [stored_item] out of [src]", "You take [stored_item] out of [src].",\
		"You hear someone rustle around in a plastic bag, and remove something.")
		user.put_in_hands(stored_item)
		empty()
	else
		to_chat(user, "[src] is empty.")
		update_icon()

/obj/item/evidencebag/proc/empty()
	stored_item = null
	w_class = initial(w_class)
	update_icon()

/obj/item/evidencebag/examine(mob/user)
	. = ..()
	if (stored_item) user.examinate(stored_item)
