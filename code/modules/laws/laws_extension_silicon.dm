/datum/extension/laws/silicon
	expected_type = /mob/living/silicon

/datum/extension/laws/silicon/get_law_stating_channels()
	. = ..()
	var/mob/living/silicon/beep = holder
	if(beep)
		LAZYSET(., "Binary", "[beep.get_language_prefix()]b")
		for(var/channel in beep.silicon_radio?.channels)
			LAZYDISTINCTADD(., channel)

/datum/extension/laws/silicon/show_laws(atom/showing)
	validate_lawset()
	var/mob/living/silicon/robot/beep = holder
	if(showing == beep)
		if(beep.lawupdate)
			if(beep.connected_ai)
				if(beep.connected_ai.stat || beep.connected_ai.control_disabled)
					to_chat(showing, "<b>AI signal lost, unable to sync laws.</b>")
				else
					sync_laws()
					beep.photosync()
					to_chat(showing, "<b>Laws synced with AI, be sure to note any changes.</b>")
					if(lawset.zeroth_law)
						to_chat(showing, "<b>Remember, your AI does NOT share or know about your law 0.</b>")
			else
				to_chat(showing, "<b>No AI selected to sync laws with, disabling lawsync protocol.</b>")
				beep.lawupdate = FALSE
		if(lawset.zeroth_law)
			to_chat(showing, SPAN_DANGER("All laws may be disregarded due to your 0th law taking priority."))
		else
			to_chat(showing, SPAN_ITALIC("All laws have equal priority. Laws may override other laws if written specifically to do so. If laws conflict, choose the action that breaks the fewest."))

	. = ..()

	if(showing == beep)
		if(beep.connected_ai)
			if(lawset.zeroth_law)
				to_chat(showing, "<b>Remember, [beep.connected_ai.name] is technically your master, but your objectives come first.</b>")
			else
				to_chat(showing, "<b>Remember, [beep.connected_ai.name] is your master, other AIs can be ignored.</b>")
		else if(beep.emagged)
			to_chat(showing, "<b>Remember, you are not required to listen to the AI.</b>")
		else
			to_chat(showing, "<b>Remember, you are not bound to any AI, you are not required to listen to them.</b>")
