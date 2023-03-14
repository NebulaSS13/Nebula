/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/mob
	var/hud_type = null
	var/datum/hud/hud_used = null

/mob/proc/InitializeHud()
	if(hud_used)
		qdel(hud_used)
	if(hud_type)
		hud_used = new hud_type(src)
	else
		hud_used = new /datum/hud(src)
	refresh_lighting_master()

/datum/hud
	var/mob/mymob

	var/hud_shown           = 1         //Used for the HUD toggle (F12)
	var/inventory_shown     = TRUE      //the inventory
	var/show_intent_icons   = FALSE
	var/hotkey_ui_hidden    = FALSE     //This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/lingchemdisplay
	var/list/hand_hud_objects
	var/list/swaphand_hud_objects
	var/obj/screen/action_intent
	var/obj/screen/move_intent
	var/obj/screen/stamina/stamina_bar

	var/list/adding
	var/list/other
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
	lingchemdisplay = null
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

	var/decl/species/species = mymob?.get_species()
	for(var/hud_slot in checking_slots)

		// Check if we're even wearing anything in that slot.
		var/obj/item/gear = mymob.get_equipped_item(checking_slots[hud_slot])
		if(!istype(gear))
			continue

		// We're not showing anything, hide it.
		if(!show_hud)
			gear.screen_loc = null
			continue

		var/list/hud_data = species.hud.gear[hud_slot]
		if(!("loc" in hud_data))
			gear.screen_loc = null
			continue

		// Set the loc.
		gear.screen_loc = hud_data["loc"]

/datum/hud/proc/instantiate()
	if(ismob(mymob) && mymob.client)
		FinalizeInstantiation()
		return TRUE
	return FALSE

/datum/hud/proc/FinalizeInstantiation()
	return

/datum/hud/proc/get_ui_style()
	return ui_style2icon(mymob?.client?.prefs?.UI_style) || 'icons/mob/screen/white.dmi'

/datum/hud/proc/get_ui_color()
	return mymob?.client?.prefs?.UI_style_color  || COLOR_WHITE

/datum/hud/proc/get_ui_alpha()
	return mymob?.client?.prefs?.UI_style_alpha || 255

/datum/hud/proc/rebuild_hands()

	var/mob/living/target = mymob
	if(!istype(target))
		return

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
		var/datum/inventory_slot/inv_slot = target.held_item_slots[hand_tag]
		inv_box.SetName(hand_tag)
		inv_box.icon = ui_style
		inv_box.icon_state = "hand_base"

		inv_box.cut_overlays()
		inv_box.add_overlay("hand_[hand_tag]")
		if(inv_slot.ui_label)
			inv_box.add_overlay("hand_[inv_slot.ui_label]")
		if(target.get_active_held_item_slot() == hand_tag)
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
		inv_slot = target.get_inventory_slot_datum(inv_elem.name)
		if(inv_slot)
			inv_slot.ui_loc = inv_elem.screen_loc
			if(inv_slot.holding)
				inv_slot.holding.screen_loc = inv_slot.ui_loc
				if(mymob.client)
					mymob.client.screen |= inv_slot.holding // just to make sure it's visible post-login

	var/hand_x_offset = -(world.icon_size/2)
	for(var/i = 1 to length(swaphand_hud_objects))
		var/obj/swap_elem = swaphand_hud_objects[i]
		swap_elem.screen_loc = "CENTER:[hand_x_offset],BOTTOM:[hand_y_offset]"
		if(i > 1) // first two elems share a slot
			hand_x_offset += world.icon_size
		if(mymob.client)
			mymob.client.screen |= swap_elem

/datum/hud/proc/BuildInventoryUI()

	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	var/has_hidden_gear = FALSE

	var/mob/living/carbon/human/target = mymob
	var/datum/hud_data/hud_data = istype(target) ? target.species.hud : new()
	var/list/held_slots = mymob.get_held_item_slots()

	// Draw the various inventory equipment slots.
	var/obj/screen/inventory/inv_box
	for(var/gear_slot in hud_data.gear) // inventory_slots)

		if(gear_slot in held_slots)
			continue

		inv_box = new /obj/screen/inventory()
		inv_box.icon =  ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  hud_data.gear[gear_slot]
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]
		inv_box.SetName(gear_slot)

		if(slot_data["dir"])
			inv_box.set_dir(slot_data["dir"])

		if(slot_data["toggle"])
			other += inv_box
			has_hidden_gear = TRUE
		else
			adding += inv_box

	if(has_hidden_gear)
		var/obj/screen/using = new /obj/screen()
		using.SetName("toggle")
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.color = ui_color
		using.alpha = ui_alpha
		adding += using

/datum/hud/proc/BuildHandsUI()

	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	var/obj/screen/using

	// Swap hand and quick equip screen elems.
	using = new /obj/screen()
	using.SetName("equip")
	using.icon = ui_style
	using.icon_state = "act_equip"
	using.color = ui_color
	using.alpha = ui_alpha
	src.adding += using
	LAZYADD(swaphand_hud_objects, using)

	var/list/held_slots = mymob.get_held_item_slots()
	if(length(held_slots) > 1)

		using = new /obj/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand1"
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		LAZYADD(swaphand_hud_objects, using)

		using = new /obj/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand2"
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		LAZYADD(swaphand_hud_objects, using)

	// Actual hand elems.
	rebuild_hands()

/mob/verb/minimize_hud(full = FALSE as null)
	set name = "Minimize Hud"
	set hidden = TRUE
	minimize_hud_proc(full)

/mob/proc/minimize_hud_proc(var/full)
	to_chat(usr, SPAN_WARNING("Inventory hiding is currently only supported for human mobs, sorry."))

/mob/living/carbon/human/minimize_hud_proc(var/full)
	if(!client)
		return
	if(!hud_used)
		to_chat(usr, "<span class='warning'>This mob type does not use a HUD.</span>")
		return FALSE
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
			src.client.screen += src.hud_used.action_intent        // we want the intent swticher visible
			src.hud_used.action_intent.screen_loc = ui_acti_alt    // move this to the alternative position, where zone_select usually is.
		else
			client.screen -= healths
			client.screen -= internals_ui
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
		if(internals_ui)
			client.screen |= internals_ui
		if(gun_setting_icon)
			client.screen |= gun_setting_icon

		hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
		client.screen += zone_sel				//This one is a special snowflake

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
	update_action_buttons()

//Similar to minimize_hud() but keeps zone_sel, gun_setting_icon, and healths.
/mob/proc/toggle_zoom_hud()
	if(!hud_used)
		return FALSE
	if(!ishuman(src))
		return FALSE
	if(!client)
		return FALSE
	if(client.view != world.view)
		return FALSE

	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		hide_zoom_hud()
	else
		hud_used.hud_shown = 1
		show_zoom_hud()

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
	update_action_buttons()

	return TRUE

/mob/proc/hide_zoom_hud()
	if(hud_used.adding)
		client.screen -= hud_used.adding
	if(hud_used.other)
		client.screen -= hud_used.other
	if(hud_used.hotkeybuttons)
		client.screen -= hud_used.hotkeybuttons
	client.screen += hud_used.action_intent		//we want the intent swticher visible

/mob/living/hide_zoom_hud()
	client.screen -= internals_ui

/mob/proc/show_zoom_hud()
	hud_used.hud_shown = 1
	if(hud_used.adding)
		client.screen += hud_used.adding
	if(hud_used.other && hud_used.inventory_shown)
		client.screen += hud_used.other
	if(hud_used.hotkeybuttons && !hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
	hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position

/mob/living/show_zoom_hud()
	if(internals_ui)
		client.screen |= internals_ui

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

/obj/screen/stamina
	name = "stamina"
	icon = 'icons/effects/progressbar.dmi'
	icon_state = "prog_bar_100"
	invisibility = INVISIBILITY_MAXIMUM
	screen_loc = ui_stamina
