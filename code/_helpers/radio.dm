/proc/do_telecomms_announcement(var/atom/target, var/message, var/speaker_name, var/channel)
	var/obj/item/radio/announcer = get_announcer(target)
	if(announcer)
		if(islist(channel))
			for(var/single_channel in channel)
				announcer.autosay(message, speaker_name, single_channel)
		else
			announcer.autosay(message, speaker_name, channel)
		return TRUE
	return FALSE
