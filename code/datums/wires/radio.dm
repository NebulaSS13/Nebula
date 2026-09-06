/datum/wires/radio
	holder_type = /obj/item/radio
	wire_count = 3
	descriptions = list(
		new /datum/wire_description(WIRE_SIGNAL, "This wire connects several radio components."),
		new /datum/wire_description(WIRE_RECEIVE, "This wire runs to the radio receiver.", SKILL_EXPERT),
		new /datum/wire_description(WIRE_TRANSMIT, "This wire runs to the radio transmitter.")
	)

var/global/const/WIRE_SIGNAL = 1
var/global/const/WIRE_RECEIVE = 2
var/global/const/WIRE_TRANSMIT = 4

/datum/wires/radio/CanUse(var/mob/living/L)
	var/obj/item/radio/radio = holder
	if(radio.panel_open)
		return 1
	return 0

/datum/wires/radio/UpdatePulsed(var/index)
	var/obj/item/radio/radio = holder
	switch(index)
		if(WIRE_SIGNAL)
			radio.listening = !radio.listening && !IsIndexCut(WIRE_RECEIVE)
			radio.broadcasting = radio.listening && !IsIndexCut(WIRE_TRANSMIT)

		if(WIRE_RECEIVE)
			radio.listening = !radio.listening && !IsIndexCut(WIRE_SIGNAL)

		if(WIRE_TRANSMIT)
			radio.broadcasting = !radio.broadcasting && !IsIndexCut(WIRE_SIGNAL)
	SSnano.update_uis(holder)

/datum/wires/radio/UpdateCut(var/index, var/mended)
	var/obj/item/radio/radio = holder
	switch(index)
		if(WIRE_SIGNAL)
			radio.listening = mended && !IsIndexCut(WIRE_RECEIVE)
			radio.broadcasting = mended && !IsIndexCut(WIRE_TRANSMIT)

		if(WIRE_RECEIVE)
			radio.listening = mended && !IsIndexCut(WIRE_SIGNAL)

		if(WIRE_TRANSMIT)
			radio.broadcasting = mended && !IsIndexCut(WIRE_SIGNAL)
	SSnano.update_uis(holder)