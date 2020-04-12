/obj/item/card/id/exonet
	var/user_id													// The user's ID this card belongs to. This is typically their access_record UID, which is their cortical stack ID.
	var/ennid													// The exonet network ID this card is linked to.
	var/broken = FALSE											// Whether or not this card has been broken.
	var/datum/computer_file/report/crew_record/access_record 	// A cached link to the access_record belonging to this card. Do not save this.

/obj/item/card/id/exonet/Initialize()
	if(!access_record)
		refresh_access_record()
	return ..()

/obj/item/card/id/exonet/GetAccess()
	if(broken)
		return
	if(!access_record)
		refresh_access_record()
	return access

/obj/item/card/id/exonet/verb/resync()
	set name = "Resync ID Card"
	set category = "Object"
	set src in usr

	if(broken || !ennid)
		to_chat(usr, "Pressing the synchronization button on the card does nothing.")
		return

	var/datum/exonet/network = GLOB.exonets[ennid]
	if(!network)
		to_chat(usr, "Pressing the synchronization button on the card causes a red LED to flash once.")
		return

	var/signal_strength = network.get_signal_strength(src, NETWORKSPEED_HIGHSIGNAL)
	if(signal_strength <= 0)
		to_chat(usr, "Pressing the synchronization button on the card causes a red LED to flash three times.")
		return

	refresh_access_record()
	to_chat(usr, "A green light flashes as the card is synchronized with its network.")

/obj/item/card/id/exonet/proc/refresh_access_record()
	var/datum/exonet/network = GLOB.exonets[ennid]
	if(!network)
		// This card is totally lost.
		access = null
		broken = TRUE
		return
	for(var/obj/machinery/computer/exonet/mainframe/mainframe in network.mainframes)
		for(var/datum/computer_file/report/crew_record/ar in mainframe.stored_files)
			if(ar.user_id != user_id)
				continue // Mismatch user file.
			// We have a match!
			access_record = ar
			access = ar.get_access()
			return
	// No record was found. This card is no longer good.
	access = null
	broken = TRUE