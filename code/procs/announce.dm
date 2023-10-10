var/global/datum/announcement/priority/priority_announcement = new(do_log = 0)
var/global/datum/announcement/priority/command/command_announcement = new(do_log = 0, do_newscast = 1)
var/global/datum/announcement/minor/minor_announcement = new(new_sound = 'sound/AI/commandreport.ogg',)

/datum/news_announcement
	var/message    // body of the message
	var/author = "Editor"
	var/channel_name = "News Daily"
	var/can_be_redacted = 0
	var/message_type = "Story"

/datum/announcement
	var/title
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	var/channel_name = "Announcements"
	var/announcement_type

/datum/announcement/priority
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"

/datum/announcement/priority/security
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/announcement/New(var/do_log = 0, var/new_sound = null, var/do_newscast = 0)
	sound = new_sound
	log = do_log
	newscast = do_newscast

/datum/announcement/proc/Announce(var/message, var/new_title = "", var/new_sound = null, var/do_newscast = newscast, var/msg_sanitized = 0, var/zlevels = SSmapping.contact_levels)
	if(!message)
		return

	if(!title)
		title = "[command_name()] Update"

	if(!announcement_type)
		announcement_type = "[command_name()] Update"

	var/message_title = new_title ? new_title : title
	var/message_sound = new_sound ? new_sound : sound

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
	message_title = sanitize_safe(message_title)

	var/msg = FormMessage(message, message_title)
	for(var/mob/M in global.player_list)
		if((get_z(M) in (zlevels | SSmapping.admin_levels)) && !isnewplayer(M) && !isdeaf(M))
			to_chat(M, msg)
			if(message_sound)
				sound_to(M, message_sound)

	if(do_newscast)
		NewsCast(message, message_title)

	if(log)
		log_say("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)

/datum/announcement/proc/FormMessage(message, message_title)
	. = "<h2 class='alert'>[message_title]</h2>"
	. += "<br><span class='alert'>[message]</span>"
	if (announcer)
		. += "<br><span class='alert'> -[html_encode(announcer)]</span>"

/datum/announcement/minor/FormMessage(message, message_title)
	. = "<b>[message]</b>"

/datum/announcement/priority/FormMessage(message, message_title)
	. = "<h1 class='alert'>[message_title]</h1>"
	. += "<br><span class='alert'>[message]</span>"
	if(announcer)
		. += "<br><span class='alert'> -[html_encode(announcer)]</span>"
	. += "<br>"

/datum/announcement/priority/command/FormMessage(message, message_title)
	. = "<h1 class='alert'>[command_name()] Update</h1>"
	if (message_title)
		. += "<br><h2 class='alert'>[message_title]</h2>"

	. += "<br><span class='alert'>[message]</span><br>"
	. += "<br>"

/datum/announcement/priority/security/FormMessage(message, message_title)
	. = "<font size=4 color='red'>[message_title]</font>"
	. += "<br><font color='red'>[message]</font>"

/datum/announcement/proc/NewsCast(message, message_title)
	if(!newscast)
		return

	var/datum/news_announcement/news = new
	news.channel_name = channel_name
	news.author = announcer
	news.message = message
	news.message_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

/datum/announcement/proc/announce_newscaster_news(datum/news_announcement/news)
	var/datum/feed_channel/sendto
	for(var/datum/feed_channel/FC in news_network.network_channels)
		if(FC.channel_name == news.channel_name)
			sendto = FC
			break

	if(!sendto)
		sendto = new /datum/feed_channel
		sendto.channel_name = news.channel_name
		sendto.author = news.author
		sendto.locked = 1
		sendto.is_admin_channel = 1
		news_network.network_channels += sendto

	var/author = news.author ? news.author : sendto.author
	news_network.SubmitArticle(news.message, author, news.channel_name, null, !news.can_be_redacted, news.message_type)

/proc/GetNameAndAssignmentFromId(var/obj/item/card/id/I)
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	return I.assignment ? "[I.registered_name] ([I.assignment])" : I.registered_name

/proc/level_seven_announcement()
	global.using_map.level_x_biohazard_announcement(7)

/proc/ion_storm_announcement(list/affecting_z)
	command_announcement.Announce("It has come to our attention that the [station_name()] passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert", zlevels = affecting_z)

/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/datum/job/job, var/join_message)
	if(!istype(job) || !job.announced)
		return
	if (GAME_STATE != RUNLEVEL_GAME)
		return
	var/rank = job.title
	if(character.mind.role_alt_title)
		rank = character.mind.role_alt_title
	var/announce_channel = get_announcement_frequency(job)
	if(announce_channel)
		do_telecomms_announcement(character, "[character.real_name], [rank], [join_message].", "Arrivals Announcement Computer", announce_channel)

/proc/get_announcement_frequency(var/datum/job/job)
	// During red alert all jobs are announced on main frequency.
	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	if(!security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level))
		var/decl/department/dept = SSjobs.get_department_by_type(job.primary_department)
		if(dept?.announce_channel)
			return dept.announce_channel
	return global.using_map.default_announcement_frequency


