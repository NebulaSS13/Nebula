/mob/living/silicon/robot
	hud_used = /datum/hud/robot

/datum/hud/robot/get_ui_style_data()
	return GET_DECL(/decl/ui_style/robot)

/datum/hud/robot/get_ui_color()
	return COLOR_WHITE

/datum/hud/robot/get_ui_alpha()
	return 255

// TODO: Convert robots to use inventory slots.
/datum/hud/robot/finalize_instantiation()
	var/mob/living/silicon/robot/R = mymob
	if(!istype(R))
		return ..()
	R.inv1 = new(null, mymob)
	R.inv2 = new(null, mymob)
	R.inv3 = new(null, mymob)
	LAZYINITLIST(hud_elements_auxilliary)
	hud_elements_auxilliary += R.inv1
	hud_elements_auxilliary += R.inv2
	hud_elements_auxilliary += R.inv3
	..()

/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return
	var/mob/living/silicon/robot/r = mymob
	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()

/datum/hud/proc/update_robot_modules_display()
	if(!isrobot(mymob) || !mymob.client)
		return

	var/mob/living/silicon/robot/R = mymob

	if(R.shown_robot_modules)
		if(R.active_storage)
			R.active_storage.close(R) //Closes the inventory ui.

		if(!R.module)
			to_chat(R, SPAN_WARNING("No module selected."))
			return

		if(!R.module.equipment)
			to_chat(R, SPAN_WARNING("Selected module has no equipment available."))
			return

		if(!R.robot_modules_background)
			return

		var/display_rows = ceil(R.module.equipment.len / 8)
		R.robot_modules_background.screen_loc = "CENTER-4:16,BOTTOM+1:7 to CENTER+3:16,BOTTOM+[display_rows]:7"
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
			if( (A != R.module_state_1) && (A != R.module_state_2) && (A != R.module_state_3) )
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
		//Modules display is hidden
		for(var/atom/A in R.module.equipment)
			if( (A != R.module_state_1) && (A != R.module_state_2) && (A != R.module_state_3) )
				//Module is not currently active
				R.client.screen -= A
		R.shown_robot_modules = 0
		R.client.screen -= R.robot_modules_background
