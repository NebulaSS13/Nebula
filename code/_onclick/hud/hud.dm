/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/mob
	var/datum/hud/hud_used

/mob/proc/InitializeHud()
	if(istype(hud_used))
		QDEL_NULL(hud_used)
		hud_used = initial(hud_used)
	if(ispath(hud_used))
		hud_used = new hud_used(src)
	refresh_lighting_master()

/datum/hud
	var/mob/mymob

	var/hud_shown           = 1         //Used for the HUD toggle (F12)
	var/inventory_shown     = TRUE      //the inventory
	var/hotkey_ui_hidden    = FALSE     //This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/default_ui_style = /decl/ui_style/midnight

	var/list/alerts

	var/list/hand_hud_objects
	var/list/swaphand_hud_objects
	var/obj/screen/intent/action_intent
	var/obj/screen/movement/move_intent
	var/obj/screen/stamina/stamina_bar

	var/list/adding = list()
	var/list/other = list()
	var/list/hud_elements = list()
	var/list/obj/screen/hotkeybuttons

	var/obj/screen/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = FALSE

/datum/hud/New(mob/owner)
	mymob = owner
	instantiate()
	..()

/datum/hud/Destroy()
	. = ..()
	stamina_bar = null
	action_intent = null
	move_intent = null
	adding = null
	other = null
	hotkeybuttons = null
	mymob = null
	QDEL_NULL_LIST(hand_hud_objects)
	QDEL_NULL_LIST(swaphand_hud_objects)

/datum/hud/proc/update_stamina()
	if(mymob && stamina_bar)
		stamina_bar.set_invisibility(INVISIBILITY_MAXIMUM)
		var/stamina = mymob.get_stamina()
		if(stamina < 100)
			stamina_bar.set_invisibility(INVISIBILITY_NONE)
			stamina_bar.icon_state = "prog_bar_[floor(stamina/5)*5][(stamina >= 5) && (stamina <= 25) ? "_fail" : null]"

/datum/hud/proc/hide_inventory()
	inventory_shown = FALSE
	hidden_inventory_update()
	persistant_inventory_update()

/datum/hud/proc/show_inventory()
	inventory_shown = TRUE
	hidden_inventory_update()
	persistant_inventory_update()

/datum/hud/proc/hidden_inventory_update()
	var/decl/species/species = mymob?.get_species()
	if(istype(species?.species_hud))
		refresh_inventory_slots(species.species_hud.hidden_slots, (inventory_shown && hud_shown))

/datum/hud/proc/persistant_inventory_update()
	var/decl/species/species = mymob?.get_species()
	if(istype(species?.species_hud))
		refresh_inventory_slots(species.species_hud.persistent_slots, hud_shown)

/datum/hud/proc/refresh_inventory_slots(var/list/checking_slots, var/show_hud)

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

/datum/hud/proc/instantiate()
	if(ismob(mymob) && mymob.client)
		FinalizeInstantiation()
		return TRUE
	return FALSE

/datum/hud/proc/FinalizeInstantiation()
	SHOULD_CALL_PARENT(TRUE)
	BuildInventoryUI()
	BuildHandsUI()
	if(mymob.client)
		mymob.client.screen = list()
		if(length(hand_hud_objects))
			mymob.client.screen |= hand_hud_objects
		if(length(swaphand_hud_objects))
			mymob.client.screen |= swaphand_hud_objects
		if(length(hud_elements))
			mymob.client.screen |= hud_elements
		if(length(adding))
			mymob.client.screen |= adding
		if(length(hotkeybuttons))
			mymob.client.screen |= hotkeybuttons
	hide_inventory()

/datum/hud/proc/get_ui_style_data()
	RETURN_TYPE(/decl/ui_style)
	. = GET_DECL(mymob?.client?.prefs?.UI_style) || GET_DECL(default_ui_style)
	if(!.)
		var/list/available_styles = get_ui_styles()
		if(length(available_styles))
			. = available_styles[1]

/datum/hud/proc/get_ui_color()
	return mymob?.client?.prefs?.UI_style_color  || COLOR_WHITE

/datum/hud/proc/get_ui_alpha()
	return mymob?.client?.prefs?.UI_style_alpha || 255

/datum/hud/proc/rebuild_hands()

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
		for(var/obj/screen/inventory/existing_box in hand_hud_objects)
			if(existing_box.slot_id == hand_tag)
				inv_box = existing_box
				break

		if(!inv_box)
			inv_box = new /obj/screen/inventory(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HANDS)
		else
			inv_box.set_ui_style(ui_style, UI_ICON_HANDS)
			inv_box.color = ui_color
			inv_box.alpha = ui_alpha

		inv_box.SetName(hand_tag)
		inv_box.icon_state = "hand_base"

		inv_box.cut_overlays()
		inv_box.add_overlay("hand_[inv_slot.hand_overlay || hand_tag]", TRUE)
		if(inv_slot.ui_label)
			inv_box.add_overlay("hand_[inv_slot.ui_label]", TRUE)
		inv_box.update_icon()

		inv_box.slot_id = hand_tag
		inv_box.appearance_flags |= KEEP_TOGETHER

		LAZYDISTINCTADD(hand_hud_objects, inv_box)

	// Clear held item boxes with no held slot.
	for(var/obj/screen/inventory/inv_box in hand_hud_objects)
		if(!(inv_box.slot_id in held_slots))
			if(mymob.client)
				mymob.client.screen -= inv_box
			LAZYREMOVE(hand_hud_objects, inv_box)
			qdel(inv_box)

	// Rebuild offsets for the hand elements.
	var/hand_y_offset = 5
	var/list/elements = hand_hud_objects?.Copy()
	while(length(elements))
		var/copy_index = min(length(elements), 2)+1
		var/list/sublist = elements.Copy(1, copy_index)
		elements.Cut(1, copy_index)
		var/obj/screen/inventory/inv_box
		if(length(sublist) == 1)
			inv_box = sublist[1]
			inv_box.screen_loc = "CENTER,BOTTOM:[hand_y_offset]"
		else
			inv_box = sublist[1]
			inv_box.screen_loc = "CENTER:-[world.icon_size/2],BOTTOM:[hand_y_offset]"
			inv_box = sublist[2]
			inv_box.screen_loc = "CENTER:[world.icon_size/2],BOTTOM:[hand_y_offset]"
		hand_y_offset += world.icon_size

	if(mymob.client && islist(hand_hud_objects) && length(hand_hud_objects))
		mymob.client.screen |= hand_hud_objects

	// Make sure all held items are on the screen and set to the correct screen loc.
	var/datum/inventory_slot/inv_slot
	for(var/obj/inv_elem in hand_hud_objects)
		inv_slot = mymob.get_inventory_slot_datum(inv_elem.name)
		if(inv_slot)
			inv_slot.ui_loc = inv_elem.screen_loc
			var/obj/item/held = inv_slot.get_equipped_item()
			if(held)
				held.screen_loc = inv_slot.ui_loc
				if(mymob.client)
					mymob.client.screen |= held // just to make sure it's visible post-login

	if(length(swaphand_hud_objects))
		var/hand_x_offset = -(world.icon_size/2)
		for(var/i = 1 to length(swaphand_hud_objects))
			var/obj/swap_elem = swaphand_hud_objects[i]
			swap_elem.screen_loc = "CENTER:[hand_x_offset],BOTTOM:[hand_y_offset]"
			if(i > 1) // first two elems share a slot
				hand_x_offset += world.icon_size
			if(mymob.client)
				mymob.client.screen |= swap_elem

/datum/hud/proc/BuildInventoryUI()

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

		inv_box = new /obj/screen/inventory(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_INVENTORY)

		var/datum/inventory_slot/inv_slot = inventory_slots[gear_slot]
		inv_box.SetName(inv_slot.slot_name)
		inv_box.slot_id =    inv_slot.slot_id
		inv_box.icon_state = inv_slot.slot_state
		inv_box.screen_loc = inv_slot.ui_loc

		if(inv_slot.slot_dir)
			inv_box.set_dir(inv_slot.slot_dir)

		if(inv_slot.can_be_hidden)
			other += inv_box
			has_hidden_gear = TRUE
		else
			adding += inv_box

	if(has_hidden_gear)
		adding += new /obj/screen/toggle(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_INVENTORY)

/datum/hud/proc/BuildHandsUI()

	var/list/held_slots = mymob.get_held_item_slots()
	if(length(held_slots) <= 0)
		return

	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	// Swap hand and quick equip screen elems.
	var/obj/screen/using = new /obj/screen/equip(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HANDS)
	adding += using
	LAZYADD(swaphand_hud_objects, using)

	if(length(held_slots) > 1)

		using = new /obj/screen/inventory/swaphand(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HANDS)
		adding += using
		LAZYADD(swaphand_hud_objects, using)
		using = new /obj/screen/inventory/swaphand/right(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HANDS)
		adding += using
		LAZYADD(swaphand_hud_objects, using)

	// Actual hand elems.
	rebuild_hands()

/mob/verb/minimize_hud(full = FALSE as null)
	set name = "Minimize Hud"
	set hidden = TRUE

	if(isnull(hud_used))
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))
		return

	if(!client || !istype(hud_used))
		return

	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		if(hud_used.adding)
			client.screen -= hud_used.adding
		if(hud_used.other)
			client.screen -= hud_used.other
		if(hud_used.hotkeybuttons)
			client.screen -= hud_used.hotkeybuttons

		//Due to some poor coding some things need special treatment:
		//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
		if(!full)
			if(LAZYLEN(hud_used.hand_hud_objects))
				client.screen += hud_used.hand_hud_objects         // we want the hands to be visible
			if(LAZYLEN(hud_used.swaphand_hud_objects))
				client.screen += hud_used.swaphand_hud_objects     // we want the hands swap thingy to be visible
			client.screen += hud_used.action_intent        // we want the intent swticher visible
			hud_used.action_intent.screen_loc = ui_acti_alt    // move this to the alternative position, where zone_select usually is.
		else
			client.screen -= healths
			client.screen -= internals
			client.screen -= gun_setting_icon

		//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
		client.screen -= zone_sel	//zone_sel is a mob variable for some reason.

	else
		hud_used.hud_shown = 1
		if(hud_used.adding)
			client.screen += hud_used.adding
		if(hud_used.other && hud_used.inventory_shown)
			client.screen += hud_used.other
		if(hud_used.hotkeybuttons && !hud_used.hotkey_ui_hidden)
			client.screen += hud_used.hotkeybuttons
		if(healths)
			client.screen |= healths
		if(internals)
			client.screen |= internals
		if(gun_setting_icon)
			client.screen |= gun_setting_icon

		hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
		client.screen += zone_sel				//This one is a special snowflake

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
	update_action_buttons()

//Similar to minimize_hud() but keeps zone_sel, gun_setting_icon, and healths.
/mob/proc/toggle_zoom_hud()
	if(!istype(hud_used))
		return
	if(!ishuman(src))
		return
	if(!client)
		return
	if(client.view != world.view)
		return

	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		if(hud_used.adding)
			client.screen -= hud_used.adding
		if(hud_used.other)
			client.screen -= hud_used.other
		if(hud_used.hotkeybuttons)
			client.screen -= hud_used.hotkeybuttons
		client.screen -= internals
		client.screen += hud_used.action_intent		//we want the intent swticher visible
	else
		hud_used.hud_shown = 1
		if(hud_used.adding)
			client.screen += hud_used.adding
		if(hud_used.other && hud_used.inventory_shown)
			client.screen += hud_used.other
		if(hud_used.hotkeybuttons && !hud_used.hotkey_ui_hidden)
			client.screen += hud_used.hotkeybuttons
		if(internals)
			client.screen |= internals
		hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
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
