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
