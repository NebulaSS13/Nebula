/obj/screen/inventory
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.
	var/weakref/mouse_over_atom_ref

/obj/screen/inventory/handle_click(mob/user, params)
	if(name in user.get_held_item_slots())
		if(name == user.get_active_held_item_slot())
			user.attack_empty_hand()
		else
			user.select_held_item_slot(name)
	else if(user.attack_ui(slot_id))
		user.update_inhand_overlays(FALSE)
	return FALSE

/obj/screen/inventory/MouseDrop()
	. = ..()
	mouse_over_atom_ref = null
	update_icon()

// Overriding Click() here instead of using handle_click() to be thorough.
/obj/screen/inventory/Click(location, control, parameters)
	. = ..()
	mouse_over_atom_ref = null
	update_icon()

/obj/screen/inventory/MouseEntered(location, control, params)
	. = ..()
	if(!slot_id || !usr)
		return
	var/equipped_item = usr.get_active_held_item()
	if(equipped_item)
		var/new_mouse_over_atom = weakref(equipped_item)
		if(new_mouse_over_atom != mouse_over_atom_ref)
			mouse_over_atom_ref = new_mouse_over_atom
			update_icon()

/obj/screen/inventory/MouseExited(location, control, params)
	. = ..()
	if(mouse_over_atom_ref)
		mouse_over_atom_ref = null
		update_icon()

/obj/screen/inventory/rebuild_screen_overlays()

	..()

	// Validate our owner still exists.
	var/mob/owner = owner_ref?.resolve()
	if(!istype(owner) || QDELETED(owner) || !(src in owner.client?.screen))
		return

	// Mark anything we're potentially trying to equip.
	var/obj/item/mouse_over_atom = mouse_over_atom_ref?.resolve()
	if(istype(mouse_over_atom) && !QDELETED(mouse_over_atom) && !owner.get_equipped_item(slot_id))
		var/mutable_appearance/MA = new /mutable_appearance(mouse_over_atom)
		MA.layer   = HUD_ABOVE_ITEM_LAYER
		MA.plane   = HUD_PLANE
		MA.alpha   = 80
		MA.color   = mouse_over_atom.mob_can_equip(owner, slot_id, TRUE) ? COLOR_GREEN : COLOR_RED
		// We don't respect default_pixel_x or similar here because items should always be centered in their slots; defaults are for world-space.
		MA.pixel_x = 0
		MA.pixel_y = 0
		MA.pixel_w = 0
		MA.pixel_z = 0
		MA.appearance_flags |= (KEEP_TOGETHER | RESET_COLOR)
		// We need to color the entire thing, overlays and underlays included.
		for(var/image/overlay in MA.overlays)
			overlay.appearance_flags &= ~(KEEP_TOGETHER | RESET_COLOR)
		for(var/image/underlay in MA.underlays)
			underlay.appearance_flags &= ~(KEEP_TOGETHER | RESET_COLOR)
		add_overlay(MA)
	else
		mouse_over_atom_ref = null
