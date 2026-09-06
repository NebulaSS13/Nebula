/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/mob
	var/datum/hud/hud_used

/mob/proc/get_hud_element(hud_key)
	if(!istype(hud_used))
		return FALSE
	return hud_used.get_element(hud_key)

/mob/proc/refresh_hud_element(hud_key)
	if(!istype(hud_used))
		return FALSE
	return hud_used.refresh_element(hud_key)

/mob/proc/initialize_hud()
	if(istype(hud_used))
		QDEL_NULL(hud_used)
		hud_used = initial(hud_used)
	if(ispath(hud_used))
		hud_used = new hud_used(src)
	if(istype(hud_used))
		hud_used.refresh_hud_icons()

/datum/hud
	/// A reference to our owning mob.
	VAR_PRIVATE/weakref/owner
	/// Used for the HUD toggle (F12)
	VAR_PRIVATE/hud_shown        = TRUE
	// Used for showing or hiding the equipment buttons on the left.
	VAR_PRIVATE/inventory_shown  = TRUE
	/// This is to hide the buttons that can be used via hotkeys. (hud_elements_hotkeys list of buttons)
	VAR_PRIVATE/hotkey_ui_hidden = FALSE
	/// Defines an assumed default /decl/ui_style for elements to use.
	VAR_PRIVATE/default_ui_style = DEFAULT_UI_STYLE

	/// Assoc list of current /decl/hud_element to values. Cannot be private, used by macro.
	var/list/alerts

	/// List of elements related to hand slots.
	VAR_PRIVATE/list/obj/screen/hud_elements_hands
	/// List of elements related to swapping hand slots.
	VAR_PRIVATE/list/obj/screen/hud_elements_swap
	/// List of elements related to hotkeys.
	VAR_PRIVATE/list/obj/screen/hud_elements_hotkeys
	/// List of elements that are hidden by the inventory toggle.
	VAR_PRIVATE/list/obj/screen/hud_elements_hidable
	/// List of elements that are not hidden by anything.
	VAR_PRIVATE/list/obj/screen/hud_elements_unhidable
	/// List of elements that are hidden by F12.
	VAR_PRIVATE/list/obj/screen/hud_elements_auxilliary
	/// List of elements that update icon in Life()
	VAR_PRIVATE/list/obj/screen/hud_elements_update_in_life
	/// Combined list of the above, used for qdel.
	VAR_PRIVATE/list/obj/screen/all_hud_elements

	/// List of /decl/hud_element types to use to populate this HUD on creation.
	VAR_PROTECTED/list/hud_elements_to_create = list(
		/decl/hud_element/movement,
		/decl/hud_element/stamina,
		/decl/hud_element/health,
		/decl/hud_element/internals,
		/decl/hud_element/charge,
		/decl/hud_element/zone_selector,
		/decl/hud_element/nutrition,
		/decl/hud_element/hydration,
		/decl/hud_element/upward,
		/decl/hud_element/throw_toggle,
		/decl/hud_element/maneuver,
		/decl/hud_element/drop,
		/decl/hud_element/resist,
		/decl/hud_element/intent,
		/decl/hud_element/fire,
		/decl/hud_element/oxygen,
		/decl/hud_element/toxins,
		/decl/hud_element/bodytemp,
		/decl/hud_element/pressure,
		/decl/hud_element/modifiers
	)
	/// /decl/hud_element types to be inserted into hud_elements_to_create during init.
	VAR_PROTECTED/list/additional_hud_elements
	/// /decl/hud_element types to be removed from hud_elements_to_create during init.
	VAR_PROTECTED/list/omit_hud_elements
	/// Elem type to created object dict; used to retrieve/update elements.
	VAR_PRIVATE/list/hud_elem_decl_to_object = list()

	// TODO: move these onto the HUD datum properly.
	var/action_buttons_hidden = FALSE
	var/obj/screen/action_button/hide_toggle/hide_actions_toggle

	var/const/HAND_UI_PER_ROW = 4
	var/const/HAND_UI_INITIAL_Y_OFFSET = 21

	// TODO: declify these.
	VAR_PROTECTED/gun_mode_toggle_type
	VAR_PRIVATE/obj/screen/gun/mode/gun_mode_toggle
	VAR_PRIVATE/obj/screen/gun/move/gun_move_toggle
	VAR_PRIVATE/obj/screen/gun/item/gun_item_use_toggle
	VAR_PRIVATE/obj/screen/gun/radio/gun_radio_use_toggle

/datum/hud/New(mob/_owner)
	if(istype(_owner))
		owner = weakref(_owner)
		instantiate(_owner)
	..()

/datum/hud/Destroy()
	. = ..()

	LAZYCLEARLIST(hud_elements_hands)
	LAZYCLEARLIST(hud_elements_swap)
	LAZYCLEARLIST(hud_elements_hotkeys)
	LAZYCLEARLIST(hud_elements_hidable)
	LAZYCLEARLIST(hud_elements_unhidable)
	LAZYCLEARLIST(hud_elements_auxilliary)
	LAZYCLEARLIST(hud_elem_decl_to_object)
	QDEL_NULL_LIST(all_hud_elements)

	var/mob/mymob = owner?.resolve()
	if(istype(mymob))
		if(mymob.hud_used == src)
			mymob.hud_used = null
	QDEL_NULL(owner)

/datum/hud/proc/is_hud_shown()
	return hud_shown

/datum/hud/proc/get_element(hud_key)
	return hud_elem_decl_to_object[hud_key]

/datum/hud/proc/refresh_element(hud_key)
	var/obj/screen/elem = get_element(hud_key)
	return elem?.update_icon() || FALSE

/datum/hud/proc/refresh_hud_icons()
	var/mob/mymob = owner?.resolve()
	if(istype(mymob) && mymob.client)
		for(var/obj/screen/elem in mymob.client.screen)
			elem.queue_icon_update()

/datum/hud/proc/is_inventory_shown()
	return inventory_shown

/datum/hud/proc/hide_inventory()
	inventory_shown = FALSE
	if(LAZYLEN(hud_elements_hidable))
		var/mob/mymob = owner?.resolve()
		if(istype(mymob) && mymob.client)
			mymob.client.screen -= hud_elements_hidable
	hidden_inventory_update()
	persistent_inventory_update()

/datum/hud/proc/show_inventory()
	inventory_shown = TRUE
	if(LAZYLEN(hud_elements_hidable))
		var/mob/mymob = owner?.resolve()
		if(istype(mymob) && mymob.client)
			mymob.client.screen += hud_elements_hidable
	hidden_inventory_update()
	persistent_inventory_update()

/datum/hud/proc/hidden_inventory_update()
	var/mob/mymob = owner?.resolve()
	var/decl/species/species = istype(mymob) && mymob.get_species()
	if(istype(species?.species_hud))
		refresh_inventory_slots(species.species_hud.hidden_slots, (inventory_shown && hud_shown))

/datum/hud/proc/persistent_inventory_update()
	var/mob/mymob = owner?.resolve()
	var/decl/species/species = istype(mymob) && mymob.get_species()
	if(istype(species?.species_hud))
		refresh_inventory_slots(species.species_hud.persistent_slots, hud_shown)

/datum/hud/proc/refresh_inventory_slots(var/list/checking_slots, var/show_hud)

	var/mob/mymob = owner?.resolve()
	if(!istype(mymob))
		return FALSE

	for(var/slot in checking_slots)

		var/datum/inventory_slot/inv_slot = mymob.get_inventory_slot_datum(slot)
		if(!istype(inv_slot))
			continue

		// Check if we're even wearing anything in that slot.
		var/obj/item/gear = inv_slot.get_equipped_item()
		if(!istype(gear))
			continue

		// We're not showing anything, hide it.
		gear.reconsider_client_screen_presence(mymob?.client, slot)
		if(!show_hud)
			inv_slot.hide_slot()
		else
			inv_slot.show_slot()

	return TRUE

/datum/hud/proc/instantiate(mob/_owner)
	if(ismob(_owner) && _owner.client)
		finalize_instantiation(_owner)
		refresh_hud_icons()
		return TRUE
	return FALSE

/datum/hud/proc/handle_life_hud_update()

	var/mob/mymob = owner?.resolve()
	if(!istype(mymob))
		return FALSE

	if(mymob.buckled || mymob.restrained())
		mymob.add_mob_modifier(/decl/mob_modifier/restrained, source = mymob)
	else
		mymob.remove_mob_modifier(/decl/mob_modifier/restrained, source = mymob)

	if(mymob.current_posture?.prone)
		mymob.add_mob_modifier(/decl/mob_modifier/lying, source = mymob)
	else
		mymob.remove_mob_modifier(/decl/mob_modifier/lying, source = mymob)

	for(var/obj/screen/elem as anything in hud_elements_update_in_life)
		elem.update_icon()
	return TRUE

/datum/hud/proc/finalize_instantiation(mob/_owner)

	SHOULD_CALL_PARENT(TRUE)

	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color               = get_ui_color()
	var/ui_alpha               = get_ui_alpha()

	LAZYINITLIST(hud_elements_to_create)
	if(length(additional_hud_elements))
		hud_elements_to_create |= additional_hud_elements
	if(length(omit_hud_elements))
		hud_elements_to_create -= omit_hud_elements
	UNSETEMPTY(hud_elements_to_create)

	for(var/hud_elem_type in hud_elements_to_create)
		var/decl/hud_element/hud_element = GET_DECL(hud_elem_type)
		create_and_register_element(hud_element, ui_style, ui_color, ui_alpha)

	//Handle the gun settings buttons
	if(!gun_mode_toggle && gun_mode_toggle_type)
		gun_mode_toggle = new gun_mode_toggle_type(null, _owner, ui_style, ui_color, ui_alpha, HUD_FIRE_INTENT)
		LAZYADD(hud_elements_auxilliary, gun_mode_toggle)
		gun_item_use_toggle  = new(null, _owner, ui_style, ui_color, ui_alpha, HUD_FIRE_INTENT)
		gun_move_toggle      = new(null, _owner, ui_style, ui_color, ui_alpha, HUD_FIRE_INTENT)
		gun_radio_use_toggle = new(null, _owner, ui_style, ui_color, ui_alpha, HUD_FIRE_INTENT)

	build_inventory_ui()
	build_hands_ui()

	LAZYINITLIST(all_hud_elements)
	if(LAZYLEN(hud_elements_hands))
		all_hud_elements |= hud_elements_hands
	if(LAZYLEN(hud_elements_swap))
		all_hud_elements |= hud_elements_swap
	if(LAZYLEN(hud_elements_hotkeys))
		all_hud_elements |= hud_elements_hotkeys
	if(LAZYLEN(hud_elements_hidable))
		all_hud_elements |= hud_elements_hidable
	if(LAZYLEN(hud_elements_unhidable))
		all_hud_elements |= hud_elements_unhidable
	if(LAZYLEN(hud_elements_auxilliary))
		all_hud_elements |= hud_elements_auxilliary
	UNSETEMPTY(all_hud_elements)

	if(_owner.client)
		_owner.client.screen = list()
		if(LAZYLEN(all_hud_elements))
			_owner.client.screen |= all_hud_elements

	hide_inventory()

/datum/hud/proc/get_ui_style_data()
	RETURN_TYPE(/decl/ui_style)
	var/mob/mymob = owner?.resolve()
	. = (istype(mymob) && GET_DECL(mymob.client?.prefs?.UI_style)) || GET_DECL(default_ui_style)
	if(!.)
		var/list/available_styles = get_ui_styles()
		if(length(available_styles))
			. = available_styles[1]

/datum/hud/proc/get_ui_color()
	var/decl/ui_style/ui_style = get_ui_style_data()
	if(!ui_style?.use_ui_color)
		return COLOR_WHITE
	var/mob/mymob = owner?.resolve()
	return (istype(mymob) && mymob.client?.prefs?.UI_style_color)  || COLOR_WHITE

/datum/hud/proc/get_ui_alpha()
	var/mob/mymob = owner?.resolve()
	return (istype(mymob) && mymob.client?.prefs?.UI_style_alpha) || 255

/datum/hud/proc/rebuild_hands()

	var/mob/mymob = owner?.resolve()
	if(!istype(mymob))
		return FALSE

	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	// Build held item boxes for missing slots.
	var/list/held_slots = mymob.get_held_item_slots()

	// Sort our slots for display.
	var/list/gripper_datums = list()
	for(var/hand_tag in held_slots)
		gripper_datums += mymob.get_inventory_slot_datum(hand_tag)
	gripper_datums = sortTim(gripper_datums, /proc/cmp_gripper_asc)

	for(var/datum/inventory_slot/gripper/inv_slot in gripper_datums)

		// Re-order the held slot list so it aligns with the display order.
		var/hand_tag = inv_slot.slot_id
		held_slots -= hand_tag
		held_slots += hand_tag

		var/obj/screen/inventory/inv_box
		for(var/obj/screen/inventory/existing_box in hud_elements_hands)
			if(existing_box.slot_id == hand_tag)
				inv_box = existing_box
				break

		if(!inv_box)
			inv_box = new /obj/screen/inventory/hand(null, mymob, ui_style, ui_color, ui_alpha, HUD_HANDS)
		else
			inv_box.set_ui_style(ui_style, HUD_HANDS)
			inv_box.color = ui_color
			inv_box.alpha = ui_alpha

		LAZYDISTINCTADD(hud_elements_hands, inv_box)

		inv_box.SetName(hand_tag)
		inv_box.slot_id = hand_tag
		inv_box.update_icon()

	// Clear held item boxes with no held slot.
	for(var/obj/screen/inventory/inv_box in hud_elements_hands)
		if(!(inv_box.slot_id in held_slots))
			if(mymob.client)
				mymob.client.screen -= inv_box
			LAZYREMOVE(hud_elements_hands, inv_box)
			qdel(inv_box)

	// Rebuild offsets for the hand elements.
	var/hand_y_offset = HAND_UI_INITIAL_Y_OFFSET
	var/list/elements = hud_elements_hands?.Copy()
	while(length(elements))
		var/copy_index = min(length(elements), HAND_UI_PER_ROW)+1
		var/list/sublist = elements.Copy(1, copy_index)
		elements.Cut(1, copy_index)
		var/hand_x_offset = (world.icon_size/2) * (1 - length(sublist))
		for(var/obj/screen/inventory/inv_box in sublist)
			inv_box.screen_loc = "CENTER:[hand_x_offset],BOTTOM:[hand_y_offset]"
			hand_x_offset += world.icon_size
		hand_y_offset += world.icon_size

	if(mymob.client && islist(hud_elements_hands) && length(hud_elements_hands))
		mymob.client.screen |= hud_elements_hands

	// Make sure all held items are on the screen and set to the correct screen loc.
	var/datum/inventory_slot/inv_slot
	for(var/obj/inv_elem in hud_elements_hands)
		inv_slot = mymob.get_inventory_slot_datum(inv_elem.name)
		if(inv_slot)
			inv_slot.ui_loc = inv_elem.screen_loc
			var/obj/item/held = inv_slot.get_equipped_item()
			if(held)
				held.screen_loc = inv_slot.ui_loc
				if(mymob.client)
					mymob.client.screen |= held // just to make sure it's visible post-login

	if(length(hud_elements_swap))
		var/hand_x_offset = -(world.icon_size/2)
		for(var/i = 1 to length(hud_elements_swap))
			var/obj/swap_elem = hud_elements_swap[i]
			swap_elem.screen_loc = "CENTER:[hand_x_offset],BOTTOM:[hand_y_offset]"
			if(i > 1) // first two elems share a slot
				hand_x_offset += world.icon_size
			if(mymob.client)
				mymob.client.screen |= swap_elem

	refresh_element(HUD_STAMINA)
	update_hand_elements()

	return TRUE

/datum/hud/proc/build_inventory_ui()

	var/mob/mymob = owner?.resolve()
	if(!istype(mymob))
		return FALSE

	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	var/has_hidden_gear = FALSE

	// Draw the various inventory equipment slots.
	var/obj/screen/inventory/inv_box
	var/list/held_slots =      mymob.get_held_item_slots()
	var/list/inventory_slots = mymob.get_inventory_slots()
	for(var/gear_slot in inventory_slots)

		if(gear_slot in held_slots)
			continue

		inv_box = new /obj/screen/inventory(null, mymob, ui_style, ui_color, ui_alpha, HUD_INVENTORY)

		var/datum/inventory_slot/inv_slot = inventory_slots[gear_slot]
		inv_box.SetName(inv_slot.slot_name)
		inv_box.slot_id =    inv_slot.slot_id
		inv_box.icon_state = inv_slot.slot_state
		inv_box.screen_loc = inv_slot.ui_loc

		if(inv_slot.slot_dir)
			inv_box.set_dir(inv_slot.slot_dir)

		if(inv_slot.can_be_hidden)
			LAZYDISTINCTADD(hud_elements_hidable, inv_box)
			has_hidden_gear = TRUE
		else
			hud_elements_auxilliary += inv_box

	if(has_hidden_gear)
		hud_elements_auxilliary += new /obj/screen/toggle(null, mymob, ui_style, ui_color, ui_alpha, HUD_INVENTORY)

	return TRUE

/datum/hud/proc/build_hands_ui()

	var/mob/mymob = owner?.resolve()
	if(!istype(mymob))
		return FALSE

	var/list/held_slots = mymob.get_held_item_slots()
	if(length(held_slots) <= 0)
		return FALSE

	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	// Swap hand and quick equip screen elems.
	var/obj/screen/using = new /obj/screen/equip(null, mymob, ui_style, ui_color, ui_alpha, HUD_HANDS)
	LAZYADD(hud_elements_swap, using)
	if(length(held_slots) > 1)

		using = new /obj/screen/inventory/swaphand(null, mymob, ui_style, ui_color, ui_alpha, HUD_HANDS)
		LAZYADD(hud_elements_swap, using)
		using = new /obj/screen/inventory/swaphand/right(null, mymob, ui_style, ui_color, ui_alpha, HUD_HANDS)
		LAZYADD(hud_elements_swap, using)

	// Actual hand elems.
	rebuild_hands()
	return TRUE

/datum/hud/proc/toggle_show_inventory()
	if(inventory_shown)
		hide_inventory()
	else
		show_inventory()
	return TRUE

/datum/hud/proc/toggle_action_buttons_hidden()
	action_buttons_hidden = !action_buttons_hidden
	return action_buttons_hidden

/datum/hud/proc/toggle_minimize(var/full)
	hud_shown = !hud_shown
	var/mob/mymob = owner?.resolve()
	if(istype(mymob) && mymob.client)
		if(hud_shown)
			if(LAZYLEN(hud_elements_auxilliary))
				mymob.client.screen |= hud_elements_auxilliary
			if(LAZYLEN(hud_elements_hidable) && inventory_shown)
				mymob.client.screen |= hud_elements_hidable
			if(LAZYLEN(hud_elements_hotkeys) && !hotkey_ui_hidden)
				mymob.client.screen |= hud_elements_hotkeys
		else
			if(hud_elements_auxilliary)
				mymob.client.screen -= hud_elements_auxilliary
			if(hud_elements_hidable)
				mymob.client.screen -= hud_elements_hidable
			if(hud_elements_hotkeys)
				mymob.client.screen -= hud_elements_hotkeys
			if(!full)
				if(LAZYLEN(hud_elements_hands))
					mymob.client.screen += hud_elements_hands         // we want the hands to be visible
				if(LAZYLEN(hud_elements_swap))
					mymob.client.screen += hud_elements_swap     // we want the hands swap thingy to be visible

	hidden_inventory_update()
	persistent_inventory_update()
	return TRUE

/datum/hud/proc/toggle_zoom_hud()
	hud_shown = !hud_shown
	var/mob/mymob = owner?.resolve()
	if(istype(mymob) && mymob.client)
		if(hud_shown)
			if(LAZYLEN(hud_elements_auxilliary))
				mymob.client.screen += hud_elements_auxilliary
			if(LAZYLEN(hud_elements_hidable) && inventory_shown)
				mymob.client.screen += hud_elements_hidable
			if(LAZYLEN(hud_elements_hotkeys) && !hotkey_ui_hidden)
				mymob.client.screen += hud_elements_hotkeys
		else
			if(LAZYLEN(hud_elements_auxilliary))
				mymob.client.screen -= hud_elements_auxilliary
			if(LAZYLEN(hud_elements_hidable))
				mymob.client.screen -= hud_elements_hidable
			if(LAZYLEN(hud_elements_hotkeys))
				mymob.client.screen -= hud_elements_hotkeys

	hidden_inventory_update()
	persistent_inventory_update()

/datum/hud/proc/toggle_hotkeys()
	hotkey_ui_hidden = !hotkey_ui_hidden
	var/mob/mymob = owner?.resolve()
	if(istype(mymob) && mymob.client)
		if(hotkey_ui_hidden)
			mymob.client.screen -= hud_elements_hotkeys
		else
			mymob.client.screen += hud_elements_hotkeys

/mob/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."
	if(!istype(hud_used))
		return
	hud_used.toggle_hotkeys()

/mob/verb/minimize_hud(full = FALSE as null)
	set name = "Minimize Hud"
	set hidden = TRUE
	if(isnull(hud_used))
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))
		return
	if(!client || !istype(hud_used))
		return
	hud_used.toggle_minimize(full)
	update_action_buttons()

//Similar to minimize_hud() but keeps zone_selector, gun_setting_itoggle, and health_warning.
/mob/proc/toggle_zoom_hud()
	if(!istype(hud_used))
		return
	if(!ishuman(src))
		return
	if(!client)
		return
	if(client.view != world.view)
		return

	hud_used.toggle_zoom_hud()
	update_action_buttons()

/client/proc/reset_click_catchers()

	var/xmin = -(round(last_view_x_dim*0.5))
	var/xmax = last_view_x_dim - abs(xmin)
	var/ymin = -(round(last_view_y_dim*0.5))
	var/ymax = last_view_y_dim - abs(ymin)

	var/list/click_catchers = get_click_catchers()
	for(var/obj/screen/click_catcher/catcher in click_catchers)
		if(catcher.x_offset <= xmin || catcher.x_offset >= xmax || catcher.y_offset <= ymin || catcher.y_offset >= ymax)
			screen -= catcher
		else
			screen |= catcher

/mob/proc/add_click_catcher()
	client.reset_click_catchers()

/mob/new_player/add_click_catcher()
	return

//These are called by the on-screen buttons, adjusting what the victim can and cannot do.
/datum/hud/proc/add_gun_icons()
	// This can runtime if someone manages to throw a gun out of their hand before the proc is called.
	if(!gun_item_use_toggle)
		return TRUE
	var/mob/mymob = owner?.resolve()
	if(istype(mymob) && mymob.client)
		mymob.client.screen |= gun_item_use_toggle
		mymob.client.screen |= gun_move_toggle
		mymob.client.screen |= gun_radio_use_toggle

/datum/hud/proc/remove_gun_icons()
	var/mob/mymob = owner?.resolve()
	if(istype(mymob) && mymob.client)
		mymob.client.screen -= gun_item_use_toggle
		mymob.client.screen -= gun_move_toggle
		mymob.client.screen -= gun_radio_use_toggle

/datum/hud/proc/update_hand_elements()
	for(var/atom/hand as anything in hud_elements_hands)
		hand.update_icon()


/datum/hud/proc/update_gun_mode_icons(target_permissions)
	if(gun_move_toggle)
		if(!(target_permissions & TARGET_CAN_MOVE))
			gun_move_toggle.SetName("Allow Movement")
		else
			gun_move_toggle.SetName("Disallow Movement")
		gun_move_toggle.update_icon()
	if(gun_item_use_toggle)
		if(!(target_permissions & TARGET_CAN_CLICK))
			gun_item_use_toggle.SetName("Allow Item Use")
		else
			gun_item_use_toggle.SetName("Disallow Item Use")
		gun_item_use_toggle.update_icon()
	if(gun_radio_use_toggle)
		if(!(target_permissions & TARGET_CAN_RADIO))
			gun_radio_use_toggle.SetName("Allow Radio Use")
		else
			gun_radio_use_toggle.SetName("Disallow Radio Use")
		gun_radio_use_toggle.update_icon()

/datum/hud/proc/create_and_register_element(decl/hud_element/ui_elem, decl/ui_style/ui_style, ui_color, ui_alpha)

	var/mob/mymob = owner?.resolve()
	if(!istype(mymob) || !istype(ui_elem) || !ui_elem.elem_type)
		return FALSE

	var/obj/screen/elem = new ui_elem.elem_type(null, mymob, ui_style, ui_color, ui_alpha, ui_elem.elem_reference_type)
	if(ui_elem.elem_is_hotkey)
		LAZYDISTINCTADD(hud_elements_hotkeys, elem)
	else if(ui_elem.elem_is_auxilliary)
		LAZYDISTINCTADD(hud_elements_auxilliary, elem)
	else if(ui_elem.elem_is_hidable)
		LAZYDISTINCTADD(hud_elements_hidable, elem)
	else
		LAZYDISTINCTADD(hud_elements_unhidable, elem)
	if(ui_elem.elem_updates_in_life)
		LAZYDISTINCTADD(hud_elements_update_in_life, elem)
	hud_elem_decl_to_object[ui_elem.elem_reference_type] = elem
	return elem
