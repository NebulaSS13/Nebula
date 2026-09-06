//##############################################
//################### NEWSCASTERS BE HERE! ####
//###-Agouri###################################

/datum/feed_message
	var/author =""
	var/body =""
	var/message_type ="Story"
	var/datum/feed_channel/parent_channel
	var/is_admin_message = 0
	var/icon/img = null
	var/icon/caption = ""
	var/time_stamp = ""
	var/backup_body = ""
	var/backup_author = ""
	var/icon/backup_img = null
	var/icon/backup_caption = ""

/datum/feed_channel
	var/channel_name=""
	var/list/datum/feed_message/messages = list()
	var/locked=0
	var/author=""
	var/backup_author=""
	var/views=0
	var/censored=0
	var/is_admin_channel=0
	var/updated = 0
	var/announcement = ""

/datum/feed_message/proc/clear()
	src.author = ""
	src.body = ""
	src.caption = ""
	src.img = null
	src.time_stamp = ""
	src.backup_body = ""
	src.backup_author = ""
	src.backup_caption = ""
	src.backup_img = null
	parent_channel.update()

/datum/feed_channel/proc/update()
	updated = world.time

/datum/feed_channel/proc/clear()
	src.channel_name = ""
	src.messages = list()
	src.locked = 0
	src.author = ""
	src.backup_author = ""
	src.censored = 0
	src.is_admin_channel = 0
	src.announcement = ""
	update()

/datum/feed_network
	var/list/datum/feed_channel/network_channels = list()
	var/datum/feed_message/wanted_issue

/datum/feed_network/New()
	CreateFeedChannel("Announcements", "SS13", 1, 1, "New Announcement Available")

/datum/feed_network/proc/CreateFeedChannel(var/channel_name, var/author, var/locked, var/adminChannel = 0, var/announcement_message)
	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = channel_name
	newChannel.author = author
	newChannel.locked = locked
	newChannel.is_admin_channel = adminChannel
	if(announcement_message)
		newChannel.announcement = announcement_message
	else
		newChannel.announcement = "Breaking news from [channel_name]!"
	network_channels += newChannel

/datum/feed_network/proc/SubmitArticle(var/msg, var/author, var/channel_name, var/obj/item/photo/photo, var/adminMessage = 0, var/message_type = "")
	var/datum/feed_message/newMsg = new /datum/feed_message
	newMsg.author = author
	newMsg.body = msg
	newMsg.time_stamp = "[stationtime2text()]"
	newMsg.is_admin_message = adminMessage
	if(message_type)
		newMsg.message_type = message_type
	if(photo)
		newMsg.img = photo.img
		newMsg.caption = photo.scribble
	for(var/datum/feed_channel/FC in network_channels)
		if(FC.channel_name == channel_name)
			insert_message_in_channel(FC, newMsg) //Adding message to the network's appropriate feed_channel
			break

/datum/feed_network/proc/insert_message_in_channel(var/datum/feed_channel/FC, var/datum/feed_message/newMsg)
	FC.messages += newMsg
	if(newMsg.img)
		register_asset("newscaster_photo_[sanitize(FC.channel_name)]_[FC.messages.len].png", newMsg.img)
	newMsg.parent_channel = FC
	FC.update()
	alert_readers(FC.announcement)

/datum/feed_network/proc/alert_readers(var/annoncement)
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert(annoncement)
		NEWSCASTER.update_icon()

var/global/datum/feed_network/news_network = new /datum/feed_network     //The global news-network, which is coincidentally a global list.

var/global/list/allCasters = list() //Global list that will contain reference to all newscasters in existence.


/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard newsfeed handler. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_normal"
	var/const/SCREEN_WELCOME             = 0
	var/const/SCREEN_VIEW_CHANNELS       = 1
	var/const/SCREEN_CREATE_CHANNEL      = 2
	var/const/SCREEN_CREATE_STORY        = 3
	var/const/SCREEN_STORY_SUBMITTED     = 4
	var/const/SCREEN_CHANNEL_SUBMITTED   = 5
	var/const/SCREEN_STORY_FAILED        = 6
	var/const/SCREEN_CHANNEL_FAILED      = 7
	var/const/SCREEN_CHOOSE_PRINT        = 8
	var/const/SCREEN_VIEW_STORIES        = 9
	var/const/SCREEN_CENSOR_STORY        = 10
	var/const/SCREEN_CENSOR_CHANNEL      = 11
	var/const/SCREEN_PICK_CENSOR_CHANNEL = 12
	var/const/SCREEN_PICK_CENSOR_STORY   = 13
	var/const/SCREEN_MAKE_WANTED_ISSUE   = 14
	var/const/SCREEN_WANTED_CONFIRMED    = 15
	var/const/SCREEN_WANTED_FAILED       = 16
	var/const/SCREEN_WANTED_DELETED      = 17
	var/const/SCREEN_WANTED_VIEW         = 18
	var/const/SCREEN_WANTED_EDITED       = 19
	var/const/SCREEN_PRINT_COMPLETE      = 20
	var/const/SCREEN_PRINT_FAILED        = 21
	var/screen = SCREEN_WELCOME
	var/paper_remaining = 0
	/// (BOOL) Whether or not the newscaster can be used to create wanted issues.
	var/securityCaster = FALSE
	/// The unique unit number identifying a specific newscaster, useful for forensics.
	var/unit_no = 0
	var/alert_delay = 1 MINUTE
	/// Whether or not the alert overlay state should be used to inform about a recent news/wanted update in the last alert_delay.
	var/alert = FALSE
	/// The name (based on an ID) of the user currently operating the newscaster.
	var/scanned_user = "Unknown"

	// Temporary variables used while creating a new story.
	/// The text content of the feed message to create.
	var/tmp/msg = ""                 //Feed message
	/// The photo to attach to the news story. A wrapper for a photo object with additional metadata.
	var/tmp/datum/news_photo/photo_data = null

	// Temporary variable used while creating a new channel.
	/// Whether or not the currently-being-created channel will be locked to public submissions.
	var/tmp/c_locked = FALSE

	// Temporary variable used for both creating a new channel and creating a new story.
	/// The name of the feed channel to either create, or submit a new story to.
	var/tmp/channel_name = ""

	/// A hit counter that determines cosmetic damage overlays, up to 3. Currently never incremented.
	var/hitstaken = 0

	/// The channel that's currently open.
	var/tmp/datum/feed_channel/viewing_channel = null
	light_range = 0
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	layer = ABOVE_WINDOW_LAYER

	construct_state = /decl/machine_construction/wall_frame/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	frame_type = /obj/item/frame/stock_offset/newscaster
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":32}, "WEST":{"x":-32}}'

/obj/machinery/newscaster/Initialize()
	. = ..()
	var/area/A = get_area(src)
	securityCaster = istype(A) && (A.area_flags & AREA_FLAG_SECURITY)
	allCasters += src
	paper_remaining = 15            // Will probably change this to something better
	unit_no = "[sequential_id("obj/machinery/newscaster")]"
	queue_icon_update()

/obj/machinery/newscaster/Destroy()
	allCasters -= src
	. = ..()

/obj/machinery/newscaster/on_update_icon()
	if(inoperable())
		icon_state = "newscaster_off"
		if(reason_broken & MACHINE_BROKEN_GENERIC) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			overlays.Cut()
			overlays += image(src.icon, "crack3")
		return

	src.overlays.Cut() //reset overlays

	if(news_network.wanted_issue) //wanted icon state, there can be no overlays on it as it's a priority message
		icon_state = "newscaster_wanted"
		return

	if(alert) //new message alert overlay
		src.overlays += "newscaster_alert"

	if(hitstaken > 0) //Cosmetic damage overlay
		src.overlays += image(src.icon, "crack[hitstaken]")

	icon_state = "newscaster_normal"
	return

/obj/machinery/newscaster/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/newscaster/interact(mob/user)            //########### THE MAIN BEEF IS HERE! And in the proc below this...############
	if(ishuman(user) || issilicon(user) )
		var/mob/living/human_or_robot_user = user
		var/dat
		dat = text("<HEAD><TITLE>Newscaster</TITLE></HEAD><H3>Newscaster Unit #[src.unit_no]</H3>")

		src.scan_user(human_or_robot_user) //Newscaster scans you

		switch(screen)
			if(SCREEN_WELCOME)
				dat += "Welcome to Newscasting Unit #[src.unit_no].<BR> Interface & News networks Operational."
				if(news_network.wanted_issue)
					dat+= "<HR><A href='byond://?src=\ref[src];view_wanted=1'>Read Wanted Issue</A>"
				dat+= "<HR><BR><A href='byond://?src=\ref[src];create_channel=1'>Create Feed Channel</A>"
				dat+= "<BR><A href='byond://?src=\ref[src];view=1'>View Feed Channels</A>"
				dat+= "<BR><A href='byond://?src=\ref[src];create_feed_story=1'>Submit new Feed story</A>"
				dat+= "<BR><A href='byond://?src=\ref[src];menu_paper=1'>Print newspaper</A>"
				dat+= "<BR><A href='byond://?src=\ref[src];refresh=1'>Re-scan User</A>"
				dat+= "<BR><BR><A href='byond://?src=\ref[human_or_robot_user];mach_close=newscaster_main'>Exit</A>"
				if(src.securityCaster)
					var/wanted_already = 0
					if(news_network.wanted_issue)
						wanted_already = 1

					dat+="<HR><B>Feed Security functions:</B><BR>"
					dat+="<BR><A href='byond://?src=\ref[src];menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>"
					dat+="<BR><A href='byond://?src=\ref[src];menu_censor_story=1'>Censor Feed Stories</A>"
					dat+="<BR><A href='byond://?src=\ref[src];menu_censor_channel=1'>Mark Feed Channel with [global.using_map.company_name] D-Notice</A>"
				dat+="<BR><HR>The newscaster recognises you as: <FONT COLOR='green'>[src.scanned_user]</FONT>"
			if(SCREEN_VIEW_CHANNELS)
				dat+= "Local Feed Channels<HR>"
				if( !length(news_network.network_channels) )
					dat+="<I>No active channels found...</I>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						if(CHANNEL.is_admin_channel)
							dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen '><A href='byond://?src=\ref[src];show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
						else
							dat+="<B><A href='byond://?src=\ref[src];show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR></B>"
				dat+="<BR><HR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Back</A>"
			if(SCREEN_CREATE_CHANNEL)
				dat+="Creating new Feed Channel..."
				dat+="<HR><B><A href='byond://?src=\ref[src];set_channel_name=1'>Channel Name</A>:</B> [src.channel_name]<BR>"
				dat+="<B>Channel Author:</B> <FONT COLOR='green'>[src.scanned_user]</FONT><BR>"
				dat+="<B><A href='byond://?src=\ref[src];set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.c_locked) ? ("NO") : ("YES")]<BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];submit_new_channel=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Cancel</A><BR>"
			if(SCREEN_CREATE_STORY)
				dat+="Creating new Feed Message..."
				dat+="<HR><B><A href='byond://?src=\ref[src];set_channel_receiving=1'>Receiving Channel</A>:</B> [src.channel_name]<BR>" //MARK
				dat+="<B>Message Author:</B> <FONT COLOR='green'>[src.scanned_user]</FONT><BR>"
				dat+="<B><A href='byond://?src=\ref[src];set_new_message=1'>Message Body</A>:</B> [src.msg] <BR>"
				dat+="<B>Photo</B>: "
				if(photo_data && photo_data.photo)
					send_rsc(user, photo_data.photo.img, "tmp_photo.png")
					dat+="<BR><img src='tmp_photo.png' width = '180'>"
					dat+="<BR><B><A href='byond://?src=\ref[src];set_attachment=1'>Delete Photo</A></B></BR>"
				else
					dat+="<A href='byond://?src=\ref[src];set_attachment=1'>Attach Photo</A>"
				dat+="<BR><BR><A href='byond://?src=\ref[src];submit_new_message=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Cancel</A><BR>"
			if(SCREEN_STORY_SUBMITTED)
				dat+="Feed story successfully submitted to [src.channel_name].<BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A><BR>"
			if(SCREEN_CHANNEL_SUBMITTED)
				dat+="Feed Channel [src.channel_name] created successfully.<BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A><BR>"
			if(SCREEN_STORY_FAILED)
				dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
				if(src.channel_name=="")
					dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Channel author unverified.</FONT><BR>"
				if(src.msg == "" || src.msg == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"

				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_CREATE_STORY]'>Return</A><BR>"
			if(SCREEN_CHANNEL_FAILED)
				dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
				var/list/existing_authors = list()
				for(var/datum/feed_channel/FC in news_network.network_channels)
					if(FC.author == "\[REDACTED\]")
						existing_authors += FC.backup_author
					else
						existing_authors += FC.author
				if(src.scanned_user in existing_authors)
					dat+="<FONT COLOR='maroon'>There already exists a Feed channel under your name.</FONT><BR>"
				if(src.channel_name=="" || src.channel_name == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
				var/check = 0
				for(var/datum/feed_channel/FC in news_network.network_channels)
					if(FC.channel_name == src.channel_name)
						check = 1
						break
				if(check)
					dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Channel author unverified.</FONT><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_CREATE_CHANNEL]'>Return</A><BR>"
			if(SCREEN_CHOOSE_PRINT)
				var/total_num=length(news_network.network_channels)
				var/active_num=total_num
				var/message_num=0
				for(var/datum/feed_channel/FC in news_network.network_channels)
					if(!FC.censored)
						message_num += length(FC.messages)    //Dont forget, datum/feed_channel's var messages is a list of datum/feed_message
					else
						active_num--
				dat+="Network currently serves a total of [total_num] Feed channels, [active_num] of which are active, and a total of [message_num] Feed Stories." //TODO: CONTINUE
				dat+="<BR><BR><B>Liquid Paper remaining:</B> [(src.paper_remaining) *100 ] cm^3"
				dat+="<BR><BR><A href='byond://?src=\ref[src];print_paper=[0]'>Print Paper</A>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Cancel</A>"
			if(SCREEN_VIEW_STORIES)
				dat+="<B>[src.viewing_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[src.viewing_channel.author]</FONT>\] \[views: <FONT COLOR='maroon'>[++src.viewing_channel.views]</FONT>\]</FONT><HR>"
				if(src.viewing_channel.censored)
					dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the [station_name()], and marked with a [global.using_map.company_name] D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
				else
					if( !length(src.viewing_channel.messages) )
						dat+="<I>No feed messages found in channel...</I><BR>"
					else
						var/i = 0
						for(var/datum/feed_message/MESSAGE in src.viewing_channel.messages)
							++i
							dat+="-[MESSAGE.body] <BR>"
							if(MESSAGE.img)
								var/resourc_name = "newscaster_photo_[sanitize(viewing_channel.channel_name)]_[i].png"
								send_asset(user.client, resourc_name)
								dat+="<img src='[resourc_name]' width = '180'><BR>"
								if(MESSAGE.caption)
									dat+="<FONT SIZE=1><B>[MESSAGE.caption]</B></FONT><BR>"
								dat+="<BR>"
							dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author] - [MESSAGE.time_stamp]</FONT>\]</FONT><BR>"
				dat+="<BR><HR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_VIEW_CHANNELS]'>Back</A>"
			if(SCREEN_CENSOR_STORY)
				dat+="<B>[global.using_map.company_name] Feed Censorship Tool</B><BR>"
				dat+="<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>"
				dat+="Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>"
				dat+="<HR>Select Feed channel to get Stories from:<BR>"
				if(!length(news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						dat+="<A href='byond://?src=\ref[src];pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Cancel</A>"
			if(SCREEN_CENSOR_CHANNEL)
				dat+="<B>[global.using_map.company_name] D-Notice Handler</B><HR>"
				dat+="<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the [station_name()]'s"
				dat+="morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed"
				dat+="stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>"
				if(!length(news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						dat+="<A href='byond://?src=\ref[src];pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR>"

				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Back</A>"
			if(SCREEN_PICK_CENSOR_STORY)
				dat+="<B>[src.viewing_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.viewing_channel.author]</FONT> \]</FONT><BR>"
				dat+="<FONT SIZE=2><A href='byond://?src=\ref[src];censor_channel_author=\ref[src.viewing_channel]'>[(src.viewing_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>"


				if( !length(src.viewing_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.viewing_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[[MESSAGE.message_type] by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"
						dat+="<FONT SIZE=2><A href='byond://?src=\ref[src];censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='byond://?src=\ref[src];censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_CENSOR_STORY]'>Back</A>"
			if(SCREEN_PICK_CENSOR_CHANNEL)
				dat+="<B>[src.viewing_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.viewing_channel.author]</FONT> \]</FONT><BR>"
				dat+="Channel messages listed below. If you deem them dangerous to the [station_name()], you can <A href='byond://?src=\ref[src];toggle_d_notice=\ref[src.viewing_channel]'>Bestow a D-Notice upon the channel</A>.<HR>"
				if(src.viewing_channel.censored)
					dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the [station_name()], and marked with a [global.using_map.company_name] D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>"
				else
					if( !length(src.viewing_channel.messages) )
						dat+="<I>No feed messages found in channel...</I><BR>"
					else
						for(var/datum/feed_message/MESSAGE in src.viewing_channel.messages)
							dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[[MESSAGE.message_type] by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"

				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_CENSOR_CHANNEL]'>Back</A>"
			if(SCREEN_MAKE_WANTED_ISSUE)
				dat+="<B>Wanted Issue Handler:</B>"
				var/wanted_already = 0
				var/end_param = 1
				if(news_network.wanted_issue)
					wanted_already = 1
					end_param = 2

				if(wanted_already)
					dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
				dat+="<HR>"
				dat+="<A href='byond://?src=\ref[src];set_wanted_name=1'>Criminal Name</A>: [src.channel_name] <BR>"
				dat+="<A href='byond://?src=\ref[src];set_wanted_desc=1'>Description</A>: [src.msg] <BR>"
				dat+="<B>Photo</B>: "
				if(photo_data && photo_data.photo)
					send_rsc(user, photo_data.photo.img, "tmp_photo.png")
					dat+="<BR><img src='tmp_photo.png' width = '180'>"
					dat+="<BR><B><A href='byond://?src=\ref[src];set_attachment=1'>Delete Photo</A></B></BR>"
				else
					dat+="<A href='byond://?src=\ref[src];set_attachment=1'>Attach Photo</A><BR>"
				if(wanted_already)
					dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'> [news_network.wanted_issue.backup_author]</FONT><BR>"
				else
					dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> [src.scanned_user]</FONT><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
				if(wanted_already)
					dat+="<BR><A href='byond://?src=\ref[src];cancel_wanted=1'>Take down Issue</A>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Cancel</A>"
			if(SCREEN_WANTED_CONFIRMED)
				dat+="<FONT COLOR='green'>Wanted issue for [src.channel_name] is now in Network Circulation.</FONT><BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A><BR>"
			if(SCREEN_WANTED_FAILED)
				dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
				if(src.channel_name=="" || src.channel_name == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Issue author unverified.</FONT><BR>"
				if(src.msg == "" || src.msg == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A><BR>"
			if(SCREEN_WANTED_DELETED)
				dat+="<B>Wanted Issue successfully deleted from Circulation</B><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A><BR>"
			if(SCREEN_WANTED_VIEW)
				dat+="<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>"
				dat+="<B>Criminal</B>: [news_network.wanted_issue.author]<BR>"
				dat+="<B>Description</B>: [news_network.wanted_issue.body]<BR>"
				dat+="<B>Photo</B>: "
				if(news_network.wanted_issue.img)
					send_rsc(user, news_network.wanted_issue.img, "tmp_photow.png")
					dat+="<BR><img src='tmp_photow.png' width = '180'>"
				else
					dat+="None"
				dat+="<BR><BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Back</A><BR>"
			if(SCREEN_WANTED_EDITED)
				dat+="<FONT COLOR='green'>Wanted issue for [src.channel_name] successfully edited.</FONT><BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A><BR>"
			if(SCREEN_PRINT_COMPLETE)
				dat+="<FONT COLOR='green'>Printing successful. Please receive your newspaper from the bottom of the machine.</FONT><BR><BR>"
				dat+="<A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A>"
			if(SCREEN_PRINT_FAILED)
				dat+="<FONT COLOR='maroon'>Unable to print newspaper. Insufficient paper. Please notify maintenance personnel to refill machine storage.</FONT><BR><BR>"
				dat+="<A href='byond://?src=\ref[src];setScreen=[SCREEN_WELCOME]'>Return</A>"

		var/processed_dat = human_or_robot_user.handle_reading_literacy(human_or_robot_user, dat, digital = TRUE)
		if(processed_dat)
			show_browser(human_or_robot_user, processed_dat, "window=newscaster_main;size=400x600")
		onclose(human_or_robot_user, "newscaster_main")

// This really needs to be rewritten, desperately.
// TODO: Rewrite newscasters to use files, networks, mainframes, etc. Also make it use NanoUI.
/obj/machinery/newscaster/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..())) // already handled in parent
		return
	// no need to do set_machine, that's done in CouldUseTopic
	if(href_list["set_channel_name"])
		channel_name = sanitize_safe(input(user, "Provide a Feed Channel Name", "Network Channel Handler", ""), MAX_LNAME_LEN)
		. = TOPIC_REFRESH

	else if(href_list["set_channel_lock"])
		c_locked = !c_locked
		. = TOPIC_REFRESH

	else if(href_list["submit_new_channel"])
		var/list/existing_authors = list()
		for(var/datum/feed_channel/FC in news_network.network_channels)
			if(FC.author == "\[REDACTED\]")
				existing_authors += FC.backup_author
			else
				existing_authors  +=FC.author
		var/check = 0
		for(var/datum/feed_channel/FC in news_network.network_channels)
			if(FC.channel_name == channel_name)
				check = 1
				break
		if(channel_name == "" || channel_name == "\[REDACTED\]" || scanned_user == "Unknown" || check || (scanned_user in existing_authors) )
			screen = SCREEN_CHANNEL_FAILED
		else
			var/choice = alert(user, "Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
			if(choice=="Confirm")
				news_network.CreateFeedChannel(channel_name, scanned_user, c_locked)
				screen = SCREEN_CHANNEL_SUBMITTED
		. = TOPIC_REFRESH

	else if(href_list["set_channel_receiving"])
		var/list/available_channels = list()
		for(var/datum/feed_channel/F in news_network.network_channels)
			if( (!F.locked || F.author == scanned_user) && !F.censored)
				available_channels += F.channel_name
		channel_name = input(user, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels
		. = TOPIC_REFRESH

	else if(href_list["set_new_message"])
		msg = pencode2html(sanitize(input(user, "Write your Feed story", "Network Channel Handler", "") as message|null))
		. = TOPIC_REFRESH

	else if(href_list["set_attachment"])
		AttachPhoto(user)
		. = TOPIC_REFRESH

	else if(href_list["submit_new_message"])
		if(msg =="" || msg=="\[REDACTED\]" || scanned_user == "Unknown" || channel_name == "" )
			screen = SCREEN_STORY_FAILED
		else
			var/image = photo_data ? photo_data.photo : null
			SSstatistics.add_field("newscaster_stories",1)
			news_network.SubmitArticle(msg, scanned_user, channel_name, image, 0)
			if(photo_data)
				qdel(photo_data)
				photo_data = null
			screen = SCREEN_STORY_SUBMITTED

		. = TOPIC_REFRESH

	else if(href_list["create_channel"])
		screen = SCREEN_CREATE_CHANNEL
		. = TOPIC_REFRESH

	else if(href_list["create_feed_story"])
		screen = SCREEN_CREATE_STORY
		. = TOPIC_REFRESH

	else if(href_list["menu_paper"])
		screen = SCREEN_CHOOSE_PRINT
		. = TOPIC_REFRESH
	else if(href_list["print_paper"])
		if(!paper_remaining)
			screen = SCREEN_PRINT_FAILED
		else
			print_paper()
			screen = SCREEN_PRINT_COMPLETE
		. = TOPIC_REFRESH

	else if(href_list["menu_censor_story"])
		screen = SCREEN_CENSOR_STORY
		. = TOPIC_REFRESH

	else if(href_list["menu_censor_channel"])
		screen = SCREEN_CENSOR_CHANNEL
		. = TOPIC_REFRESH

	else if(href_list["menu_wanted"])
		var/already_wanted = 0
		if(news_network.wanted_issue)
			already_wanted = 1

		if(already_wanted)
			channel_name = news_network.wanted_issue.author
			msg = news_network.wanted_issue.body
		screen = SCREEN_MAKE_WANTED_ISSUE
		. = TOPIC_REFRESH

	else if(href_list["set_wanted_name"])
		channel_name = sanitize_safe(input(user, "Provide the name of the Wanted person", "Network Security Handler", ""), MAX_LNAME_LEN)
		. = TOPIC_REFRESH

	else if(href_list["set_wanted_desc"])
		msg = sanitize(input(user, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
		. = TOPIC_REFRESH

	else if(href_list["submit_wanted"])
		var/input_param = text2num(href_list["submit_wanted"])
		if(msg == "" || channel_name == "" || scanned_user == "Unknown")
			screen = SCREEN_WANTED_FAILED
		else
			var/choice = alert(user, "Please confirm Wanted Issue [(input_param==1) ? ("creation.") : ("edit.")]","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
					var/datum/feed_message/WANTED = new /datum/feed_message
					WANTED.author = channel_name
					WANTED.body = msg
					WANTED.backup_author = scanned_user //I know, a bit wacky
					if(photo_data)
						WANTED.img = photo_data.photo.img
					news_network.wanted_issue = WANTED
					news_network.alert_readers()
					screen = SCREEN_WANTED_CONFIRMED
				else
					if(news_network.wanted_issue.is_admin_message)
						alert(user, "The wanted issue has been distributed by a [global.using_map.company_name] higherup. You cannot edit it.","Ok")
						return TOPIC_HANDLED
					news_network.wanted_issue.author = channel_name
					news_network.wanted_issue.body = msg
					news_network.wanted_issue.backup_author = scanned_user
					if(photo_data)
						news_network.wanted_issue.img = photo_data.photo.img
					screen = SCREEN_WANTED_EDITED

		. = TOPIC_REFRESH

	else if(href_list["cancel_wanted"])
		if(news_network.wanted_issue.is_admin_message)
			alert(user, "The wanted issue has been distributed by a [global.using_map.company_name] higherup. You cannot take it down.","Ok")
			return
		var/choice = alert(user, "Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
		if(choice=="Confirm")
			news_network.wanted_issue = null
			for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
				NEWSCASTER.update_icon()
			screen = SCREEN_WANTED_DELETED
		. = TOPIC_REFRESH

	else if(href_list["view_wanted"])
		screen = SCREEN_WANTED_VIEW
		. = TOPIC_REFRESH
	else if(href_list["censor_channel_author"])
		var/datum/feed_channel/FC = locate(href_list["censor_channel_author"])
		if(FC.is_admin_channel)
			alert(user, "This channel was created by a [global.using_map.company_name] Officer. You cannot censor it.","Ok")
			return TOPIC_HANDLED
		if(FC.author != "<B>\[REDACTED\]</B>")
			FC.backup_author = FC.author
			FC.author = "<B>\[REDACTED\]</B>"
		else
			FC.author = FC.backup_author
		FC.update()
		. = TOPIC_REFRESH

	else if(href_list["censor_channel_story_author"])
		var/datum/feed_message/MSG = locate(href_list["censor_channel_story_author"])
		if(MSG.is_admin_message)
			alert(user, "This message was created by a [global.using_map.company_name] Officer. You cannot censor its author.","Ok")
			return TOPIC_HANDLED
		if(MSG.author != "<B>\[REDACTED\]</B>")
			MSG.backup_author = MSG.author
			MSG.author = "<B>\[REDACTED\]</B>"
		else
			MSG.author = MSG.backup_author
		MSG.parent_channel.update()
		. = TOPIC_REFRESH

	else if(href_list["censor_channel_story_body"])
		var/datum/feed_message/MSG = locate(href_list["censor_channel_story_body"])
		if(MSG.is_admin_message)
			alert(user, "This channel was created by a [global.using_map.company_name] Officer. You cannot censor it.","Ok")
			return TOPIC_HANDLED
		if(MSG.body != "<B>\[REDACTED\]</B>")
			MSG.backup_body = MSG.body
			MSG.backup_caption = MSG.caption
			MSG.backup_img = MSG.img
			MSG.body = "<B>\[REDACTED\]</B>"
			MSG.caption = "<B>\[REDACTED\]</B>"
			MSG.img = null
		else
			MSG.body = MSG.backup_body
			MSG.caption = MSG.caption
			MSG.img = MSG.backup_img

		MSG.parent_channel.update()
		. = TOPIC_REFRESH

	else if(href_list["pick_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["pick_d_notice"])
		viewing_channel = FC
		screen = SCREEN_PICK_CENSOR_CHANNEL
		. = TOPIC_REFRESH

	else if(href_list["toggle_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["toggle_d_notice"])
		if(FC.is_admin_channel)
			alert(user, "This channel was created by a [global.using_map.company_name] Officer. You cannot place a D-Notice upon it.","Ok")
			return TOPIC_HANDLED
		FC.censored = !FC.censored
		FC.update()
		. = TOPIC_REFRESH

	else if(href_list["view"])
		screen = SCREEN_VIEW_CHANNELS
		. = TOPIC_REFRESH

	else if(href_list["setScreen"]) //Brings us to the main menu and resets all fields~
		screen = text2num(href_list["setScreen"])
		if (screen == SCREEN_WELCOME)
			scanned_user = "Unknown"
			msg = ""
			c_locked=0
			channel_name=""
			viewing_channel = null
			if (photo_data)
				qdel(photo_data)
				photo_data = null
		. = TOPIC_REFRESH

	else if(href_list["show_channel"])
		var/datum/feed_channel/FC = locate(href_list["show_channel"])
		viewing_channel = FC
		screen = SCREEN_VIEW_STORIES
		. = TOPIC_REFRESH

	else if(href_list["pick_censor_channel"])
		var/datum/feed_channel/FC = locate(href_list["pick_censor_channel"])
		viewing_channel = FC
		screen = SCREEN_PICK_CENSOR_STORY
		. = TOPIC_REFRESH

	else if(href_list["refresh"])
		. = TOPIC_REFRESH

/datum/news_photo
	/// This var is currently unused.
	var/is_synth = FALSE
	/// The actual photo object to display to the user. TODO: Refactor to just copy the image from a photo?
	var/obj/item/photo/photo = null

/datum/news_photo/New(obj/item/photo/p, synth = FALSE)
	is_synth = synth
	photo = p

/obj/machinery/newscaster/proc/AttachPhoto(mob/user)
	if(photo_data)
		QDEL_NULL(photo_data)
		return

	if(istype(user.get_active_held_item(), /obj/item/photo))
		var/obj/item/photo = user.get_active_held_item()
		photo_data = new(photo, 0)
	else if(issilicon(user))
		var/mob/living/silicon/tempAI = user
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (!selection)
			return

		photo_data = new(selection, TRUE)


//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

// TODO: Rewrite newspapers to use pencode? Also change the name from The Griffon and do something about unnecessary mentions of space.
/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the space newspaper."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	w_class = ITEM_SIZE_SMALL	//Let's make it fit in trashbags!
	attack_verb = list("bapped","thwapped","smacked")
	_base_attack_force = 0
	material = /decl/material/solid/organic/paper

	var/screen = 0
	var/pages = 0
	var/curr_page = 0
	var/list/datum/feed_channel/news_content = list()
	var/datum/feed_message/important_message = null
	var/scribble=""
	var/scribble_page = null

/obj/item/newspaper/attack_self(mob/user)
	user.update_personal_goal(/datum/goal/achievement/newshound, TRUE)
	if(ishuman(user))
		var/mob/living/human/human_user = user
		var/dat
		src.pages = 0
		switch(screen)
			if(0) //Cover
				dat+="<DIV ALIGN='center'><B><FONT SIZE=6>The Griffon</FONT></B></div>"
				dat+="<DIV ALIGN='center'><FONT SIZE=2>[global.using_map.company_name]-standard newspaper, for use on [global.using_map.company_name] Space Facilities</FONT></div><HR>"
				if(!length(src.news_content))
					if(src.important_message)
						dat+="Contents:<BR><ul><B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [src.pages+2]\]</FONT><BR></ul>"
					else
						dat+="<I>Other than the title, the rest of the newspaper is unprinted...</I>"
				else
					dat+="Contents:<BR><ul>"
					for(var/datum/feed_channel/NP in src.news_content)
						src.pages++
					if(src.important_message)
						dat+="<B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [src.pages+2]\]</FONT><BR>"
					var/temp_page=0
					for(var/datum/feed_channel/NP in src.news_content)
						temp_page++
						dat+="<B>[NP.channel_name]</B> <FONT SIZE=2>\[page [temp_page+1]\]</FONT><BR>"
					dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[src.scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:right;'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV> <div style='float:left;'><A href='byond://?src=\ref[human_user];mach_close=newspaper_main'>Done reading</A></DIV>"
			if(1) // X channel pages inbetween.
				for(var/datum/feed_channel/NP in src.news_content)
					src.pages++ //Let's get it right again.
				var/datum/feed_channel/C = src.news_content[src.curr_page]
				dat+="<FONT SIZE=4><B>[C.channel_name]</B></FONT><FONT SIZE=1> \[created by: <FONT COLOR='maroon'>[C.author]</FONT>\]</FONT><BR><BR>"
				if(C.censored)
					dat+="This channel was deemed dangerous to the general welfare of the [station_name()] and therefore marked with a <B><FONT COLOR='red'>D-Notice</B></FONT>. Its contents were not transferred to the newspaper at the time of printing."
				else
					if(!length(C.messages))
						dat+="No Feed stories stem from this channel..."
					else
						dat+="<ul>"
						var/i = 0
						for(var/datum/feed_message/MESSAGE in C.messages)
							++i
							dat+="-[MESSAGE.body] <BR>"
							if(MESSAGE.img)
								var/resourc_name = "newscaster_photo_[sanitize(C.channel_name)]_[i].png"
								send_asset(user.client, resourc_name)
								dat+="<img src='[resourc_name]' width = '180'><BR>"
							dat+="<FONT SIZE=1>\[[MESSAGE.message_type] by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR><BR>"
						dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[src.scribble]\"</I>"
				dat+= "<BR><HR><DIV STYLE='float:left;'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV> <DIV STYLE='float:right;'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV>"
			if(2) //Last page
				for(var/datum/feed_channel/NP in src.news_content)
					src.pages++
				if(src.important_message!=null)
					dat+="<DIV STYLE='float:center;'><FONT SIZE=4><B>Wanted Issue:</B></FONT SIZE></DIV><BR><BR>"
					dat+="<B>Criminal name</B>: <FONT COLOR='maroon'>[important_message.author]</FONT><BR>"
					dat+="<B>Description</B>: [important_message.body]<BR>"
					dat+="<B>Photo:</B>: "
					if(important_message.img)
						send_rsc(user, important_message.img, "tmp_photow.png")
						dat+="<BR><img src='tmp_photow.png' width = '180'>"
					else
						dat+="None"
				else
					dat+="<I>Apart from some uninteresting Classified ads, there's nothing on this page...</I>"
				if(scribble_page==curr_page)
					dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[src.scribble]\"</I>"
				dat+= "<HR><DIV STYLE='float:left;'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"

		dat+="<BR><HR><div align='center'>[src.curr_page+1]</div>"
		var/processed_dat = human_user.handle_reading_literacy(human_user, dat, digital = TRUE)
		if(processed_dat)
			show_browser(human_user, processed_dat, "window=newspaper_main;size=300x400")
			onclose(human_user, "newspaper_main")
	else
		to_chat(user, "The paper is full of unintelligible symbols!")


/obj/item/newspaper/DefaultTopicState()
	return global.physical_no_access_topic_state

/obj/item/newspaper/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return
	if(href_list["next_page"])
		if(curr_page==src.pages+1)
			return //Don't need that at all, but anyway.
		if(src.curr_page == src.pages) //We're at the middle, get to the end
			src.screen = 2
		else
			if(curr_page == 0) //We're at the start, get to the middle
				src.screen=1
		src.curr_page++
		playsound(src.loc, "pageturn", 50, 1)

	else if(href_list["prev_page"])
		if(curr_page == 0)
			return
		if(curr_page == 1)
			src.screen = 0

		else
			if(curr_page == src.pages+1) //we're at the end, let's go back to the middle.
				src.screen = 1
		src.curr_page--
		playsound(src.loc, "pageturn", 50, 1)

	if (ismob(src.loc))
		src.attack_self(src.loc)


/obj/item/newspaper/attackby(obj/item/used_item, mob/user)
	if(IS_PEN(used_item))
		if(src.scribble_page == src.curr_page)
			to_chat(user, SPAN_WARNING("There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?"))
			return TRUE
		var/s = input(user, "Write something", "Newspaper") as null | message
		if(!length(s))
			return TRUE
		if(!CanPhysicallyInteractWith(user, src))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
			return TRUE
		if(used_item.do_tool_interaction(TOOL_PEN, user, src, 0, fuel_expenditure = 1) && !QDELETED(src)) //Make it instant, since handle_writing_literacy does the waiting
			s = sanitize(s)
			s = user.handle_writing_literacy(user, s)
			src.scribble_page = src.curr_page
			src.scribble = s
			src.attack_self(user)
		return TRUE
	return ..()

////////////////////////////////////helper procs


/obj/machinery/newscaster/proc/scan_user(mob/living/user)
	if(ishuman(user))                       //User is a human
		var/mob/living/human/human_user = user
		var/obj/item/card/id/id = human_user.GetIdCard()
		if(istype(id))                                      //Newscaster scans you
			src.scanned_user = GetNameAndAssignmentFromId(id)
		else
			src.scanned_user = "Unknown"
	else
		var/mob/living/silicon/ai_user = user
		src.scanned_user = "[ai_user.name] ([ai_user.job])"


/obj/machinery/newscaster/proc/print_paper()
	SSstatistics.add_field("newscaster_newspapers_printed",1)
	var/obj/item/newspaper/NEWSPAPER = new /obj/item/newspaper
	for(var/datum/feed_channel/FC in news_network.network_channels)
		NEWSPAPER.news_content += FC
	if(news_network.wanted_issue)
		NEWSPAPER.important_message = news_network.wanted_issue
	NEWSPAPER.dropInto(loc)
	src.paper_remaining--
	return

/obj/machinery/newscaster/proc/reset_alert()
	alert = 0
	update_icon()

/obj/machinery/newscaster/proc/newsAlert(var/news_call)
	if(news_call)
		audible_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"[news_call]\"</span>")
		src.alert = 1
		src.update_icon()
		addtimer(CALLBACK(src, PROC_REF(reset_alert)), alert_delay, TIMER_UNIQUE | TIMER_OVERRIDE) //stay alert for the full time if we get a new one
		playsound(src.loc, 'sound/machines/twobeep.ogg', 75, 1)
	else
		audible_message("<span class='newscaster'><EM>[src.name]</EM> beeps, \"Attention! Wanted issue distributed!\"</span>")
		playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 75, 1)

// security newscaster preset
/obj/machinery/newscaster/security_unit
	base_type = /obj/machinery/newscaster
	securityCaster = TRUE