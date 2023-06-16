/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/
/mob
	var/datum/hud/hud_used

/mob/proc/InitializeHud()
	if(ispath(hud_used))
		hud_used = new hud_used(src)
	else if(istype(hud_used))
		hud_used.mymob = src // Probably unnecessary.
		hud_used.refresh_client_hud()
	refresh_lighting_master()

/datum/hud
	var/mob/mymob

	var/hud_shown           = 1         //Used for the HUD toggle (F12)
	var/inventory_shown     = TRUE      //the inventory

	/// A assoc lazylist of hud elements by category type
	var/list/hud_elements_by_category
	/// A assoc lazylist of hud element types to elements that need updating in Life()
	var/list/updating_hud_elements
	/// A linear list of types to populate the HUD with
	var/list/hud_elements = list(
		/decl/hud_element/health,
		/decl/hud_element/condition/bodytemp,
		/decl/hud_element/zone_selector,
		/decl/hud_element/move_intent,
		/decl/hud_element/action_intent,
		/decl/hud_element/condition/pressure,
		/decl/hud_element/condition/fire,
		/decl/hud_element/condition/toxins,
		/decl/hud_element/condition/oxygen,
		/decl/hud_element/condition/nutrition,
		/decl/hud_element/condition/hydration,
		/decl/hud_element/stamina_bar,
		/decl/hud_element/drop,
		/decl/hud_element/resist,
		/decl/hud_element/throwing,
		/decl/hud_element/up_hint,
		/decl/hud_element/pain,
		/decl/hud_element/internals,
		/decl/hud_element/gun_mode,
		/decl/hud_element/gun_flag_item,
		/decl/hud_element/gun_flag_move,
		/decl/hud_element/gun_flag_radio
	)
	var/health_hud_type = /decl/hud_element/health
	var/list/alerts

	/// Whether or not the hotkey UI has been hidden.
	var/hotkey_ui_hidden    = FALSE
	/// Linear list of hotkey UI elements.
	var/list/obj/screen/hotkey_hud_elements  = list()
	var/list/obj/screen/misc_hud_elements    = list()
	var/list/obj/screen/hidable_hud_elements = list()

	var/list/hand_hud_objects
	var/list/swaphand_hud_objects

	var/obj/screen/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = FALSE

/datum/hud/New(mob/owner)
	mymob = owner
	instantiate()
	..()

/datum/hud/proc/clear_client_hud()
	if(!mymob?.client)
		return
	mymob.client.screen -= hand_hud_objects
	mymob.client.screen -= swaphand_hud_objects
	mymob.client.screen -= misc_hud_elements
	mymob.client.screen -= hidable_hud_elements
	mymob.client.screen -= hotkey_hud_elements

/datum/hud/proc/populate_client_hud()
	if(!mymob?.client)
		return
	if(length(hand_hud_objects))
		mymob.client.screen |= hand_hud_objects
	if(length(swaphand_hud_objects))
		mymob.client.screen |= swaphand_hud_objects
	if(length(misc_hud_elements))
		mymob.client.screen |= misc_hud_elements
	if(length(hidable_hud_elements))
		mymob.client.screen |= hidable_hud_elements
	if(length(hotkey_hud_elements))
		mymob.client.screen |= hotkey_hud_elements

/datum/hud/Destroy()
	. = ..()

	clear_client_hud()

	mymob = null
	hud_elements = null
	hud_elements_by_category = null
	updating_hud_elements = null

	QDEL_NULL_LIST(misc_hud_elements)
	QDEL_NULL_LIST(hidable_hud_elements)
	QDEL_NULL_LIST(hotkey_hud_elements)
	QDEL_NULL_LIST(hand_hud_objects)
	QDEL_NULL_LIST(swaphand_hud_objects)

/mob/proc/get_hud_element(var/hud_elem_type)
	if(istype(hud_used))
		return hud_used.get_element(hud_elem_type)

/datum/hud/proc/get_element(var/hud_elem_type)
	return LAZYACCESS(hud_elements_by_category, hud_elem_type)

/datum/hud/proc/update_stamina()
	var/obj/screen/stamina/stamina_bar = get_element(/decl/hud_element/stamina_bar)
	if(istype(stamina_bar))
		stamina_bar.invisibility = INVISIBILITY_MAXIMUM
		var/stamina = mymob.get_stamina()
		if(stamina < 100)
			stamina_bar.invisibility = 0
			stamina_bar.icon_state = "prog_bar_[FLOOR(stamina/5)*5][(stamina >= 5) && (stamina <= 25) ? "_fail" : null]"

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
	if(species?.hud)
		refresh_inventory_slots(species.hud.hidden_slots, (inventory_shown && hud_shown))

/datum/hud/proc/persistant_inventory_update()
	var/decl/species/species = mymob?.get_species()
	if(species?.hud)
		refresh_inventory_slots(species.hud.persistent_slots, hud_shown)

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

	for(var/elem_type in hud_elements)
		var/decl/hud_element/elem_data = GET_DECL(elem_type)
		var/obj/screen/elem = elem_data.create_screen_object(src)
		if(QDELETED(elem))
			hud_elements -= elem_type
			continue
		hud_elements[elem_type] = elem
		if(elem_data.update_in_life)
			LAZYSET(updating_hud_elements, elem_type, elem)
		if(elem_data.hud_element_category)
			LAZYSET(hud_elements_by_category, elem_data.hud_element_category, elem)

	build_inventory_ui()
	build_hands_ui()
	refresh_client_hud()

/datum/hud/proc/update_health_hud()
	if(!health_hud_type)
		return
	var/obj/screen/elem = LAZYACCESS(hud_elements, health_hud_type)
	if(!elem)
		return
	var/decl/hud_element/elem_data = GET_DECL(health_hud_type)
	elem_data.refresh_screen_object(src, elem)

/datum/hud/proc/refresh_client_hud()
	if(mymob?.client)
		mymob.client.screen.Cut()

	populate_client_hud()
	hide_inventory()
	refresh_ability_hud()

/datum/hud/proc/get_ui_style()
	return ui_style2icon(mymob?.client?.prefs?.UI_style) || 'icons/mob/screen/white.dmi'

/datum/hud/proc/get_ui_color()
	return mymob?.client?.prefs?.UI_style_color  || COLOR_WHITE

/datum/hud/proc/get_ui_alpha()
	return mymob?.client?.prefs?.UI_style_alpha || 255

/datum/hud/proc/rebuild_hands()

	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	// Build held item boxes for missing slots.
	var/list/held_slots = mymob.get_held_item_slots()
	for(var/hand_tag in held_slots)
		var/obj/screen/inventory/inv_box
		for(var/obj/screen/inventory/existing_box in hand_hud_objects)
			if(existing_box.slot_id == hand_tag)
				inv_box = existing_box
				break
		if(!inv_box)
			inv_box = new /obj/screen/inventory()
		var/datum/inventory_slot/inv_slot = mymob.get_inventory_slot_datum(hand_tag)
		inv_box.SetName(hand_tag)
		inv_box.icon = ui_style
		inv_box.icon_state = "hand_base"

		inv_box.cut_overlays()
		inv_box.add_overlay("hand_[hand_tag]")
		if(inv_slot.ui_label)
			inv_box.add_overlay("hand_[inv_slot.ui_label]")
		if(mymob.get_active_held_item_slot() == hand_tag)
			inv_box.add_overlay("hand_selected")
		inv_box.compile_overlays()

		inv_box.slot_id = hand_tag
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
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
		if(mymob.client)
			mymob.client.screen |= inv_box

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

	var/hand_x_offset = -(world.icon_size/2)
	for(var/i = 1 to length(swaphand_hud_objects))
		var/obj/swap_elem = swaphand_hud_objects[i]
		swap_elem.screen_loc = "CENTER:[hand_x_offset],BOTTOM:[hand_y_offset]"
		if(i > 1) // first two elems share a slot
			hand_x_offset += world.icon_size
		if(mymob.client)
			mymob.client.screen |= swap_elem

/datum/hud/proc/build_inventory_ui()

	var/ui_style = get_ui_style()
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

		inv_box = new /obj/screen/inventory()
		inv_box.icon =  ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/datum/inventory_slot/inv_slot = inventory_slots[gear_slot]
		inv_box.SetName(inv_slot.slot_name)
		inv_box.slot_id =    inv_slot.slot_id
		inv_box.icon_state = inv_slot.slot_state
		inv_box.screen_loc = inv_slot.ui_loc

		if(inv_slot.slot_dir)
			inv_box.set_dir(inv_slot.slot_dir)

		if(inv_slot.can_be_hidden)
			hidable_hud_elements += inv_box
			has_hidden_gear = TRUE
		else
			misc_hud_elements += inv_box

	if(has_hidden_gear)
		var/obj/screen/using = new /obj/screen
		using.SetName("toggle")
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.color = ui_color
		using.alpha = ui_alpha
		misc_hud_elements += using

/datum/hud/proc/build_hands_ui()

	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	var/obj/screen/using

	// Swap hand and quick equip screen elems.
	using = new /obj/screen
	using.SetName("equip")
	using.icon = ui_style
	using.icon_state = "act_equip"
	using.color = ui_color
	using.alpha = ui_alpha
	misc_hud_elements += using
	LAZYADD(swaphand_hud_objects, using)

	var/list/held_slots = mymob.get_held_item_slots()
	if(length(held_slots) > 1)

		using = new /obj/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand1"
		using.color = ui_color
		using.alpha = ui_alpha
		misc_hud_elements += using
		LAZYADD(swaphand_hud_objects, using)

		using = new /obj/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand2"
		using.color = ui_color
		using.alpha = ui_alpha
		misc_hud_elements += using
		LAZYADD(swaphand_hud_objects, using)

	// Actual hand elems.
	rebuild_hands()

/mob/verb/minimize_hud_verb()
	set name = "Minimize Hud"
	set hidden = TRUE
	set category = "OOC"
	minimize_hud()

/mob/proc/minimize_hud(var/zoom = FALSE)

	if(!istype(hud_used))
		return

	if(!client || client.view != world.view || !hud_used)
		return

	var/obj/screen/action_intent = get_hud_element(/decl/hud_element/action_intent)
	if(hud_used.hud_shown)
		client.screen -= hud_used.misc_hud_elements
		client.screen -= hud_used.hidable_hud_elements
		client.screen -= hud_used.hotkey_hud_elements
		if(action_intent)
			action_intent.screen_loc = ui_acti_alt         // move this to the alternative position, where zone_select usually is.
	else
		if(length(hud_used.misc_hud_elements))
			client.screen |= hud_used.misc_hud_elements
		if(hud_used.inventory_shown && length(hud_used.hidable_hud_elements))
			client.screen |= hud_used.hidable_hud_elements
		if(!hud_used.hotkey_ui_hidden && length(hud_used.hotkey_hud_elements))
			client.screen |= hud_used.hotkey_hud_elements
		if(action_intent)
			action_intent.screen_loc = ui_acti //Restore intent selection to the original position

	// We always want to show our hands.
	if(LAZYLEN(hud_used.hand_hud_objects))
		client.screen |= hud_used.hand_hud_objects
	if(LAZYLEN(hud_used.swaphand_hud_objects))
		client.screen |= hud_used.swaphand_hud_objects

	hud_used.hud_shown = !hud_used.hud_shown
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

/mob/proc/reset_click_catchers()
	client.reset_click_catchers()

/mob/new_player/reset_click_catchers()
	return

/datum/hud/proc/update_icons()
	if(!length(updating_hud_elements) || QDELETED(mymob))
		return

	var/obj/screen/ability_master/ability_master = get_element(/decl/hud_element/ability_master)
	if(ability_master)
		ability_master.update_spells(0)

	var/datum/gas_mixture/environment = mymob.loc?.return_air()
	for(var/elem_type in updating_hud_elements)
		var/decl/hud_element/hud_elem_data = GET_DECL(elem_type)
		hud_elem_data.refresh_screen_object(src, hud_elements[elem_type], environment)

/datum/hud/proc/hide_ability_hud()
	var/ui_alpha = get_ui_alpha()
	for(var/elem_type in hud_elements)
		var/decl/hud_element/hud_elem = GET_DECL(elem_type)
		if(hud_elem.hidable)
			var/obj/thing = hud_elements[elem_type]
			if(istype(thing))
				thing.alpha = hud_elem.apply_hud_alpha ? ui_alpha : initial(thing.alpha)
				thing.invisibility = initial(thing.invisibility)

/datum/hud/proc/show_ability_hud()
	for(var/elem_type in hud_elements)
		var/decl/hud_element/hud_elem = GET_DECL(elem_type)
		if(hud_elem.hidable)
			var/obj/thing = hud_elements[elem_type]
			if(istype(thing))
				thing.alpha = 0
				thing.invisibility = INVISIBILITY_MAXIMUM

/datum/hud/proc/should_show_ability_hud()
	return TRUE

/datum/hud/proc/refresh_ability_hud()

	var/obj/screen/ability_master/ability_master = get_element(/decl/hud_element/ability_master)
	if(ability_master)
		ability_master.update_abilities(TRUE, mymob)
		ability_master.toggle_open(1)
		ability_master.synch_spells_to_mind(mymob?.mind)

	if(should_show_ability_hud())
		show_ability_hud()
	else
		hide_ability_hud()

/datum/hud/proc/reset_hud_callback()
	if(mymob.is_on_special_ability_cooldown())
		return
	var/ui_color = get_ui_color()
	for(var/elem_type in hud_elements)
		var/decl/hud_element/hud_elem = GET_DECL(elem_type)
		if(hud_elem.apply_color_on_cooldown)
			var/obj/thing = hud_elements[elem_type]
			if(istype(thing))
				thing.color = hud_elem.apply_hud_color ? ui_color : initial(thing.color)

/datum/hud/proc/set_hud_cooldown(var/time, var/cooldown_color)
	var/colored_a_thing = FALSE
	for(var/elem_type in hud_elements)
		var/decl/hud_element/hud_elem = GET_DECL(elem_type)
		if(hud_elem.apply_color_on_cooldown)
			var/obj/thing = hud_elements[elem_type]
			if(istype(thing))
				colored_a_thing = TRUE
				thing.color = cooldown_color
	if(colored_a_thing)
		addtimer(CALLBACK(src, /datum/hud/proc/reset_hud_callback), time+1)

/datum/hud/proc/refresh_stat_panel()
	var/obj/screen/ability_master/ability_master = mymob.get_hud_element(/decl/hud_element/ability_master)
	if(!ability_master?.spell_objects)
		return
	for(var/obj/screen/ability/spell/screen in ability_master.spell_objects)
		var/spell/S = screen.spell
		if((!S.connected_button) || !statpanel(S.panel))
			continue //Not showing the noclothes spell
		switch(S.charge_type)
			if(Sp_RECHARGE)
				statpanel(S.panel,"[S.charge_counter/10.0]/[S.charge_max/10]",S.connected_button)
			if(Sp_CHARGES)
				statpanel(S.panel,"[S.charge_counter]/[S.charge_max]",S.connected_button)
			if(Sp_HOLDVAR)
				statpanel(S.panel,"[S.holder_var_type] [S.holder_var_amount]",S.connected_button)
