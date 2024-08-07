var/global/obj/screen/robot_inventory

/mob/living/silicon/robot
	hud_used = /datum/hud/robot

/decl/ui_style/robot
	name = "Stationbound"
	restricted = TRUE
	uid = "ui_style_robot"
	override_icons = list(
		UI_ICON_HEALTH      = 'icons/mob/screen/styles/robot/health.dmi',
		UI_ICON_STATUS_FIRE = 'icons/mob/screen/styles/robot/status_fire.dmi',
		UI_ICON_UP_HINT     = 'icons/mob/screen/styles/robot/uphint.dmi',
		UI_ICON_ZONE_SELECT = 'icons/mob/screen/styles/robot/zone_selector.dmi'
	)

/datum/hud/robot/get_ui_style_data()
	return GET_DECL(/decl/ui_style/robot)

/datum/hud/robot/get_ui_color()
	return COLOR_WHITE

/datum/hud/robot/get_ui_alpha()
	return 255

/datum/hud/robot/FinalizeInstantiation()

	var/mob/living/silicon/robot/R = mymob
	if(!istype(R))
		..()
		return

	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	//Radio
	adding += new /obj/screen/robot_radio(null, mymob)

	//Module select
	R.inv1 = new(null, mymob)
	R.inv2 = new(null, mymob)
	R.inv3 = new(null, mymob)
	adding += R.inv1
	adding += R.inv2
	adding += R.inv3
	//End of module select

	// Drop UI
	R.ui_drop_grab = new(null, mymob)
	adding += R.ui_drop_grab

	//Intent
	action_intent = new /obj/screen/intent/robot(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_INTENT)
	action_intent.icon_state = R.a_intent

	adding += action_intent
	adding += new /obj/screen/robot_panel(null, mymob)
	adding += new /obj/screen/robot_store(null, mymob)

	R.hands            = new /obj/screen/robot_module/select(null, mymob)
	robot_inventory    = new /obj/screen/robot_inventory(    null, mymob)
	R.cells            = new /obj/screen/robot_charge(       null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_CHARGE)
	R.healths          = new /obj/screen/robot_health(       null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HEALTH)
	R.bodytemp         = new /obj/screen/bodytemp(           null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_STATUS)
	R.oxygen           = new /obj/screen/robot_oxygen(       null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_STATUS)
	R.fire             = new /obj/screen/robot_fire(         null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_STATUS_FIRE)
	R.up_hint          = new /obj/screen/up_hint(            null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_UP_HINT)
	R.zone_sel         = new(                                null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_ZONE_SELECT)
	R.gun_setting_icon = new /obj/screen/gun/mode(           null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_FIRE_INTENT)
	R.item_use_icon    = new /obj/screen/gun/item(           null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_FIRE_INTENT)
	R.gun_move_icon    = new /obj/screen/gun/move(           null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_FIRE_INTENT)
	R.radio_use_icon   = new /obj/screen/gun/radio(          null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_FIRE_INTENT)

	hud_elements = list(R.zone_sel, R.oxygen, R.fire, R.up_hint, R.hands, R.healths, R.cells, robot_inventory, R.gun_setting_icon)
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
			to_chat(usr, "<span class='danger'>No module selected</span>")
			return

		if(!R.module.equipment)
			to_chat(usr, "<span class='danger'>Selected module has no modules to select</span>")
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
		//R.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in R.module.equipment)
			if( (A != R.module_state_1) && (A != R.module_state_2) && (A != R.module_state_3) )
				//Module is not currently active
				R.client.screen -= A
		R.shown_robot_modules = 0
		R.client.screen -= R.robot_modules_background
