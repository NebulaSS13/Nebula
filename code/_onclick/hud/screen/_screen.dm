/*
	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name             = ""
	icon             = 'icons/mob/screen1.dmi'
	plane            = HUD_PLANE
	layer            = HUD_BASE_LAYER
	appearance_flags = NO_CLIENT_COLOR
	var/obj/master   = null  // A reference to the object in the slot. Grabs or items, generally.
	var/globalscreen = FALSE // Global screens are not qdeled when the holding mob is destroyed.

/obj/screen/proc/handle_click(mob/user, params)
	if(!user)
		return TRUE
	switch(name)
		if("toggle")
			if(user.hud_used.inventory_shown)
				user.client.screen -= user.hud_used.other
				user.hud_used.hide_inventory()
			else
				user.client.screen += user.hud_used.other
				user.hud_used.show_inventory()
		if("equip")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.quick_equip()
		if("resist")
			if(isliving(user))
				var/mob/living/L = user
				L.resist()
		if("Reset Machine")
			user.unset_machine()
		if("up hint")
			if(isliving(user))
				var/mob/living/L = user
				L.lookup()
		if("internal")
			if(isliving(user))
				var/mob/living/M = user
				M.ui_toggle_internals()
		if("act_intent")
			user.a_intent_change("right")
		if("throw")
			if(!user.stat && isturf(user.loc) && !user.restrained())
				user.toggle_throw_mode()
		if("drop")
			if(user.client)
				user.client.drop_item()
		if("module")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.pick_module()
		if("inventory")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return TRUE
				to_chat(R, "You haven't selected a module yet.")
		if("radio")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.radio_menu()
		if("panel")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.installed_modules()
		if("store")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				if(R.module)
					R.uneq_active()
					R.hud_used.update_robot_modules_display()
				else
					to_chat(R, "You haven't selected a module yet.")
		if("module1")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.toggle_module(1)
		if("module2")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.toggle_module(2)
		if("module3")
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.toggle_module(3)
		else
			return FALSE
	return TRUE

/obj/screen/Click(location, control, params)
	if(ismob(usr) && usr.client && usr.canClick() && !usr.incapacitated())
		return handle_click(usr, params)
	return FALSE

/obj/screen/receive_mouse_drop(atom/dropping, mob/user)
	return TRUE

/obj/screen/check_mousedrop_interactivity(var/mob/user)
	return user.client && (src in user.client.screen)

/obj/screen/Destroy()
	master = null
	return ..()
