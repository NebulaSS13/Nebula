// Wires for cameras.

/datum/wires/camera
	random = 1
	holder_type = /obj/machinery/camera
	wire_count = 6
	descriptions = list(
		new /datum/wire_description(CAMERA_WIRE_FOCUS, "This wire runs to the camera's lens adjustment motors."),
		new /datum/wire_description(CAMERA_WIRE_POWER, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(CAMERA_WIRE_LIGHT, "This wire seems connected to the built-in light.", SKILL_EXPERT),
		new /datum/wire_description(CAMERA_WIRE_ALARM, "This wire is connected to a remote signaling device of some sort.")
	)

/datum/wires/camera/GetInteractWindow(mob/user)

	. = ..()
	var/obj/machinery/camera/C = holder
	var/datum/extension/network_device/camera/D = get_extension(holder, /datum/extension/network_device/)
	. += "<br>\n[(D.view_range == C.long_range ? "The focus light is on." : "The focus light is off.")]"
	. += "<br>\n[(C.cut_power ? "The power link light is off." : "The power link light is on.")]"
	. += "<br>\n[(C.light_disabled ? "The camera light is off." : "The camera light is on.")]"
	. += "<br>\n[(C.alarm_on ? "The alarm light is on." : "The alarm light is off.")]"
	return .

/datum/wires/camera/CanUse(var/mob/living/L)
	var/obj/machinery/camera/C = holder
	return C.panel_open

var/global/const/CAMERA_WIRE_FOCUS = 1
var/global/const/CAMERA_WIRE_POWER = 2
var/global/const/CAMERA_WIRE_LIGHT = 4
var/global/const/CAMERA_WIRE_ALARM = 8

/datum/wires/camera/UpdateCut(var/index, var/mended)
	var/obj/machinery/camera/C = holder

	switch(index)
		if(CAMERA_WIRE_FOCUS)
			var/datum/extension/network_device/camera/D = get_extension(holder, /datum/extension/network_device)
			var/new_range = (mended ? C.long_range : C.short_range)
			D.set_view_range(new_range)

		if(CAMERA_WIRE_POWER)
			C.cut_power = !mended
			C.set_status(mended, usr)

		if(CAMERA_WIRE_LIGHT)
			C.light_disabled = !mended

		if(CAMERA_WIRE_ALARM)
			if(!mended)
				C.triggerCameraAlarm()
			else
				C.cancelCameraAlarm()
	return

/datum/wires/camera/UpdatePulsed(var/index)
	var/obj/machinery/camera/C = holder
	if(IsIndexCut(index))
		return
	switch(index)
		if(CAMERA_WIRE_FOCUS)
			var/datum/extension/network_device/camera/D = get_extension(holder, /datum/extension/network_device)
			var/new_range = (D.view_range == C.long_range ? C.short_range : C.long_range)
			D.set_view_range(new_range)

		if(CAMERA_WIRE_LIGHT)
			C.light_disabled = !C.light_disabled

		if(CAMERA_WIRE_ALARM)
			C.visible_message("[html_icon(C)] *beep*", "[html_icon(C)] *beep*")
	return