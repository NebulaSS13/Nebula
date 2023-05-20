/// check if this radio can receive on the given analog frequency
/// @level: list of eligible z-levels, if it contains 0 then it reaches all levels
/obj/item/radio/proc/can_receive_analog(datum/radio_frequency/connection, level)
	if(!analog || !istype(analog_radio_connection) || connection != analog_radio_connection)
		return FALSE
	if(!listening)
		return FALSE
	if (!on)
		return FALSE
	if(QDELETED(src))
		return FALSE
	if (wires.IsIndexCut(WIRE_RECEIVE))
		return FALSE
	if(!(0 in level) && !(get_z(src) in level))
		return FALSE
	return TRUE

/proc/broadcast_analog_radio_message(datum/radio_frequency/connection, mob/speaker,
	obj/item/radio/radio, message, intercom_only = FALSE,
	hard_to_hear, list/levels, verbage = "says", decl/language/speaking = null, list/secured
	)

	var/list/radios = list()
	for(var/obj/item/radio/radio_receiver in connection.devices["[RADIO_CHAT]"])
		// Quasi-wired mode; remove if intercoms ever use actual wired connections somehow.
		if(intercom_only && !radio_receiver.intercom)
			continue
		if(!radio_receiver.analog)
			continue
		if(radio_receiver == radio)
			continue
		if(!radio_receiver.can_receive_message())
			continue
		if(secured && !radio_receiver.can_decrypt(secured))
			continue
		if(radio_receiver.can_receive_analog(connection, levels))
			radios += radio_receiver
			radio_receiver.received_chatter(connection.frequency, levels)

	// Get a list of mobs who can hear from the radios we collected.
	var/list/receive = get_mobs_in_analog_radio_ranges(radios)

	// Format the message
	var/formatted_msg = "<span style='color:[COMMS_COLOR_ANALOG]'><small><b>\[[format_frequency(connection.frequency)]\]</b></small> <span class='name'>"
	var/send_name = istype(speaker) ? speaker.real_name : ("[speaker]" || "unknown")

	// Send to all recipients
	for (var/mob/receiver in receive)
		receiver.hear_radio(message, verbage, speaking, formatted_msg, "</span> <span class='message'>", "</span></span>", speaker, hard_to_hear, send_name)

	return TRUE

/// Returns a list of mobs who can hear any of the radios given in @radios
/// Assume all the radios in the list are eligible; we just care about mobs
/proc/get_mobs_in_analog_radio_ranges(list/obj/item/radio/radios)
	. = list()
	for(var/obj/item/radio/receiver_candidate in radios)
		if(receiver_candidate.virtual)
			continue // We end up in this list because we need to receive signals, but should never actually display a message.
		var/turf/speaking_from = get_turf(receiver_candidate)
		if(speaking_from)
			// Try to find all the players who can hear the message
			for(var/mob/local_listener in hearers(receiver_candidate.canhear_range, speaking_from))
				. |= local_listener

	for(var/mob/observer/ghost/ghost_listener as anything in global.ghost_mob_list)
		// Ghostship is magic: Ghosts can hear radio chatter from anywhere
		if(ghost_listener.get_preference_value(/datum/client_preference/ghost_radio) == PREF_ALL_CHATTER)
			. |= ghost_listener
	return .