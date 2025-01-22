/datum/wires/smes
	holder_type = /obj/machinery/power/smes/buildable
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(SMES_WIRE_RCON, "This wire runs to a remote signaling mechanism."),
		new /datum/wire_description(SMES_WIRE_INPUT, "This seems to be the primary input.", SKILL_EXPERT),
		new /datum/wire_description(SMES_WIRE_OUTPUT, "This seems to be the primary output.", SKILL_EXPERT),
		new /datum/wire_description(SMES_WIRE_GROUNDING, "This wire appeas to connect directly to the floor.", SKILL_EXPERT),
		new /datum/wire_description(SMES_WIRE_FAILSAFES, "This wire appears to connect to a failsafe mechanism.")
	)

/// Remote control (AI and consoles), cut to disable
var/global/const/SMES_WIRE_RCON      = BITFLAG(0)
/// Input wire, cut to disable input, pulse to disable for 60s
var/global/const/SMES_WIRE_INPUT     = BITFLAG(1)
/// Output wire, cut to disable output, pulse to disable for 60s
var/global/const/SMES_WIRE_OUTPUT    = BITFLAG(2)
/// Cut to quickly discharge causing sparks, pulse to only create few sparks
var/global/const/SMES_WIRE_GROUNDING = BITFLAG(3)
/// Cut to disable failsafes, mend to reenable
var/global/const/SMES_WIRE_FAILSAFES = BITFLAG(4)

/datum/wires/smes/CanUse(var/mob/living/user)
	var/obj/machinery/power/smes/buildable/storage = holder
	if(!storage.grounding && storage.powernet && storage.powernet.avail)
		electrocute_mob(user, storage.powernet, storage, (storage.safeties_enabled? 0.1 : 1))
	return storage.panel_open

/datum/wires/smes/GetInteractWindow(mob/user)
	var/obj/machinery/power/smes/buildable/storage = holder
	. += ..()
	. += "The green light is [(storage.input_cut || storage.input_pulsed || storage.output_cut || storage.output_pulsed) ? "off" : "on"]<br>"
	. += "The red light is [(storage.safeties_enabled || storage.grounding) ? "off" : "blinking"]<br>"
	. += "The blue light is [storage.RCon ? "on" : "off"]"

/datum/wires/smes/UpdateCut(var/index, var/mended)
	var/obj/machinery/power/smes/buildable/storage = holder
	switch(index)
		if(SMES_WIRE_RCON)
			storage.RCon = mended
		if(SMES_WIRE_INPUT)
			storage.input_cut = !mended
		if(SMES_WIRE_OUTPUT)
			storage.output_cut = !mended
		if(SMES_WIRE_GROUNDING)
			storage.grounding = mended
		if(SMES_WIRE_FAILSAFES)
			storage.safeties_enabled = mended

/datum/wires/smes/proc/reset_rcon()
	var/obj/machinery/power/smes/buildable/storage = holder
	if(storage)
		storage.RCon = TRUE

/datum/wires/smes/proc/reset_safeties()
	var/obj/machinery/power/smes/buildable/storage = holder
	if(storage)
		storage.safeties_enabled = TRUE

/datum/wires/smes/UpdatePulsed(var/index)
	var/obj/machinery/power/smes/buildable/storage = holder
	switch(index)
		if(SMES_WIRE_RCON)
			if(storage.RCon)
				storage.RCon = 0
				addtimer(CALLBACK(src, PROC_REF(reset_rcon)), 1 SECOND)
		if(SMES_WIRE_INPUT)
			storage.toggle_input()
		if(SMES_WIRE_OUTPUT)
			storage.toggle_output()
		if(SMES_WIRE_GROUNDING)
			storage.grounding = 0
		if(SMES_WIRE_FAILSAFES)
			if(storage.safeties_enabled)
				storage.safeties_enabled = 0
				addtimer(CALLBACK(src, PROC_REF(reset_safeties)), 1 SECOND)
