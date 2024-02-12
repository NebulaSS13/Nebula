/mob/living/exosuit
	var/static/list/additional_hud_elements = list(
		/obj/screen/exosuit/toggle/power_control,
		/obj/screen/exosuit/toggle/maint,
		/obj/screen/exosuit/eject,
		/obj/screen/exosuit/toggle/hardpoint,
		/obj/screen/exosuit/toggle/hatch,
		/obj/screen/exosuit/toggle/hatch_open,
		/obj/screen/exosuit/radio,
		/obj/screen/exosuit/rename,
		/obj/screen/exosuit/toggle/camera
	)

/mob/living/exosuit/proc/refresh_hud()
	if(LAZYLEN(pilots))
		for(var/thing in pilots)
			var/mob/pilot = thing
			if(pilot.client)
				pilot.client.screen |= hud_elements
	if(client)
		client.screen |= hud_elements

/obj/screen/zone_selector/exosuit
	requires_ui_style = FALSE

/mob/living/exosuit/InitializeHud()
	zone_sel = new /obj/screen/zone_selector/exosuit(null, src)
	if(!LAZYLEN(hud_elements))
		var/i = 1
		for(var/hardpoint in hardpoints)
			var/obj/screen/exosuit/hardpoint/H = new(null, src, null, null, null, null, hardpoint)
			H.screen_loc = "LEFT:6,TOP-[i]:-16"
			hud_elements |= H
			hardpoint_hud_elements[hardpoint] = H
			i++

		if(body && body.pilot_coverage >= 100)
			additional_hud_elements += /obj/screen/exosuit/toggle/air
		i = 0
		var/pos = 7
		for(var/additional_hud in additional_hud_elements)
			var/obj/screen/exosuit/M = new additional_hud(null, src)
			M.screen_loc = "LEFT:6,BOTTOM+[pos]:[i]"
			hud_elements |= M
			i -= M.height

		hud_health = new /obj/screen/exosuit/health(null, src)
		hud_health.screen_loc = "RIGHT-1:28,CENTER-3:11"
		hud_elements |= hud_health
		hud_open = locate(/obj/screen/exosuit/toggle/hatch_open) in hud_elements
		hud_power = new /obj/screen/exosuit/power(null, src)
		hud_power.screen_loc = "RIGHT-1:28,CENTER-4:25"
		hud_elements |= hud_power
		hud_power_control = locate(/obj/screen/exosuit/toggle/power_control) in hud_elements
		hud_camera = locate(/obj/screen/exosuit/toggle/camera) in hud_elements
		hud_heat = new /obj/screen/exosuit/heat(null, src)
		hud_heat.screen_loc = "RIGHT-1:28,CENTER-4"
		hud_elements |= hud_heat

	refresh_hud()

/mob/living/exosuit/should_do_hud_updates()
	. = ..()
	if(!. && length(pilots))
		for(var/mob/living/pilot in pilots)
			if(pilot.should_do_hud_updates())
				return TRUE

/mob/living/exosuit/handle_hud_icons()
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/exosuit/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H) H.update_system_info()
	handle_hud_icons_health()

	var/maptext_string = "CHECK<br>POWER"
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		maptext_string = "[round(get_cell().charge)]/[round(get_cell().maxcharge)]"
	hud_power.maptext = STYLE_SMALLFONTS_OUTLINE("<center>[maptext_string]</center>", 5, COLOR_WHITE, COLOR_BLACK)
	refresh_hud()

/mob/living/exosuit/handle_hud_icons_health()

	hud_health.overlays.Cut()

	if(!body || !get_cell() || (get_cell().charge <= 0))
		return

	if(!body.diagnostics || !body.diagnostics.is_functional() || ((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*2)))
		if(!global.mech_damage_overlay_cache["critfail"])
			global.mech_damage_overlay_cache["critfail"] = image(icon='icons/mecha/mech_hud.dmi',icon_state="dam_error")
		hud_health.overlays |= global.mech_damage_overlay_cache["critfail"]
		return

	var/list/part_to_state = list("legs" = legs,"body" = body,"head" = head,"arms" = arms)
	for(var/part in part_to_state)
		var/state = 0
		var/obj/item/mech_component/MC = part_to_state[part]
		if(MC)
			if((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*3))
				state = rand(0,4)
			else
				state = MC.damage_state
		if(!global.mech_damage_overlay_cache["[part]-[state]"])
			var/image/I = image(icon='icons/mecha/mech_hud.dmi',icon_state="dam_[part]")
			switch(state)
				if(1)
					I.color = "#00ff00"
				if(2)
					I.color = "#f2c50d"
				if(3)
					I.color = "#ea8515"
				if(4)
					I.color = "#ff0000"
				else
					I.color = "#f5f5f0"
			global.mech_damage_overlay_cache["[part]-[state]"] = I
		hud_health.overlays |= global.mech_damage_overlay_cache["[part]-[state]"]

/mob/living/exosuit/proc/reset_hardpoint_color()
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/exosuit/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H)
			H.color = COLOR_WHITE

/mob/living/exosuit/setClickCooldown(var/timeout)
	. = ..()
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/exosuit/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H)
			H.color = "#a03b3b"
			animate(H, color = COLOR_WHITE, time = timeout, easing = CUBIC_EASING | EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(reset_hardpoint_color)), timeout)