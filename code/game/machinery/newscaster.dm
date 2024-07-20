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
	//var/list/datum/feed_channel/channel_list = list() //This list will contain the names of the feed channels. Each name will refer to a data region where the messages of the feed channels are stored.
	//OBSOLETE: We're now using a global news network
	var/screen = 0                  //Or maybe I'll make it into a list within a list afterwards... whichever I prefer, go fuck yourselves :3
		// 0 = welcome screen - main menu
		// 1 = view feed channels
		// 2 = create feed channel
		// 3 = create feed story
		// 4 = feed story submited sucessfully
		// 5 = feed channel created successfully
		// 6 = ERROR: Cannot create feed story
		// 7 = ERROR: Cannot create feed channel
		// 8 = print newspaper
		// 9 = viewing channel feeds
		// 10 = censor feed story
		// 11 = censor feed channel
		//Holy shit this is outdated, made this when I was still starting newscasters :3
	var/paper_remaining = 0
	var/securityCaster = 0
		// 0 = Caster cannot be used to issue wanted posters
		// 1 = the opposite
	var/unit_no = 0 //Each newscaster has a unit number
	//var/datum/feed_message/wanted //We're gonna use a feed_message to store data of the wanted person because fields are similar
	//var/wanted_issue = 0          //OBSOLETE
		// 0 = there's no WANTED issued, we don't need a special icon_state
		// 1 = Guess what.
	var/alert_delay = 500
	var/alert = 0
		// 0 = there hasn't been a news/wanted update in the last alert_delay
		// 1 = there has
	var/scanned_user = "Unknown" //Will contain the name of the person who currently uses the newscaster
	var/msg = "";                //Feed message
	var/datum/news_photo/photo_data = null
	var/channel_name = ""; //the feed channel which will be receiving the feed, or being created
	var/c_locked=0;        //Will our new channel be locked to public submissions?
	var/hitstaken = 0      //Death at 3 hits from an item with force>=15
	var/datum/feed_channel/viewing_channel = null
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
			if(0)
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
			if(1)
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
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Back</A>"
			if(2)
				dat+="Creating new Feed Channel..."
				dat+="<HR><B><A href='byond://?src=\ref[src];set_channel_name=1'>Channel Name</A>:</B> [src.channel_name]<BR>"
				dat+="<B>Channel Author:</B> <FONT COLOR='green'>[src.scanned_user]</FONT><BR>"
				dat+="<B><A href='byond://?src=\ref[src];set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.c_locked) ? ("NO") : ("YES")]<BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];submit_new_channel=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A><BR>"
			if(3)
				dat+="Creating new Feed Message..."
				dat+="<HR><B><A href='byond://?src=\ref[src];set_channel_receiving=1'>Receiving Channel</A>:</B> [src.channel_name]<BR>" //MARK
				dat+="<B>Message Author:</B> <FONT COLOR='green'>[src.scanned_user]</FONT><BR>"
				dat+="<B><A href='byond://?src=\ref[src];set_new_message=1'>Message Body</A>:</B> [src.msg] <BR>"
				dat+="<B>Photo</B>: "
				if(photo_data && photo_data.photo)
					send_rsc(usr, photo_data.photo.img, "tmp_photo.png")
					dat+="<BR><img src='tmp_photo.png' width = '180'>"
					dat+="<BR><B><A href='byond://?src=\ref[src];set_attachment=1'>Delete Photo</A></B></BR>"
				else
					dat+="<A href='byond://?src=\ref[src];set_attachment=1'>Attach Photo</A>"
				dat+="<BR><BR><A href='byond://?src=\ref[src];submit_new_message=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A><BR>"
			if(4)
				dat+="Feed story successfully submitted to [src.channel_name].<BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(5)
				dat+="Feed Channel [src.channel_name] created successfully.<BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(6)
				dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
				if(src.channel_name=="")
					dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Channel author unverified.</FONT><BR>"
				if(src.msg == "" || src.msg == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"

				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[3]'>Return</A><BR>"
			if(7)
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
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[2]'>Return</A><BR>"
			if(8)
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
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(9)
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
								send_asset(usr.client, resourc_name)
								dat+="<img src='[resourc_name]' width = '180'><BR>"
								if(MESSAGE.caption)
									dat+="<FONT SIZE=1><B>[MESSAGE.caption]</B></FONT><BR>"
								dat+="<BR>"
							dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author] - [MESSAGE.time_stamp]</FONT>\]</FONT><BR>"
				dat+="<BR><HR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[1]'>Back</A>"
			if(10)
				dat+="<B>[global.using_map.company_name] Feed Censorship Tool</B><BR>"
				dat+="<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>"
				dat+="Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>"
				dat+="<HR>Select Feed channel to get Stories from:<BR>"
				if(!length(news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						dat+="<A href='byond://?src=\ref[src];pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(11)
				dat+="<B>[global.using_map.company_name] D-Notice Handler</B><HR>"
				dat+="<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the [station_name()]'s"
				dat+="morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed"
				dat+="stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>"
				if(!length(news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						dat+="<A href='byond://?src=\ref[src];pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR>"

				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Back</A>"
			if(12)
				dat+="<B>[src.viewing_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.viewing_channel.author]</FONT> \]</FONT><BR>"
				dat+="<FONT SIZE=2><A href='byond://?src=\ref[src];censor_channel_author=\ref[src.viewing_channel]'>[(src.viewing_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>"


				if( !length(src.viewing_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.viewing_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[[MESSAGE.message_type] by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"
						dat+="<FONT SIZE=2><A href='byond://?src=\ref[src];censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='byond://?src=\ref[src];censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[10]'>Back</A>"
			if(13)
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

				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[11]'>Back</A>"
			if(14)
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
					send_rsc(usr, photo_data.photo.img, "tmp_photo.png")
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
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Cancel</A>"
			if(15)
				dat+="<FONT COLOR='green'>Wanted issue for [src.channel_name] is now in Network Circulation.</FONT><BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(16)
				dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
				if(src.channel_name=="" || src.channel_name == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Issue author unverified.</FONT><BR>"
				if(src.msg == "" || src.msg == "\[REDACTED\]")
					dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(17)
				dat+="<B>Wanted Issue successfully deleted from Circulation</B><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(18)
				dat+="<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>"
				dat+="<B>Criminal</B>: [news_network.wanted_issue.author]<BR>"
				dat+="<B>Description</B>: [news_network.wanted_issue.body]<BR>"
				dat+="<B>Photo</B>: "
				if(news_network.wanted_issue.img)
					send_rsc(usr, news_network.wanted_issue.img, "tmp_photow.png")
					dat+="<BR><img src='tmp_photow.png' width = '180'>"
				else
					dat+="None"
				dat+="<BR><BR><A href='byond://?src=\ref[src];setScreen=[0]'>Back</A><BR>"
			if(19)
				dat+="<FONT COLOR='green'>Wanted issue for [src.channel_name] successfully edited.</FONT><BR><BR>"
				dat+="<BR><A href='byond://?src=\ref[src];setScreen=[0]'>Return</A><BR>"
			if(20)
				dat+="<FONT COLOR='green'>Printing successful. Please receive your newspaper from the bottom of the machine.</FONT><BR><BR>"
				dat+="<A href='byond://?src=\ref[src];setScreen=[0]'>Return</A>"
			if(21)
				dat+="<FONT COLOR='maroon'>Unable to print newspaper. Insufficient paper. Please notify maintenance personnel to refill machine storage.</FONT><BR><BR>"
				dat+="<A href='byond://?src=\ref[src];setScreen=[0]'>Return</A>"
			else
				dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

		var/processed_dat = human_or_robot_user.handle_reading_literacy(human_or_robot_user, dat)
		if(processed_dat)
			show_browser(human_or_robot_user, processed_dat, "window=newscaster_main;size=400x600")
		onclose(human_or_robot_user, "newscaster_main")

/obj/machinery/newscaster/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && isturf(src.loc))) || (issilicon(usr)))
		usr.set_machine(src)
		if(href_list["set_channel_name"])
			src.channel_name = sanitize_safe(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", ""), MAX_LNAME_LEN)
			src.updateUsrDialog()
			//src.update_icon()

		else if(href_list["set_channel_lock"])
			src.c_locked = !src.c_locked
			src.updateUsrDialog()
			//src.update_icon()

		else if(href_list["submit_new_channel"])
			//var/list/existing_channels = list() //OBSOLETE
			var/list/existing_authors = list()
			for(var/datum/feed_channel/FC in news_network.network_channels)
				//existing_channels += FC.channel_name
				if(FC.author == "\[REDACTED\]")
					existing_authors += FC.backup_author
				else
					existing_authors  +=FC.author
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == src.channel_name)
					check = 1
					break
			if(src.channel_name == "" || src.channel_name == "\[REDACTED\]" || src.scanned_user == "Unknown" || check || (src.scanned_user in existing_authors) )
				src.screen=7
			else
				var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
				if(choice=="Confirm")
					news_network.CreateFeedChannel(src.channel_name, src.scanned_user, c_locked)
					src.screen=5
			src.updateUsrDialog()
			//src.update_icon()

		else if(href_list["set_channel_receiving"])
			//var/list/datum/feed_channel/available_channels = list()
			var/list/available_channels = list()
			for(var/datum/feed_channel/F in news_network.network_channels)
				if( (!F.locked || F.author == scanned_user) && !F.censored)
					available_channels += F.channel_name
			src.channel_name = input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels
			src.updateUsrDialog()

		else if(href_list["set_new_message"])
			src.msg = pencode2html(sanitize(input(usr, "Write your Feed story", "Network Channel Handler", "") as message|null))
			src.updateUsrDialog()

		else if(href_list["set_attachment"])
			AttachPhoto(usr)
			src.updateUsrDialog()

		else if(href_list["submit_new_message"])
			if(src.msg =="" || src.msg=="\[REDACTED\]" || src.scanned_user == "Unknown" || src.channel_name == "" )
				src.screen=6
			else
				var/image = photo_data ? photo_data.photo : null
				SSstatistics.add_field("newscaster_stories",1)
				news_network.SubmitArticle(src.msg, src.scanned_user, src.channel_name, image, 0)
				if(photo_data)
					qdel(photo_data)
					photo_data = null
				src.screen=4

			src.updateUsrDialog()

		else if(href_list["create_channel"])
			src.screen=2
			src.updateUsrDialog()

		else if(href_list["create_feed_story"])
			src.screen=3
			src.updateUsrDialog()

		else if(href_list["menu_paper"])
			src.screen=8
			src.updateUsrDialog()
		else if(href_list["print_paper"])
			if(!src.paper_remaining)
				src.screen=21
			else
				src.print_paper()
				src.screen = 20
			src.updateUsrDialog()

		else if(href_list["menu_censor_story"])
			src.screen=10
			src.updateUsrDialog()

		else if(href_list["menu_censor_channel"])
			src.screen=11
			src.updateUsrDialog()

		else if(href_list["menu_wanted"])
			var/already_wanted = 0
			if(news_network.wanted_issue)
				already_wanted = 1

			if(already_wanted)
				src.channel_name = news_network.wanted_issue.author
				src.msg = news_network.wanted_issue.body
			src.screen = 14
			src.updateUsrDialog()

		else if(href_list["set_wanted_name"])
			src.channel_name = sanitize_safe(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""), MAX_LNAME_LEN)
			src.updateUsrDialog()

		else if(href_list["set_wanted_desc"])
			src.msg = sanitize(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
			src.updateUsrDialog()

		else if(href_list["submit_wanted"])
			var/input_param = text2num(href_list["submit_wanted"])
			if(src.msg == "" || src.channel_name == "" || src.scanned_user == "Unknown")
				src.screen = 16
			else
				var/choice = alert("Please confirm Wanted Issue [(input_param==1) ? ("creation.") : ("edit.")]","Network Security Handler","Confirm","Cancel")
				if(choice=="Confirm")
					if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
						var/datum/feed_message/WANTED = new /datum/feed_message
						WANTED.author = src.channel_name
						WANTED.body = src.msg
						WANTED.backup_author = src.scanned_user //I know, a bit wacky
						if(photo_data)
							WANTED.img = photo_data.photo.img
						news_network.wanted_issue = WANTED
						news_network.alert_readers()
						src.screen = 15
					else
						if(news_network.wanted_issue.is_admin_message)
							alert("The wanted issue has been distributed by a [global.using_map.company_name] higherup. You cannot edit it.","Ok")
							return
						news_network.wanted_issue.author = src.channel_name
						news_network.wanted_issue.body = src.msg
						news_network.wanted_issue.backup_author = src.scanned_user
						if(photo_data)
							news_network.wanted_issue.img = photo_data.photo.img
						src.screen = 19

			src.updateUsrDialog()

		else if(href_list["cancel_wanted"])
			if(news_network.wanted_issue.is_admin_message)
				alert("The wanted issue has been distributed by a [global.using_map.company_name] higherup. You cannot take it down.","Ok")
				return
			var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				news_network.wanted_issue = null
				for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
					NEWSCASTER.update_icon()
				src.screen=17
			src.updateUsrDialog()

		else if(href_list["view_wanted"])
			src.screen=18
			src.updateUsrDialog()
		else if(href_list["censor_channel_author"])
			var/datum/feed_channel/FC = locate(href_list["censor_channel_author"])
			if(FC.is_admin_channel)
				alert("This channel was created by a [global.using_map.company_name] Officer. You cannot censor it.","Ok")
				return
			if(FC.author != "<B>\[REDACTED\]</B>")
				FC.backup_author = FC.author
				FC.author = "<B>\[REDACTED\]</B>"
			else
				FC.author = FC.backup_author
			FC.update()
			src.updateUsrDialog()

		else if(href_list["censor_channel_story_author"])
			var/datum/feed_message/MSG = locate(href_list["censor_channel_story_author"])
			if(MSG.is_admin_message)
				alert("This message was created by a [global.using_map.company_name] Officer. You cannot censor its author.","Ok")
				return
			if(MSG.author != "<B>\[REDACTED\]</B>")
				MSG.backup_author = MSG.author
				MSG.author = "<B>\[REDACTED\]</B>"
			else
				MSG.author = MSG.backup_author
			MSG.parent_channel.update()
			src.updateUsrDialog()

		else if(href_list["censor_channel_story_body"])
			var/datum/feed_message/MSG = locate(href_list["censor_channel_story_body"])
			if(MSG.is_admin_message)
				alert("This channel was created by a [global.using_map.company_name] Officer. You cannot censor it.","Ok")
				return
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
			src.updateUsrDialog()

		else if(href_list["pick_d_notice"])
			var/datum/feed_channel/FC = locate(href_list["pick_d_notice"])
			src.viewing_channel = FC
			src.screen=13
			src.updateUsrDialog()

		else if(href_list["toggle_d_notice"])
			var/datum/feed_channel/FC = locate(href_list["toggle_d_notice"])
			if(FC.is_admin_channel)
				alert("This channel was created by a [global.using_map.company_name] Officer. You cannot place a D-Notice upon it.","Ok")
				return
			FC.censored = !FC.censored
			FC.update()
			src.updateUsrDialog()

		else if(href_list["view"])
			src.screen=1
			src.updateUsrDialog()

		else if(href_list["setScreen"]) //Brings us to the main menu and resets all fields~
			src.screen = text2num(href_list["setScreen"])
			if (src.screen == 0)
				src.scanned_user = "Unknown"
				msg = ""
				src.c_locked=0;
				channel_name=""
				src.viewing_channel = null
				if (photo_data)
					qdel(photo_data)
					photo_data = null
			src.updateUsrDialog()

		else if(href_list["show_channel"])
			var/datum/feed_channel/FC = locate(href_list["show_channel"])
			src.viewing_channel = FC
			src.screen = 9
			src.updateUsrDialog()

		else if(href_list["pick_censor_channel"])
			var/datum/feed_channel/FC = locate(href_list["pick_censor_channel"])
			src.viewing_channel = FC
			src.screen = 12
			src.updateUsrDialog()

		else if(href_list["refresh"])
			src.updateUsrDialog()

/datum/news_photo
	var/is_synth = 0
	var/obj/item/photo/photo = null

/datum/news_photo/New(var/obj/item/photo/p, var/synth)
	is_synth = synth
	photo = p

/obj/machinery/newscaster/proc/AttachPhoto(mob/user)
	if(photo_data)
		qdel(photo_data)
		photo_data = null
		return

	if(istype(user.get_active_held_item(), /obj/item/photo))
		var/obj/item/photo = user.get_active_held_item()
		photo_data = new(photo, 0)
	else if(issilicon(user))
		var/mob/living/silicon/tempAI = user
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (!selection)
			return

		photo_data = new(selection, 1)


//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

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
		var/processed_dat = human_user.handle_reading_literacy(human_user, dat)
		if(processed_dat)
			show_browser(human_user, processed_dat, "window=newspaper_main;size=300x400")
			onclose(human_user, "newspaper_main")
	else
		to_chat(user, "The paper is full of unintelligible symbols!")


/obj/item/newspaper/Topic(href, href_list)
	var/mob/living/U = usr
	..()
	if ((src in U.contents) || ( isturf(loc) && in_range(src, U) ))
		U.set_machine(src)
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


/obj/item/newspaper/attackby(obj/item/W, mob/user)
	if(IS_PEN(W))
		if(src.scribble_page == src.curr_page)
			to_chat(user, SPAN_WARNING("There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?"))
			return TRUE
		else
			var/s = input(user, "Write something", "Newspaper") as null | message
			if(!length(s))
				return
			if(!CanPhysicallyInteractWith(user, src))
				to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
				return
			if(W.do_tool_interaction(TOOL_PEN, user, src, 0, fuel_expenditure = 1) && !QDELETED(src)) //Make it instant, since handle_writing_literacy does the waiting
				s = sanitize(s)
				s = user.handle_writing_literacy(user, s)
				src.scribble_page = src.curr_page
				src.scribble = s
				src.attack_self(user)
				return TRUE
			return
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
