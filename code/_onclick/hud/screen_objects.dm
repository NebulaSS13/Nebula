/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	appearance_flags = NO_CLIENT_COLOR
	is_spawnable_type = FALSE
	var/globalscreen = FALSE //Global screens are not qdeled when the holding mob is destroyed.

/obj/screen/receive_mouse_drop(atom/dropping, mob/user, params)
	return TRUE

/obj/screen/check_mousedrop_interactivity(mob/user, params)
	return user.client && (src in user.client.screen)

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.
	var/weakref/mouse_over_atom_ref
	var/weakref/owner_ref

/obj/screen/inventory/Initialize(var/ml, var/mob/_owner)
	if(!istype(_owner))
		PRINT_STACK_TRACE("Inventory screen object supplied a non-mob owner!")
	owner_ref = weakref(_owner)
	return ..()

/obj/screen/inventory/MouseDrop()
	. = ..()
	mouse_over_atom_ref = null
	update_icon()

/obj/screen/inventory/Click()
	. = ..()
	mouse_over_atom_ref = null
	update_icon()

/obj/screen/inventory/MouseEntered(location, control, params)
	. = ..()
	if(!slot_id || !usr)
		return
	var/equipped_item = usr.get_active_hand()
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

/obj/screen/close
	name = "close"
	// A reference to the storage item this atom is associated with.
	var/obj/master

/obj/screen/close/Destroy()
	master = null
	return ..()

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/storage))
			var/obj/item/storage/S = master
			S.close(usr)
	return 1

/obj/screen/default_attack_selector
	name = "default attack selector"
	icon_state = "attack_none"
	screen_loc = ui_attack_selector
	var/mob/living/carbon/human/owner

/obj/screen/default_attack_selector/Click(location, control, params)
	if(!owner || usr != owner || owner.incapacitated())
		return FALSE

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		to_chat(owner, SPAN_NOTICE("Your current default attack is <b>[owner.default_attack?.name || "unset"]</b>."))
		if(owner.default_attack)
			var/summary = owner.default_attack.summarize()
			if(summary)
				to_chat(owner, SPAN_NOTICE(summary))
		return

	owner.set_default_unarmed_attack(src)
	return TRUE

/obj/screen/default_attack_selector/Destroy()
	if(owner)
		if(owner.attack_selector == src)
			owner.attack_selector = null
		owner = null
	. = ..()

/obj/screen/default_attack_selector/proc/set_owner(var/mob/living/carbon/human/_owner)
	owner = _owner
	if(!owner)
		qdel(src)
	else
		update_icon()

/obj/screen/default_attack_selector/on_update_icon()
	var/decl/natural_attack/attack = owner?.default_attack
	icon_state = attack?.selector_icon_state || "attack_none"

/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Destroy()
	owner = null
	. = ..()

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return 1
	if(!usr.canClick())
		return

	if(usr.incapacitated())
		return 1

	if(!(owner in usr))
		return 1

	owner.ui_action_click()
	return 1

/obj/screen/storage
	name = "storage"
	// A reference to the storage item this atom is associated with.
	var/obj/master

/obj/screen/storage/Destroy()
	master = null
	return ..()

/obj/screen/storage/Click()
	if(!usr.canClick())
		return 1
	if(usr.incapacitated(INCAPACITATION_DISRUPTED))
		return 1
	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)
	return 1

/obj/screen/zone_selector
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_CHEST

/obj/screen/zone_selector/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/new_selecting

	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					new_selecting = BP_R_FOOT
				if(17 to 22)
					new_selecting = BP_L_FOOT
				else
					return 1
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					new_selecting = BP_R_LEG
				if(17 to 22)
					new_selecting = BP_L_LEG
				if(23 to 28)
					new_selecting = BP_TAIL
				else
					return 1
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					new_selecting = BP_R_HAND
				if(12 to 20)
					new_selecting = BP_GROIN
				if(21 to 24)
					new_selecting = BP_L_HAND
				else
					return 1
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					new_selecting = BP_R_ARM
				if(12 to 20)
					new_selecting = BP_CHEST
				if(21 to 24)
					new_selecting = BP_L_ARM
				else
					return 1
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				new_selecting = BP_HEAD
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							new_selecting = BP_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							new_selecting = BP_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							new_selecting = BP_EYES

	set_selected_zone(new_selecting)
	return 1

/obj/screen/zone_selector/Initialize(mapload)
	. = ..()
	update_icon()

/obj/screen/zone_selector/proc/set_selected_zone(bodypart)
	var/old_selecting = selecting
	selecting = bodypart
	if(old_selecting != selecting)
		update_icon()
		return TRUE

/obj/screen/zone_selector/on_update_icon()
	set_overlays(image('icons/mob/zone_sel.dmi', "[selecting]"))

/obj/screen/intent
	name = "intent"
	icon = 'icons/mob/screen/white.dmi'
	icon_state = "intent_help"
	screen_loc = ui_acti
	var/intent = I_HELP

/obj/screen/intent/Click(var/location, var/control, var/params)
	var/list/P = params2list(params)
	var/icon_x = text2num(P["icon-x"])
	var/icon_y = text2num(P["icon-y"])
	intent = I_DISARM
	if(icon_x <= world.icon_size/2)
		if(icon_y <= world.icon_size/2)
			intent = I_HURT
		else
			intent = I_HELP
	else if(icon_y <= world.icon_size/2)
		intent = I_GRAB
	update_icon()
	usr.a_intent = intent

/obj/screen/intent/on_update_icon()
	icon_state = "intent_[intent]"

/obj/screen/Click(location, control, params)
	if(!usr)	return 1

	switch(name)
		if("toggle")
			if(usr.hud_used.inventory_shown)
				usr.client.screen -= usr.hud_used.other
				usr.hud_used.hide_inventory()
			else
				usr.client.screen += usr.hud_used.other
				usr.hud_used.show_inventory()

		if("equip")
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("Reset Machine")
			usr.unset_machine()

		if("up hint")
			if(isliving(usr))
				var/mob/living/L = usr
				L.lookup()

		if("internal")
			if(isliving(usr))
				var/mob/living/M = usr
				M.ui_toggle_internals()

		if("act_intent")
			usr.a_intent_change("right")

		if("throw")
			if(!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr.toggle_throw_mode()
		if("drop")
			if(usr.client)
				usr.client.drop_item()

		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.pick_module()

		if("inventory")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return 1
				else
					to_chat(R, "You haven't selected a module yet.")

		if("radio")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.radio_menu()
		if("panel")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.uneq_active()
					R.hud_used.update_robot_modules_display()
				else
					to_chat(R, "You haven't selected a module yet.")

		if("module1")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.toggle_module(1)

		if("module2")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.toggle_module(2)

		if("module3")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				R.toggle_module(3)
		else
			return 0
	return 1

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(!usr.canClick() || usr.incapacitated())
		return TRUE

	if(name == "swap" || name == "hand")
		usr.swap_hand()
	else if(name in usr.get_held_item_slots())
		if(name == usr.get_active_held_item_slot())
			usr.attack_empty_hand()
		else
			usr.select_held_item_slot(name)
	else if(usr.attack_ui(slot_id))
		usr.update_inhand_overlays(FALSE)

	return TRUE

// Character setup stuff
/obj/screen/setup_preview
	plane = DEFAULT_PLANE
	layer = MOB_LAYER

	var/datum/preferences/pref

/obj/screen/setup_preview/Destroy()
	pref = null
	return ..()

// Background 'floor'
/obj/screen/setup_preview/bg
	layer = TURF_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/obj/screen/setup_preview/bg/Click(params)
	if(pref)
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		pref.update_preview_icon()

/obj/screen/lighting_plane_master
	screen_loc = "CENTER"
	appearance_flags = PLANE_MASTER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	plane = LIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	alpha = 255

/obj/screen/lighting_plane_master/proc/set_alpha(var/newalpha)
	if(alpha != newalpha)
		animate(src, alpha = newalpha, time = SSmobs.wait)
