/obj/machinery/camera
	name = "security camera"
	desc = "A classic security camera used to monitor rooms. It's directly wired to the local area's alarm system."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "camera"
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 5
	active_power_usage = 10
	layer = CAMERA_LAYER
	anchored = 1
	movable_flags = MOVABLE_FLAG_PROXMOVE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'SOUTH':{'y':21}, 'EAST':{'x':-10}, 'WEST':{'x':10}}"
	base_type = /obj/machinery/camera
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/wall_frame/panel_closed
	frame_type = /obj/item/frame/camera
	//Deny all by default, so mapped presets can't be messed with during a network outage.
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/camera,
	)
	var/list/preset_channels
	var/cameranet_enabled = TRUE
	var/requires_connection = TRUE

	var/motion_sensor = FALSE
	var/list/motionTargets = list()
	var/detectTime = 0
	var/alarm_delay = 100 // Don't forget, there's another 10 seconds in queueAlarm()

	var/number = 1
	var/c_tag = null
	var/status = 1
	var/cut_power = FALSE

	var/toughness = 5 // Attack force or throw force required before damage is dealt.

	// WIRES
	wires = /datum/wires/camera

	//OTHER
	var/long_range = 7
	var/short_range = 2

	var/light_disabled = 0
	var/alarm_on = 0

	var/affected_by_emp_until = 0

/obj/machinery/camera/examine(mob/user)
	. = ..()
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("It is completely demolished."))

/obj/machinery/camera/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1

	install_component(/obj/item/stock_parts/capacitor/adv, TRUE)
	install_component(/obj/item/stock_parts/scanning_module/adv, TRUE)

	to_chat(user, SPAN_NOTICE("\The [src] has been upgraded. It now has X-Ray capability and EMP resistance."))
	return 1

/obj/machinery/camera/apply_visual(mob/living/carbon/human/M)
	if(!M.client || !istype(M))
		return
	M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
	M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
	M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
	M.machine_visual = src
	return 1

/obj/machinery/camera/remove_visual(mob/living/carbon/human/M)
	if(!M.client || !istype(M))
		return
	M.clear_fullscreen("fishbed",0)
	M.clear_fullscreen("scanlines")
	M.clear_fullscreen("whitenoise")
	M.machine_visual = null
	return 1

/obj/machinery/camera/Initialize()
	. = ..()
	update_icon()
	if(!c_tag)
		var/area/A = get_area(src)
		if(isturf(loc) && A)
			for(var/obj/machinery/camera/C in A)
				if(C == src) continue
				if(C.number)
					number = max(number, C.number+1)
			c_tag = "[A.proper_name][number == 1 ? "" : " #[number]"]"
		if(!c_tag)	// Add a default c_tag in case the camera has been placed in an invalid location or inside another object.
			c_tag = "Security Camera - [random_id(/obj/machinery/camera, 100,999)]"

		invalidateCameraCache()
	set_extension(src, /datum/extension/network_device/camera, null, null, null, TRUE, preset_channels, c_tag, cameranet_enabled, requires_connection)

/obj/machinery/camera/Destroy()
	set_status(0) //kick anyone viewing out
	return ..()

/obj/machinery/camera/Process()
	if((stat & EMPED) && world.time >= affected_by_emp_until)
		stat &= ~EMPED
		cancelCameraAlarm()
		update_icon()
		update_coverage()

		if (detectTime > 0)
			var/elapsed = world.time - detectTime
			if (elapsed > alarm_delay)
				triggerAlarm()

	if (stat & (EMPED))
		return
	if(!motion_sensor)
		return PROCESS_KILL

	// Motion tracking.
	if (detectTime == -1)
		for (var/mob/target in motionTargets)
			if (target.stat == DEAD)
				lostTarget(target)
			// See if the camera is still in range
			if(!in_range(src, target))
				// If they aren't in range, lose the target.
				lostTarget(target)

/obj/machinery/camera/proc/newTarget(var/mob/target)
	if (!motion_sensor)
		return FALSE
	if (istype(target, /mob/living/silicon/ai))
		return FALSE
	if (detectTime == 0)
		detectTime = world.time // start the clock
	if (!(target in motionTargets))
		motionTargets += target
	return TRUE

/obj/machinery/camera/proc/lostTarget(var/mob/target)
	if (target in motionTargets)
		motionTargets -= target
	if (motionTargets.len == 0)
		cancelAlarm()

/obj/machinery/camera/proc/cancelAlarm()
	if (!status)
		return FALSE
	if (detectTime == -1)
		motion_alarm.clearAlarm(loc, src)
	detectTime = 0
	return TRUE

/obj/machinery/camera/proc/triggerAlarm()
	if (!status)
		return FALSE
	if (!detectTime)
		return FALSE
	motion_alarm.triggerAlarm(loc, src)
	detectTime = -1
	return TRUE

/obj/machinery/camera/HasProximity(atom/movable/AM)
	. = ..()
	if(. && isliving(AM))
		newTarget(AM)

/obj/machinery/camera/emp_act(severity)
	if(!(stat_immune & EMPED) && prob(100/severity))
		if(!affected_by_emp_until || (world.time < affected_by_emp_until))
			affected_by_emp_until = max(affected_by_emp_until, world.time + (90 SECONDS / severity))
		else
			stat |= EMPED
			set_light(0)
			triggerCameraAlarm()
			update_icon()
			update_coverage()
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/camera/bullet_act(var/obj/item/projectile/P)
	take_damage(P.get_structure_damage())

/obj/machinery/camera/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || prob(50)))
		set_broken(TRUE)

/obj/machinery/camera/hitby(var/atom/movable/AM)
	..()
	if (istype(AM, /obj))
		var/obj/O = AM
		if (O.throwforce >= src.toughness)
			visible_message("<span class='warning'><B>[src] was hit by [O].</B></span>")
		take_damage(O.throwforce)

/obj/machinery/camera/physical_attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.species.can_shred(user))
		user.do_attack_animation(src)
		visible_message("<span class='warning'>\The [user] slashes at [src]!</span>")
		playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
		add_hiddenprint(user)
		take_damage(25)
		return TRUE

/obj/machinery/camera/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper))
		var/datum/extension/network_device/camera/D = get_extension(src, /datum/extension/network_device)
		D.show_paper(W, user)
	return ..()

/obj/machinery/camera/interface_interact(mob/user)
	if(allowed(user))
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(user)
		return TRUE

/obj/machinery/camera/proc/add_channels(var/list/channels)
	var/datum/extension/network_device/camera/D = get_extension(src, /datum/extension/network_device)
	D.add_channels(channels)

/obj/machinery/camera/proc/remove_channels(var/list/channels)
	var/datum/extension/network_device/camera/D = get_extension(src, /datum/extension/network_device)
	D.remove_channels(channels)

/obj/machinery/camera/set_broken(new_state, cause)
	. = ..()
	if(.)
		wires.RandomCutAll()

		triggerCameraAlarm()
		update_coverage()

		//sparks
		spark_at(loc, amount=5)

/obj/machinery/camera/proc/set_status(var/newstatus, var/mob/user)
	if (status != newstatus && (!cut_power || status == TRUE))
		status = newstatus
		// The only way for AI to reactivate cameras are malf abilities, this gives them different messages.
		if(istype(user, /mob/living/silicon/ai))
			user = null

		if(status)
			if(user)
				visible_message(SPAN_NOTICE("[user] has reactivated \the [src]!"))
				add_hiddenprint(user)
			else
				visible_message(SPAN_NOTICE("\The [src] clicks and reactivates itself."))
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
			icon_state = initial(icon_state)
			add_hiddenprint(user)
		else
			if(user)
				visible_message(SPAN_NOTICE("[user] has deactivated \the [src]!"))
				add_hiddenprint(user)
			else
				visible_message(SPAN_NOTICE("\The [src] clicks and shuts down."))
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
			icon_state = "[initial(icon_state)]1"
		update_coverage()

/obj/machinery/camera/on_update_icon()
	if (!status || (stat & BROKEN))
		icon_state = "[initial(icon_state)]1"
	else if (stat & EMPED)
		icon_state = "[initial(icon_state)]emp"
	else
		icon_state = initial(icon_state)

/obj/machinery/camera/RefreshParts()
	. = ..()
	var/power_mult = 1
	var/emp_protection = total_component_rating_of_type(/obj/item/stock_parts/capacitor)
	if(emp_protection > 2)
		stat_immune &= EMPED
	else
		stat_immune &= ~EMPED
	var/xray_rating = total_component_rating_of_type(/obj/item/stock_parts/scanning_module)
	var/datum/extension/network_device/camera/camera_device = get_extension(src, /datum/extension/network_device/)
	if(camera_device)
		if(xray_rating > 2)
			camera_device.xray_enabled = TRUE
			power_mult++
		else
			camera_device.xray_enabled = FALSE
	if(number_of_components(/obj/item/stock_parts/micro_laser, TRUE))
		motion_sensor = TRUE
		power_mult++
	else
		motion_sensor = FALSE

	change_power_consumption(power_mult*initial(active_power_usage), POWER_USE_ACTIVE)

/obj/machinery/camera/proc/triggerCameraAlarm(var/duration = 0)
	alarm_on = 1
	camera_alarm.triggerAlarm(loc, src, duration)

/obj/machinery/camera/proc/cancelCameraAlarm()
	if(wires.IsIndexCut(CAMERA_WIRE_ALARM))
		return

	alarm_on = 0
	camera_alarm.clearAlarm(loc, src)

//if false, then the camera is listed as DEACTIVATED and cannot be used
/obj/machinery/camera/proc/can_use()
	if(!status)
		return 0
	if(stat & (EMPED|BROKEN|NOPOWER))
		return 0
	return 1

/proc/near_range_camera(var/mob/M)
	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/obj/machinery/camera/proc/get_channels()
	var/datum/extension/network_device/camera/D = get_extension(src, /datum/extension/network_device)
	return D.channels

// Resets the camera's wires to fully operational state. Used by one of Malfunction abilities.
/obj/machinery/camera/proc/reset_wires()
	if(!wires)
		return
	set_broken(FALSE) // Fixes the camera and updates the icon.
	wires.CutAll()
	wires.MendAll()
	update_coverage()

/obj/machinery/camera/proc/nano_structure()
	var/datum/extension/network_device/camera/D = get_extension(src, /datum/extension/network_device/)
	return D.nano_structure()

//Prevent literally anyone without access from tampering with the cameras if there's a network outage
/decl/stock_part_preset/network_lock/camera
	expected_part_type = /obj/item/stock_parts/network_receiver/network_lock

/decl/stock_part_preset/network_lock/camera/do_apply(obj/machinery/camera/machine, obj/item/stock_parts/network_receiver/network_lock/part)
	part.auto_deny_all = TRUE

/obj/machinery/camera
	public_methods = list(
		/decl/public_access/public_method/toggle_camera
	)

	public_variables = list(
		/decl/public_access/public_variable/camera_state,
		/decl/public_access/public_variable/camera_name,
		/decl/public_access/public_variable/camera_channels
	)

/obj/machinery/camera/proc/toggle_status()
	set_status(!status)

/decl/public_access/public_method/toggle_camera
	name = "toggle camera"
	desc = "Toggles camera on or off."
	call_proc = /obj/machinery/camera/proc/toggle_status

/decl/public_access/public_variable/camera_state
	expected_type = /obj/machinery/camera
	name = "camera status"
	desc = "Status of the camera."
	can_write = FALSE

/decl/public_access/public_variable/camera_state/access_var(obj/machinery/camera/C)
	return C.status ? "enabled" : "disabled"

/decl/public_access/public_variable/camera_name
	expected_type = /obj/machinery/camera
	name = "camera name"
	desc = "Displayed name of the camera."
	can_write = FALSE

/decl/public_access/public_variable/camera_name/access_var(obj/machinery/camera/C)
	var/datum/extension/network_device/camera/camera_device = get_extension(C, /datum/extension/network_device/)
	return camera_device?.display_name

/decl/public_access/public_variable/camera_channels
	expected_type = /obj/machinery/camera
	name = "camera channels"
	desc = "List of the channels this camera broadcasts on."
	can_write = FALSE

/decl/public_access/public_variable/camera_channels/access_var(obj/machinery/camera/C)
	var/datum/extension/network_device/camera/camera_device = get_extension(C, /datum/extension/network_device/)
	return english_list(camera_device?.channels)