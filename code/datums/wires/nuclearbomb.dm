/datum/wires/nuclearbomb
	holder_type = /obj/machinery/nuclearbomb
	random = 1
	wire_count = 7
	descriptions = list(
		new /datum/wire_description(NUCLEARBOMB_WIRE_LIGHT, "This wire seems to connect to the small light on the device.", SKILL_EXPERT),
		new /datum/wire_description(NUCLEARBOMB_WIRE_TIMING, "This wire connects to the time display."),
		new /datum/wire_description(NUCLEARBOMB_WIRE_SAFETY, "This wire connects to a safety override.")
	)

var/const/NUCLEARBOMB_WIRE_LIGHT		= 1
var/const/NUCLEARBOMB_WIRE_TIMING		= 2
var/const/NUCLEARBOMB_WIRE_SAFETY		= 4

/datum/wires/nuclearbomb/CanUse(var/mob/living/L)
	var/obj/machinery/nuclearbomb/N = holder
	return N.panel_open && N.extended

/datum/wires/nuclearbomb/GetInteractWindow(mob/user)
	var/obj/machinery/nuclearbomb/N = holder
	. += ..()
	. += "<BR>The device is [N.timing ? "shaking!" : "still."]<BR>"
	. += "The device is is [N.safety ? "quiet" : "whirring"].<BR>"
	. += "The lights are [N.lighthack ? "static" : "functional"].<BR>"

/datum/wires/nuclearbomb/proc/toggle_hacked()
	var/obj/machinery/nuclearbomb/N = holder
	if(N)
		N.lighthack = !N.lighthack
		N.update_icon()

/datum/wires/nuclearbomb/proc/toggle_safety()
	var/obj/machinery/nuclearbomb/N = holder
	if(N)
		N.safety = !N.safety
		if(N.safety == 1)
			N.visible_message(SPAN_NOTICE("\The [N] quiets down."))
			N.secure_device()
		else
			N.visible_message(SPAN_NOTICE("\The [N] emits a quiet whirling noise!"))

/datum/wires/nuclearbomb/proc/log_and_explode(var/msg)
	set waitfor = FALSE
	var/obj/machinery/nuclearbomb/N = holder
	if(N)
		log_and_message_admins(msg)
		N.explode()

/datum/wires/nuclearbomb/UpdatePulsed(var/index)
	var/obj/machinery/nuclearbomb/N = holder
	switch(index)
		if(NUCLEARBOMB_WIRE_LIGHT)
			N.lighthack = !N.lighthack
			N.update_icon()
			toggle_hacked()
			addtimer(CALLBACK(src, .proc/toggle_hacked), 10 SECONDS)

		if(NUCLEARBOMB_WIRE_TIMING)
			if(N.timing)
				log_and_explode("pulsed a nuclear bomb's detonation wire, causing it to explode.")
		if(NUCLEARBOMB_WIRE_SAFETY)
			N.safety = !N.safety
			addtimer(CALLBACK(src, .proc/toggle_safety), 10 SECONDS)

/datum/wires/nuclearbomb/UpdateCut(var/index, var/mended)
	var/obj/machinery/nuclearbomb/N = holder
	switch(index)
		if(NUCLEARBOMB_WIRE_SAFETY)
			N.safety = mended
			if(N.timing)
				log_and_explode("cut a nuclear bomb's timing wire, causing it to explode.")
		if(NUCLEARBOMB_WIRE_TIMING)
			N.secure_device()
		if(NUCLEARBOMB_WIRE_LIGHT)
			N.lighthack = !mended
			N.update_icon()
