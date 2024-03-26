/obj/screen/inventory
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

/obj/screen/inventory/on_update_icon()

	cut_overlays()

	// Validate our owner still exists.
	var/mob/owner = owner_ref?.resolve()
	if(!istype(owner) || QDELETED(owner) || !(src in owner.client?.screen))
		return

	// Mark our selected hand.
	if(owner.get_active_held_item_slot() == slot_id)
		add_overlay("hand_selected")

	// Mark anything we're potentially trying to equip.
	var/obj/item/mouse_over_atom = mouse_over_atom_ref?.resolve()
	if(istype(mouse_over_atom) && !QDELETED(mouse_over_atom) && !usr.get_equipped_item(slot_id))
		var/mutable_appearance/MA = new /mutable_appearance(mouse_over_atom)
		MA.layer   = HUD_ABOVE_ITEM_LAYER
		MA.plane   = HUD_PLANE
		MA.alpha   = 80
		MA.color   = mouse_over_atom.mob_can_equip(owner, slot_id, TRUE) ? COLOR_GREEN : COLOR_RED
		MA.pixel_x = mouse_over_atom.default_pixel_x
		MA.pixel_y = mouse_over_atom.default_pixel_y
		MA.pixel_w = mouse_over_atom.default_pixel_w
		MA.pixel_z = mouse_over_atom.default_pixel_z
		add_overlay(MA)
	else
		mouse_over_atom_ref = null

	// UI needs to be responsive so avoid the subsecond update delay.
	compile_overlays()
