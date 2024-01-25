/mob/living/silicon/robot
	hud_type = /datum/hud/robot

/datum/hud/robot
	constraint_hands_to_columns = FALSE
	has_intent_selector = /obj/screen/intent

/datum/hud/robot/get_ui_style()
	return 'icons/mob/screen/robot.dmi'

/datum/hud/robot/get_ui_color()
	return COLOR_WHITE

/datum/hud/robot/get_ui_alpha()
	return 255

/datum/hud/robot/FinalizeInstantiation()

	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	if(isrobot(mymob))
		var/mob/living/silicon/robot/beep = mymob
		// have their own icons, so don't supply ui_style
		beep.module_select   = new(null, beep)
		beep.radio_config    = new(null, beep)
		beep.robot_inventory = new(null, beep)
		beep.robot_storage   = new(null, beep)
		adding += list(beep.module_select, beep.radio_config, beep.robot_storage, beep.robot_inventory)

	mymob.cells    = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.healths  = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.bodytemp = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.oxygen   = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.fire     = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.up_hint  = new(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.zone_sel = new(null, mymob, ui_style, ui_color, ui_alpha)

	hud_elements += list(
		mymob.cells,
		mymob.healths,
		mymob.bodytemp,
		mymob.oxygen,
		mymob.fire,
		mymob.up_hint,
		mymob.zone_sel
	)

	create_gun_setting_icons()
	return ..()

/mob/living/silicon/robot/proc/remove_emag_status()
	emagged = FALSE
	if(module?.emag && get_active_hand() == module.emag)
		unequip(module.emag)

/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return
	var/mob/living/silicon/robot/R = mymob
	R.shown_robot_modules = !R.shown_robot_modules
	update_robot_modules_display()

/datum/hud/proc/update_robot_modules_display()
	if(!isrobot(mymob) || !mymob.client)
		return

	var/mob/living/silicon/robot/R = mymob

	if(R.shown_robot_modules)
		if(R.active_storage)
			R.active_storage.close(R) //Closes the inventory ui.

		if(!R.module)
			to_chat(usr, SPAN_WARNING("No module selected."))
			return

		if(!length(R.module.equipment))
			to_chat(usr, SPAN_WARNING("Selected module has no modules to select."))
			return

		if(!R.robot_modules_background)
			return

		var/display_rows = -round(-(R.module.equipment.len) / 8)
		R.robot_modules_background.screen_loc = "CENTER-4:16,BOTTOM+1:24 to CENTER+3:16,BOTTOM+[display_rows]:24"
		R.client.screen += R.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(R.emagged)
			if(!(R.module.emag in R.module.equipment))
				R.module.equipment.Add(R.module.emag)
		else
			if(R.module.emag in R.module.equipment)
				R.module.equipment.Remove(R.module.emag)

		for(var/atom/movable/A in R.module.equipment)
			if(!(A in R.get_held_items()))
				//Module is not currently active
				R.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:[WORLD_ICON_SIZE/2],BOTTOM+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:[WORLD_ICON_SIZE/2],BOTTOM+[y]:7"
				A.hud_layerise()

				x++
				if(x == 4)
					x = -4
					y++
	else
		for(var/atom/A in R.module.equipment)
			if(!(A in R.get_held_items()))
				R.client.screen -= A
		R.shown_robot_modules = FALSE
		R.client.screen -= R.robot_modules_background
