/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation hub and station."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"

	var/obj/machinery/tele_projector/projector
	var/obj/machinery/tele_pad/pad
	var/atom/target
	var/active
	var/teleporter_id


/obj/machinery/computer/teleporter/Destroy()
	clear_target()
	if (projector)
		projector.lost_computer()
	clear_projector()
	if (pad)
		pad.lost_computer()
	clear_pad()
	return ..()


/obj/machinery/computer/teleporter/Initialize()
	. = ..()
	teleporter_id = "[random_id(/obj/machinery/computer/teleporter, 1000, 9999)]"
	update_refs()


/obj/machinery/computer/teleporter/proc/update_refs()
	for (var/dir in GLOB.cardinal)
		var/obj/machinery/tele_projector/new_projector = locate() in get_step(src, dir)
		if (new_projector)
			set_projector(new_projector)
			break
	if (projector)
		var/pad_dir
		for (var/dir in GLOB.cardinal)
			var/obj/machinery/tele_pad/new_pad = locate() in get_step(projector, dir)
			if (new_pad)
				set_pad(new_pad)
				pad_dir = dir
				break
		if (pad)
			projector.set_computer(src)
			projector.set_dir(pad_dir)
			pad.set_computer(src)
			projector.update_active()
			pad.update_icon()


/obj/machinery/computer/teleporter/proc/clear_projector()
	if (!projector)
		return
	GLOB.destroyed_event.unregister(projector, src, /obj/machinery/computer/teleporter/proc/lost_projector)
	projector = null
	set_active(FALSE)


/obj/machinery/computer/teleporter/proc/lost_projector()
	audible_message(SPAN_WARNING("\The [src] buzzes, \"Projector missing.\""))
	clear_projector()


/obj/machinery/computer/teleporter/proc/set_projector(obj/machinery/tele_projector/_projector)
	if (projector == _projector)
		return
	clear_projector()
	projector = _projector
	GLOB.destroyed_event.register(projector, src, /obj/machinery/computer/teleporter/proc/lost_projector)


/obj/machinery/computer/teleporter/proc/clear_pad()
	if (!pad)
		return
	GLOB.destroyed_event.unregister(pad, src, /obj/machinery/computer/teleporter/proc/lost_pad)
	pad = null
	set_active(FALSE)


/obj/machinery/computer/teleporter/proc/lost_pad()
	audible_message(SPAN_WARNING("\The [src] buzzes, \"Pad missing.\""))
	clear_pad()


/obj/machinery/computer/teleporter/proc/set_pad(obj/machinery/tele_pad/_pad)
	if (pad == _pad)
		return
	clear_pad()
	pad = _pad
	GLOB.destroyed_event.register(pad, src, /obj/machinery/computer/teleporter/proc/lost_pad)


/obj/machinery/computer/teleporter/proc/clear_target()
	if (!target)
		return
	GLOB.destroyed_event.unregister(target, src, /obj/machinery/computer/teleporter/proc/lost_target)
	target = null
	set_active(FALSE)


/obj/machinery/computer/teleporter/proc/lost_target()
	audible_message(SPAN_WARNING("\The [src] buzzes, \"Target lost.\""))
	clear_target()


/obj/machinery/computer/teleporter/proc/set_target(atom/_target)
	if (target == _target)
		return
	clear_target()
	target = _target
	GLOB.destroyed_event.register(target, src, /obj/machinery/computer/teleporter/proc/lost_target)


/obj/machinery/computer/teleporter/proc/set_active(_active, notify)
	var/effective = _active && target && projector && pad
	if (active == effective)
		return
	active = effective
	if (notify && effective)
		if (active)
			visible_message(SPAN_NOTICE("The teleporter sparks and hums to life."))
		else
			visible_message(SPAN_WARNING("The teleporter sputters and fails."))
	if (projector)
		projector.update_active()
	if (pad)
		pad.update_icon()


/obj/machinery/computer/teleporter/proc/get_targets()
	var/list/ids = list()
	var/list/result = list()
	for (var/atom/B in get_valid_teleporter_beacons())
		var/area/A = get_area(B)
		var/target_name = A.name
		if (istype(B, /obj/item/implant/tracking) && istype(B.loc, /mob))
			var/mob/M = B.loc
			target_name = M.name
		var/id_val = ids[target_name] + 1
		ids[target_name] = id_val
		result["[target_name] \[[id_val]\]"] = B
	return result


/obj/machinery/computer/teleporter/power_change()
	. = ..()
	if (. && (stat & NOPOWER))
		clear_target()


/obj/machinery/computer/teleporter/interface_interact(mob/user)
	if (!projector || !pad)
		var/data_search = alert(user, "Projector or pad missing. Search?", "Teleporter", "Yes", "No")
		if (isnull(data_search) || !CanInteract(user, DefaultTopicState()))
			return TRUE
		if (data_search == "Yes")
			update_refs()
		return TRUE

	var/message_status = "Idle"
	if (target && active)
		message_status = "Engaged"
	else if (target)
		message_status = "Locked"
	var/message_name = target ? "\n[get_area(target)]" : null
	var/message = "Teleporter [message_status][message_name]"

	var/btn_active = "-"
	if (active)
		btn_active = "Shut Down"
	else if (target)
		btn_active = "Start Up"
	var/btn_target = active ? "-" : "Set Target"
	var/data_action = alert(user, message, "Teleporter", btn_active, "Cancel", btn_target)

	if (isnull(data_action) || !CanInteract(user, DefaultTopicState()))
		return TRUE
	switch (data_action)
		if ("-", "Cancel")
			return
		if ("Shut Down")
			set_active(FALSE, TRUE)
		if ("Start Up")
			set_active(TRUE, TRUE)
		if ("Set Target")
			var/list/targets = get_targets()
			var/data_target = input(user, "Select Target", "Teleporter") in null | targets
			if (isnull(data_target) || !CanInteract(user, DefaultTopicState()))
				return TRUE
			audible_message(SPAN_NOTICE("\The [src] hums, \"Target updated.\""))
			set_target(targets[data_target])
