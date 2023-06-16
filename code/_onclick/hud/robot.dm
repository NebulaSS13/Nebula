/mob/living/silicon/robot
	var/obj/screen/hands
	hud_used = /datum/hud/robot

/decl/hud_element/condition/fire/robot
	screen_icon = 'icons/mob/screen/robot_conditions.dmi'

/decl/hud_element/condition/oxygen/robot
	screen_icon = 'icons/mob/screen/robot_conditions.dmi'

/decl/hud_element/condition/bodytemp/robot
	screen_icon = 'icons/mob/screen/robot_conditions.dmi'

/decl/hud_element/module
	screen_name = "module"
	screen_icon = 'icons/mob/screen/robot_modules.dmi'
	screen_icon_state = "nomod"
	screen_loc = ui_borg_module

/decl/hud_element/radio
	screen_name = "radio"
	screen_icon_state = "radio"
	screen_loc = ui_movi

/decl/hud_element/radio/create_screen_object(datum/hud/hud)
	var/obj/screen/elem = ..()
	elem.set_dir(SOUTHWEST)
	return elem

/decl/hud_element/drop_grab
	screen_name = "drop grab"
	screen_object_type = /obj/screen/robot_drop_grab
	screen_icon = 'icons/mob/screen/robot_drop_grab.dmi'
	screen_icon_state = "drop_grab"
	screen_loc = ui_borg_drop_grab
	update_in_life = TRUE

/decl/hud_element/drop_grab/create_screen_object(datum/hud/hud)
	var/obj/screen/elem = ..()
	if(length(hud?.mymob?.get_active_grabs()))
		elem.invisibility = 0
		elem.alpha = 255
	else
		elem.invisibility = INVISIBILITY_MAXIMUM
		elem.alpha = 0
	return elem

/decl/hud_element/drop_grab/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	. = ..()
	if(length(hud?.mymob?.get_active_grabs()))
		elem.invisibility = 0
		elem.alpha = 255
	else
		elem.invisibility = INVISIBILITY_MAXIMUM
		elem.alpha = 0

/obj/screen/robot_drop_grab/Click(location, control, params)
	. = ..()
	if(!isrobot(usr) || usr.incapacitated())
		return

	var/mob/living/silicon/robot/R = usr
	R.drop_item()
	invisibility = INVISIBILITY_MAXIMUM
	alpha = 0

/decl/hud_element/health/robot
	screen_icon = 'icons/mob/screen/health_robot.dmi'
	screen_loc = ui_borg_health

/decl/hud_element/module_panel
	screen_name = "panel"
	screen_icon_state = "panel"
	screen_loc = ui_borg_panel

/decl/hud_element/robot_inventory
	screen_name = "inventory"
	screen_icon_state = "inventory"
	screen_loc = ui_borg_inventory

/datum/hud/robot
	health_hud_type = /decl/hud_element/health/robot
	hud_elements = list(
		/decl/hud_element/health/robot,
		/decl/hud_element/drop_grab,
		/decl/hud_element/radio,
		/decl/hud_element/module,
		/decl/hud_element/module_panel,
		/decl/hud_element/robot_inventory,
		/decl/hud_element/condition/fire/robot,
		/decl/hud_element/condition/oxygen/robot,
		/decl/hud_element/condition/bodytemp/robot
	)

/datum/hud/robot/get_ui_color()
	return COLOR_WHITE

/datum/hud/robot/get_ui_alpha()
	return 255

/datum/hud/robot/get_ui_style()
	return 'icons/mob/screen/robot.dmi'

/datum/hud/robot/FinalizeInstantiation()

	var/mob/living/silicon/robot/R = mymob
	if(!istype(R))
		..()
		return ..()

	var/mob/living/silicon/robot/R = mymob
	var/obj/screen/using
	var/ui_style = get_ui_style()

	//Module select
	using = new /obj/screen()
	using.SetName("module1")
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	misc_hud_elements += using
	R.inv1 = using

	using = new /obj/screen()
	using.SetName("module2")
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	misc_hud_elements += using
	R.inv2 = using

	using = new /obj/screen()
	using.SetName("module3")
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	misc_hud_elements += using
	R.inv3 = using
	//End of module select

	return ..()

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
			to_chat(usr, "<span class='danger'>No module selected</span>")
			return

		if(!R.module.equipment)
			to_chat(usr, "<span class='danger'>Selected module has no modules to select</span>")
			return

		if(!R.robot_modules_background)
			return

		var/display_rows = -round(-(R.module.equipment.len) / 8)
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
