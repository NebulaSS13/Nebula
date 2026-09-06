/obj/machinery/camera
	name = "security camera"
	desc = "A classic security camera used to monitor rooms. It's directly wired to the local area's alarm system."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "camera"
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 5
	active_power_usage = 10
	layer = CAMERA_LAYER
	anchored = TRUE
	movable_flags = MOVABLE_FLAG_PROXMOVE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"SOUTH":{"y":21}, "EAST":{"x":-10}, "WEST":{"x":10}}'
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

	var/emp_timer_id = null

	/// The threshold that installed scanning modules need to met or exceed in order for the camera to see through walls.
	var/const/XRAY_THRESHOLD = 2

	/// The threshold that installed capacitors need to met or exceed in order for the camera to be immunie to EMP.
	var/const/EMP_PROOF_THRESHOLD = 2

/obj/machinery/camera/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(stat & BROKEN)
		. += SPAN_WARNING("It is completely demolished.")

/obj/machinery/camera/apply_visual(mob/living/human/M)
	if(!M.client || !istype(M))
		return
	M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
	M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
	M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
	M.machine_visual = src
	return 1

/obj/machinery/camera/remove_visual(mob/living/human/M)
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
			var/suffix = uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, "c_tag [A.proper_name]", 1) // unlike sequential_id, starts at 1 instead of 100
			if(suffix == 1)
				suffix = null
			c_tag = "[A.proper_name][suffix ? " [suffix]" : null]"
		// Add a default c_tag in case the camera has been placed in an invalid location or inside another object.
		c_tag ||= "Security Camera - [random_id(/obj/machinery/camera, 100,999)]"

		invalidateCameraCache()
	set_extension(src, /datum/extension/network_device/camera, null, null, null, TRUE, preset_channels, c_tag, cameranet_enabled, requires_connection)
	RefreshParts()

/obj/machinery/camera/Destroy()
	set_camera_status(0) //kick anyone viewing out
	deltimer(emp_timer_id)
	return ..()

/obj/machinery/camera/Process()
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
	if (isAI(target))
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
	if(stat_immune & EMPED)
		return
	if(prob(100 / severity))
		stat |= EMPED
		set_light(0)
		triggerCameraAlarm()
		update_icon()
		update_coverage()

		var/emp_length = 90 SECONDS / severity
		emp_timer_id = addtimer(CALLBACK(src, PROC_REF(emp_expired)), emp_length, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)
	..()

/obj/machinery/camera/proc/emp_expired()
	stat &= ~EMPED
	cancelCameraAlarm()
	update_icon()
	update_coverage()

	if (detectTime > 0)
		var/elapsed = world.time - detectTime
		if (elapsed > alarm_delay)
			triggerAlarm()


/obj/machinery/camera/bullet_act(var/obj/item/projectile/P)
	take_damage(P.get_structure_damage(), P.atom_damage_type)

/obj/machinery/camera/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || prob(50)))
		set_broken(TRUE)

/obj/machinery/camera/hitby(var/atom/movable/AM)
	. = ..()
	if(. && isobj(AM))
		var/thrown_force = AM.get_thrown_attack_force()
		if (thrown_force >= toughness)
			visible_message(SPAN_DANGER("\The [src] was hit by \the [AM]!"))
			var/obj/O = AM
			take_damage(thrown_force, O.atom_damage_type)

/obj/machinery/camera/physical_attack_hand(mob/living/human/user)
	if(!istype(user))
		return TRUE
	if(user.can_shred())
		user.do_attack_animation(src)
		visible_message(SPAN_WARNING("\The [user] slashes at [src]!"))
		playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
		add_hiddenprint(user)
		take_damage(25)
		return TRUE
	return FALSE

/obj/machinery/camera/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/paper))
		var/datum/extension/network_device/camera/D = get_extension(src, /datum/extension/network_device)
		D.show_paper(used_item, user)
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

/obj/machinery/camera/proc/set_camera_status(var/newstatus, var/mob/user)
	if (status != newstatus && (!cut_power || status == TRUE))
		status = newstatus
		// The only way for AI to reactivate cameras are malf abilities, this gives them different messages.
		if(isAI(user))
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
	var/base_state = initial(icon_state)
	if(total_component_rating_of_type(/obj/item/stock_parts/scanning_module) >= XRAY_THRESHOLD)
		base_state = "xraycam"
	if (!status || (stat & BROKEN))
		icon_state = "[base_state]1"
	else if (stat & EMPED)
		icon_state = "[base_state]emp"
	else
		icon_state = base_state

/obj/machinery/camera/RefreshParts()
	. = ..()
	var/power_mult = 1
	var/emp_protection = total_component_rating_of_type(/obj/item/stock_parts/capacitor)
	if(emp_protection >= EMP_PROOF_THRESHOLD)
		stat_immune |= EMPED
	else
		stat_immune &= ~EMPED
	var/xray_rating = total_component_rating_of_type(/obj/item/stock_parts/scanning_module)
	var/datum/extension/network_device/camera/camera_device = get_extension(src, /datum/extension/network_device/)
	if(camera_device)
		if(xray_rating >= XRAY_THRESHOLD)
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
	set_camera_status(!status)

/decl/public_access/public_method/toggle_camera
	name = "toggle camera"
	desc = "Toggles camera on or off."
	call_proc = TYPE_PROC_REF(/obj/machinery/camera, toggle_status)

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
	return english_list(C.get_channels())