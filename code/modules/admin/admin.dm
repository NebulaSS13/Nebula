
var/global/BSACooldown = 0


////////////////////////////////
/proc/message_admins(var/msg)
	msg = "<span class=\"log_message\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	log_adminwarn(msg)
	for(var/client/C in global.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
/proc/message_staff(var/msg)
	msg = "<span class=\"log_message\"><span class=\"prefix\">STAFF LOG:</span> <span class=\"message\">[msg]</span></span>"
	log_adminwarn(msg)
	for(var/client/C in global.admins)
		if(C && C.holder && (R_INVESTIGATE & C.holder.rights))
			to_chat(C, msg)
/proc/msg_admin_attack(var/text) //Toggleable Attack Messages
	log_attack(text)
	var/rendered = "<span class=\"log_message\"><span class=\"prefix\">ATTACK:</span> <span class=\"message\">[text]</span></span>"
	for(var/client/C in global.admins)
		if(check_rights(R_INVESTIGATE, 0, C))
			if(C.get_preference_value(/datum/client_preference/staff/show_attack_logs) == PREF_SHOW)
				var/msg = rendered
				to_chat(C, msg)
/proc/admin_notice(var/message, var/rights)
	for(var/mob/M in SSmobs.mob_list)
		if(check_rights(rights, 0, M))
			to_chat(M, message)

/proc/message_staff_fax(var/obj/item/paper/admin/fax, var/obj/machinery/faxmachine/destination, var/owner, var/dest_network_id = "UNKNOWN", var/dest_network_tag = "UNKNOWN")
	var/msg
	if(fax.sender)
		msg = "<span class='log_message'><span class='prefix'>FAX LOG:</span>[key_name_admin(owner)] replied to a fax message from [key_name_admin(fax.sender)] (<a href='byond://?_src_=holder;AdminFaxView=\ref[fax]'>VIEW</a>)</span>"
		log_admin("[key_name(owner)] replied to a fax message from [key_name(fax.sender)]")
	else
		msg = "<span class='log_message'><span class='prefix'>FAX LOG:</span>[key_name_admin(owner)] has sent a fax message to \the [get_area(fax)]'s [destination] ('[dest_network_id]'.'[dest_network_tag]')(<a href='byond://?_src_=holder;AdminFaxView=\ref[fax]'>VIEW</a>)</span>"
		log_admin("[key_name(owner)] has sent a fax message to \the [get_area(fax)]'s [destination] ('[dest_network_id]'.'[dest_network_tag]')")

	for(var/client/C in global.admins)
		if(C && C.holder && (R_INVESTIGATE & C.holder.rights))
			to_chat(C, msg)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html><head><title>Options for [M.key]</title></head>"
	body += "<body>Options panel for <b>[M]</b>"
	var/last_ckey = LAST_CKEY(M)
	if(M.client)
		body += " played by <b>[M.client]</b> "
		body += "\[<A href='byond://?src=\ref[src];editrights=show'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"
	else if(last_ckey)
		body += " (last occupied by ckey <b>[last_ckey]</b>)"

	if(isnewplayer(M))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='byond://?src=\ref[src];revive=\ref[M]'>Heal</A>\] "

	var/mob/living/exosuit/E = M
	if(istype(E) && E.pilots)
		body += "<br><b>Exosuit pilots:</b><br>"
		for(var/mob/living/pilot in E.pilots)
			body += "[pilot] "
			body += " \[<A href='byond://?src=\ref[src];pilot=\ref[pilot]'>link</a>\]<br>"

	body += {"
		<br><br>\[
		<a href='byond://?_src_=vars;Vars=\ref[M]'>View Vars</a> -
		<a href='byond://?src=\ref[src];show_special_roles=\ref[M]'>Roles</a> -
		<a href='byond://?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='byond://?src=\ref[src];narrateto=\ref[M]'>Narrate</a> -
		[admin_jump_link(M, src)]\] <br>
		<b>Mob type:</b> [M.type]<br>
		<b>Inactivity time:</b> [M.client ? "[M.client.inactivity/600] minutes" : "Logged out"]<br/><br/>
		<A href='byond://?src=\ref[src];boot2=\ref[M]'>Kick</A> |
		<A href='byond://?_src_=holder;warn=[last_ckey]'>Warn</A> |
		<A href='byond://?src=\ref[src];newban=\ref[M];last_key=[last_ckey]'>Ban</A> |
		<A href='byond://?src=\ref[src];jobban_panel_target=\ref[M]'>Jobban</A> |
		<A href='byond://?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A>
	"}

	if(M.client)
		body += "| <A HREF='byond://?src=\ref[src];sendtoprison=\ref[M]'>Prison</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\[<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_AOOC]'><font color='[(muted & MUTE_AOOC)?"red":"blue"]'>AOOC</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> |
			<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]
			(<A href='byond://?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)
		"}
		body += "<br><br><b>Staff Warning:</b> [M.client.staffwarn ? M.client.staffwarn : "No"]<br>"
		if (!M.client.staffwarn)
			body += "<A href='byond://?src=\ref[src];setstaffwarn=\ref[M]'>Set StaffWarn</A>"
		else
			body += "<A href='byond://?src=\ref[src];removestaffwarn=\ref[M]'>Remove StaffWarn</A>"

	body += {"<br><br>
		<A href='byond://?src=\ref[src];jumpto=\ref[M]'><b>Jump to</b></A> |
		<A href='byond://?src=\ref[src];getmob=\ref[M]'>Get</A> |
		<A href='byond://?src=\ref[src];sendmob=\ref[M]'>Send To</A>
		<br><br>
		[check_rights(R_INVESTIGATE,0) ? "<A href='byond://?src=\ref[src];skillpanel=\ref[M]'>Skill panel</A>" : "" ]
	"}

	if(M.mind)
		body += "<br><br>"
		body += "<b>Goals:</b>"
		body += "<br>"
		body += "[jointext(M.mind.summarize_goals(FALSE, TRUE, src), "<br>")]"
		body += "<br>"
		body += "<a href='byond://?src=\ref[M.mind];add_goal=1'>Add Random Goal</a>"

	var/list/all_modpacks = decls_repository.get_decls_of_subtype(/decl/modpack)
	for(var/package in all_modpacks)
		var/decl/modpack/manifest = all_modpacks[package]
		var/extra_body = manifest.get_player_panel_options(M)
		if(extra_body)
			body += "<br><br>"
			body += extra_body

	if (M.client)
		if(!isnewplayer(M))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Monkey
			if(issmall(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='byond://?src=\ref[src];monkeyone=\ref[M]'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='byond://?src=\ref[src];corgione=\ref[M]'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='byond://?src=\ref[src];makeai=\ref[M]'>Make AI</A> |
					<A href='byond://?src=\ref[src];makerobot=\ref[M]'>Make Robot</A> |
					<A href='byond://?src=\ref[src];makealien=\ref[M]'>Make Alien</A>
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='byond://?src=\ref[src];makeanimal=\ref[M]'>Re-Animalize</A> | "
			else
				body += "<A href='byond://?src=\ref[src];makeanimal=\ref[M]'>Animalize</A> | "

			if(M.can_have_genetic_conditions())
				body += "<br><br>"
				body += "<b>Genetic conditions:</b><br><table border='0'><tr>"
				var/i = 1
				for(var/decl/genetic_condition/mutation as anything in decls_repository.get_decls_of_type_unassociated(/decl/genetic_condition))
					if(i % 5 == 0)
						body += "</tr><tr>"
					body += "<td><a href='byond://?src=\ref[src];toggle_mutation=\ref[M];block=\ref[mutation]' style='color:[M.has_genetic_condition(mutation.type) ? "#006600" : "#ff0000"];'>[mutation.name]</a></td>"
					i++
				body += "</tr></table>"

			body += "<br><br><b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>"

			var/list/href_transform_strings = list()
			for(var/href_string in global.href_to_mob_type)
				var/transform_data = global.href_to_mob_type[href_string]

				// It's a category - iterate the contents.
				if(islist(transform_data))
					var/list/href_subcat_strings = list()
					for(var/transform_string in transform_data)
						href_subcat_strings += "<a href='byond://?src=\ref[src];simplemake=[replacetext(transform_string, " ", "_")];mob=\ref[M]'>[transform_string]</a>"
					href_transform_strings += "\[ <b>[href_string]:</b> [jointext(href_subcat_strings, " | ")] \]"

				 // It's a single mob type - link it directly.
				else if(ispath(transform_data))
					href_transform_strings += "<a href='byond://?src=\ref[src];simplemake=[replacetext(href_string, " ", "_")];mob=\ref[M]'>[href_string]</a>"

			body += jointext(href_transform_strings, " | ")

	body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='byond://?src=\ref[src];forcespeech=\ref[M]'>Forcesay</A>
			"}
	// language toggles
	body += "<br><br><b>Languages:</b><br>"
	var/f = 1
	var/list/language_types = decls_repository.get_decls_of_subtype(/decl/language)
	for(var/k in language_types)
		var/decl/language/L = language_types[k]
		if(!(L.flags & LANG_FLAG_INNATE))
			if(!f)
				body += " | "
			else
				f = 0
			if(L in M.languages)
				body += "<a href='byond://?src=\ref[src];toglang=\ref[M];lang=\ref[L]' style='color:#006600'>[L.name]</a>"
			else
				body += "<a href='byond://?src=\ref[src];toglang=\ref[M];lang=\ref[L]' style='color:#ff0000'>[L.name]</a>"

	body += {"<br>
		</body></html>
	"}

	show_browser(usr, body, "window=adminplayeropts;size=550x515")
	SSstatistics.add_field_details("admin_verb","SPP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying

#define PLAYER_NOTES_ENTRIES_PER_PAGE 50
/datum/admins/proc/PlayerNotes()
	set category = "Admin"
	set name = "Player Notes"
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	PlayerNotesPage()

/datum/admins/proc/PlayerNotesPage(var/filter_term)
	var/list/dat = list()
	dat += "<B>Player notes</B><HR>"
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	from_file(S, note_keys)

	if(filter_term)
		for(var/t in note_keys)
			if(findtext(lowertext(t), lowertext(filter_term)))
				continue
			note_keys -= t

	dat += "<center><b>Search term:</b> <a href='byond://?src=\ref[src];notes=set_filter'>[filter_term ? filter_term : "-----"]</a></center><hr>"

	if(!note_keys)
		dat += "No notes found."
	else
		dat += "<table>"
		note_keys = sortTim(note_keys, /proc/cmp_text_asc)
		for(var/t in note_keys)
			dat += "<tr><td><a href='byond://?src=\ref[src];notes=show;ckey=[t]'>[t]</a></td></tr>"
		dat += "</table><br>"

	var/datum/browser/popup = new(usr, "player_notes", "Player Notes", 400, 400)
	popup.set_content(jointext(dat, null))
	popup.open()


/datum/admins/proc/player_has_info(var/key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	from_file(info, infos)
	if(!infos || !infos.len) return 0
	else return 1


/datum/admins/proc/show_player_info(var/key as text)

	set category = "Admin"
	set name = "Show Player Info"
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/list/dat = list()

	var/p_age = "unknown"
	for(var/client/C in global.clients)
		if(C.ckey == key)
			p_age = C.player_age
			break
	dat += "<b>Player age: [p_age]</b><br><ul id='notes'>"

	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	from_file(info, infos)
	if(!infos)
		dat += "No information found on the given key.<br>"
	else
		var/update_file = 0
		var/i = 0
		for(var/datum/player_info/I in infos)
			i += 1
			if(!I.timestamp)
				I.timestamp = "Pre-4/3/2012"
				update_file = 1
			if(!I.rank)
				I.rank = "N/A"
				update_file = 1
			dat += "<li><font color=#7d9177>[I.content]</font> <i>by [I.author] ([I.rank])</i> on <i><font color='#8a94a3'>[I.timestamp]</i></font> "
			if(I.author == usr.key || I.author == "Adminbot" || ishost(usr))
				dat += "<A href='byond://?src=\ref[src];remove_player_info=[key];remove_index=[i]'>Remove</A>"
			dat += "<hr></li>"
		if(update_file)
			to_file(info, infos)

	dat += "</ul><br><A href='byond://?src=\ref[src];add_player_info=[key]'>Add Comment</A><br>"

	var/html = {"
		<html>
		<head>
			<title>Info on [key]</title>
			<script src='player_info.js'></script>
		</head>
		<body onload='selectTextField(); updateSearch()'; onkeyup='updateSearch()'>
			<div align='center'>
			<table width='100%'><tr>
				<td width='20%'>
					<div align='center'>
						<b>Search:</b>
					</div>
				</td>
				<td width='80%'>
					<input type='text'
					       id='filter'
					       name='filter_text'
					       value=''
					       style='width:100%;' />
				</td>
			</tr></table>
			<hr/>
			[jointext(dat, null)]
		</body>
		</html>
		"}

	send_rsc(usr,'code/js/player_info.js', "player_info.js")
	var/datum/browser/popup = new(usr, "adminplayerinfo", "Player Info", 480, 480)
	popup.set_content(html)
	popup.open()

/datum/admins/proc/access_news_network() //MARKER
	set category = "Fun"
	set name = "Access Newscaster Network"
	set desc = "Allows you to view, add and edit news feeds."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat
	dat = text("<HEAD><TITLE>Admin Newscaster</TITLE></HEAD><H3>Admin Newscaster Unit</H3>")

	switch(admincaster_screen)
		if(0)
			dat += {"Welcome to the admin newscaster.<BR> Here you can add, edit and censor every newspiece on the network.
				<BR>Feed channels and stories entered through here will be uneditable and handled as official news by the rest of the units.
				<BR>Note that this panel allows full freedom over the news network, there are no constrictions except the few basic ones. Don't break things!
			"}
			if(news_network.wanted_issue)
				dat+= "<HR><A href='byond://?src=\ref[src];ac_view_wanted=1'>Read Wanted Issue</A>"

			dat+= {"<HR><BR><A href='byond://?src=\ref[src];ac_create_channel=1'>Create Feed Channel</A>
				<BR><A href='byond://?src=\ref[src];ac_view=1'>View Feed Channels</A>
				<BR><A href='byond://?src=\ref[src];ac_create_feed_story=1'>Submit new Feed story</A>
				<BR><BR><A href='byond://?src=\ref[usr];mach_close=newscaster_main'>Exit</A>
			"}

			var/wanted_already = 0
			if(news_network.wanted_issue)
				wanted_already = 1

			dat+={"<HR><B>Feed Security functions:</B><BR>
				<BR><A href='byond://?src=\ref[src];ac_menu_wanted=1'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>
				<BR><A href='byond://?src=\ref[src];ac_menu_censor_story=1'>Censor Feed Stories</A>
				<BR><A href='byond://?src=\ref[src];ac_menu_censor_channel=1'>Mark Feed Channel with [global.using_map.company_name] D-Notice (disables and locks the channel.</A>
				<BR><HR><A href='byond://?src=\ref[src];ac_set_signature=1'>The newscaster recognises you as:<BR> <FONT COLOR='green'>[src.admincaster_signature]</FONT></A>
			"}
		if(1)
			dat+= "Feed Channels<HR>"
			if( !length(news_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen'><A href='byond://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
					else
						dat+="<B><A href='byond://?src=\ref[src];ac_show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR></B>"
			dat+={"<BR><HR><A href='byond://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A>
			"}

		if(2)
			dat+={"
				Creating new Feed Channel...
				<HR><B><A href='byond://?src=\ref[src];ac_set_channel_name=1'>Channel Name</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>
				<B><A href='byond://?src=\ref[src];ac_set_signature=1'>Channel Author</A>:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond://?src=\ref[src];ac_set_channel_lock=1'>Will Accept Public Feeds</A>:</B> [(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")]<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_submit_new_channel=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(3)
			dat+={"
				Creating new Feed Message...
				<HR><B><A href='byond://?src=\ref[src];ac_set_channel_receiving=1'>Receiving Channel</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>" //MARK
				<B>Message Author:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond://?src=\ref[src];ac_set_new_message=1'>Message Body</A>:</B> [src.admincaster_feed_message.body] <BR>
				<BR><A href='byond://?src=\ref[src];ac_submit_new_message=1'>Submit</A><BR><BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A><BR>
			"}
		if(4)
			dat+={"
					Feed story successfully submitted to [src.admincaster_feed_channel.channel_name].<BR><BR>
					<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
				"}
		if(5)
			dat+={"
				Feed Channel [src.admincaster_feed_channel.channel_name] created successfully.<BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(6)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[3]'>Return</A><BR>"
		if(7)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[2]'>Return</A><BR>"
		if(9)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT>\]</FONT><HR>"
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the [station_name()], and marked with a [global.using_map.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( !length(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					var/i = 0
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						i++
						dat+="-[MESSAGE.body] <BR>"
						if(MESSAGE.img)
							send_rsc(usr, MESSAGE.img, "tmp_photo[i].png")
							dat+="<img src='tmp_photo[i].png' width = '180'><BR><BR>"
						dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"
			dat+={"
				<BR><HR><A href='byond://?src=\ref[src];ac_refresh=1'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[1]'>Back</A>
			"}
		if(10)
			dat+={"
				<B>[global.using_map.company_name] Feed Censorship Tool</B><BR>
				<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>
				Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>
				<HR>Select Feed channel to get Stories from:<BR>
			"}
			if(!length(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];ac_pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(11)
			dat+={"
				<B>[global.using_map.company_name] D-Notice Handler</B><HR>
				<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the [station_name()]'s
				morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed
				stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>
			"}
			if(!length(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];ac_pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null ]<BR>"

			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A>"
		if(12)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				<FONT SIZE=2><A href='byond://?src=\ref[src];ac_censor_channel_author=\ref[src.admincaster_feed_channel]'>[(src.admincaster_feed_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>
			"}
			if( !length(src.admincaster_feed_channel.messages) )
				dat+="<I>No feed messages found in channel...</I><BR>"
			else
				for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
					dat+={"
						-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>
						<FONT SIZE=2><A href='byond://?src=\ref[src];ac_censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='byond://?src=\ref[src];ac_censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>
					"}
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[10]'>Back</A>"
		if(13)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				Channel messages listed below. If you deem them dangerous to the [station_name()], you can <A href='byond://?src=\ref[src];ac_toggle_d_notice=\ref[src.admincaster_feed_channel]'>Bestow a D-Notice upon the channel</A>.<HR>
			"}
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the [station_name()], and marked with a [global.using_map.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( !length(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"

			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[11]'>Back</A>"
		if(14)
			dat+="<B>Wanted Issue Handler:</B>"
			var/wanted_already = 0
			var/end_param = 1
			if(news_network.wanted_issue)
				wanted_already = 1
				end_param = 2
			if(wanted_already)
				dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
			dat+={"
				<HR>
				<A href='byond://?src=\ref[src];ac_set_wanted_name=1'>Criminal Name</A>: [src.admincaster_feed_message.author] <BR>
				<A href='byond://?src=\ref[src];ac_set_wanted_desc=1'>Description</A>: [src.admincaster_feed_message.body] <BR>
			"}
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'> [news_network.wanted_issue.backup_author]</FONT><BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> [src.admincaster_signature]</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
			if(wanted_already)
				dat+="<BR><A href='byond://?src=\ref[src];ac_cancel_wanted=1'>Take down Issue</A>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Cancel</A>"
		if(15)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] is now in Network Circulation.</FONT><BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(16)
			dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_message.author =="" || src.admincaster_feed_message.author == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>"
		if(17)
			dat+={"
				<B>Wanted Issue successfully deleted from Circulation</B><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		if(18)
			dat+={"
				<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>
				<B>Criminal</B>: [news_network.wanted_issue.author]<BR>
				<B>Description</B>: [news_network.wanted_issue.body]<BR>
				<B>Photo:</B>:
			"}
			if(news_network.wanted_issue.img)
				send_rsc(usr, news_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Back</A><BR>"
		if(19)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] successfully edited.</FONT><BR><BR>
				<BR><A href='byond://?src=\ref[src];ac_setScreen=[0]'>Return</A><BR>
			"}
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

//	log_debug("Channelname: [src.admincaster_feed_channel.channel_name] [src.admincaster_feed_channel.author]")
//	log_debug("Msg: [src.admincaster_feed_message.author] [src.admincaster_feed_message.body]")

	show_browser(usr, dat, "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")



/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN))	return

	var/dat = "<B>Job Bans!</B><HR><table>"
	for(var/t in jobban_keylist)
		var/r = t
		if( findtext(r,"##") )
			r = copytext( r, 1, findtext(r,"##") )//removes the description
		dat += text("<tr><td>[t] (<A href='byond://?src=\ref[src];removejobban=[r]'>unban</A>)</td></tr>")
	dat += "</table>"
	show_browser(usr, dat, "window=ban;size=400x400")

/datum/admins/proc/Game()
	if(!check_rights(0))	return

	var/dat = {"
		<center><B>Game Panel</B></center><hr>\n
		<A href='byond://?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
		"}
	if(SSticker.master_mode == "secret")
		dat += "<A href='byond://?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='byond://?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='byond://?src=\ref[src];quick_create_object=1'>Quick Create Object</A><br>
		<A href='byond://?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='byond://?src=\ref[src];create_mob=1'>Create Mob</A><br>
		<br><A href='byond://?src=\ref[src];vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='byond://?src=\ref[src];vsc=contam'>Edit Contaminant Settings</A><br>
		<A href='byond://?src=\ref[src];vsc=default'>Choose a default ZAS setting</A><br>
		"}

	show_browser(usr, dat, "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets(var/datum/admin_secret_category/active_category = null)
	if(!check_rights(0))	return

	// Print the header with category selection buttons.
	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"
	for(var/datum/admin_secret_category/category in admin_secrets.categories)
		if(!category.can_view(usr))
			continue
		if(active_category == category)
			dat += "<span class='linkOn'>[category.name]</span>"
		else
			dat += "<A href='byond://?src=\ref[src];admin_secrets_panel=\ref[category]'>[category.name]</A> "
	dat += "<HR>"

	// If a category is selected, print its description and then options
	if(istype(active_category) && active_category.can_view(usr))
		if(active_category.desc)
			dat += "<I>[active_category.desc]</I><BR>"
		for(var/datum/admin_secret_item/item in active_category.items)
			if(!item.can_view(usr))
				continue
			dat += "<A href='byond://?src=\ref[src];admin_secrets=\ref[item]'>[item.name()]</A><BR>"
		dat += "<BR>"

	var/datum/browser/popup = new(usr, "secrets", "Secrets", 550, 500)
	popup.set_content(dat)
	popup.open()
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.holder)
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_world("<span class='danger'>Restarting world!</span> <span class='notice'>Initiated by [usr.key]!</span>")
		log_admin("[key_name(usr)] initiated a reboot.")

		SSstatistics.set_field_details("end_error","admin reboot - by [usr.key]")
		SSstatistics.add_field_details("admin_verb","R") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		sleep(50)
		world.Reboot()


/datum/admins/proc/announce()
	set category = "Special Verbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))	return

	var/message = input("Global message to send:", "Admin Announce", null, null) as message
	message = sanitize(message, 500, extra = 0)
	if(message)
		message = replacetext(message, "\n", "<br>") // required since we're putting it in a <p> tag
		to_world("<span class=notice><b>[usr.key] Announces:</b><p style='text-indent: 50px'>[message]</p></span>")
		log_admin("Announce: [key_name(usr)] : [message]")
	SSstatistics.add_field_details("admin_verb","A") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle OOC"
	if(!check_rights(R_ADMIN))
		return
	if (toggle_config_value(/decl/config/toggle/on/ooc_allowed))
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled OOC.")
	SSstatistics.add_field_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaooc()
	set category = "Server"
	set desc="Globally Toggles AOOC"
	set name="Toggle AOOC"
	if(!check_rights(R_ADMIN))
		return
	if (toggle_config_value(/decl/config/toggle/on/aooc_allowed))
		communicate_broadcast(/decl/communication_channel/aooc, "The AOOC channel has been globally enabled!", TRUE)
	else
		communicate_broadcast(/decl/communication_channel/aooc, "The AOOC channel has been globally disabled!", TRUE)
	log_and_message_admins("toggled AOOC.")
	SSstatistics.add_field_details("admin_verb","TAOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Globally Toggles LOOC"
	set name="Toggle LOOC"

	if(!check_rights(R_ADMIN))
		return
	if (toggle_config_value(/decl/config/toggle/on/looc_allowed))
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled LOOC.")
	SSstatistics.add_field_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Globally Toggles DSAY"
	set name="Toggle DSAY"

	if(!check_rights(R_ADMIN))
		return
	if (toggle_config_value(/decl/config/toggle/on/dsay_allowed))
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	log_and_message_admins("toggled deadchat.")
	SSstatistics.add_field_details("admin_verb","TDSAY") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle Dead OOC."
	set name="Toggle Dead OOC"
	if(!check_rights(R_ADMIN))
		return
	toggle_config_value(/decl/config/toggle/on/dooc_allowed)
	log_admin("[key_name(usr)] toggled Dead OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)
	SSstatistics.add_field_details("admin_verb","TDOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglehubvisibility()
	set category = "Server"
	set desc="Globally Toggles Hub Visibility"
	set name="Toggle Hub Visibility"

	if(!check_rights(R_ADMIN))
		return

	//BYOND hates actually changing world.visibility at runtime, so let's just change if we give it the hub password.
	toggle_config_value(/decl/config/toggle/hub_visibility)
	var/new_vis = get_config_value(/decl/config/toggle/hub_visibility)
	var/long_message = "toggled hub visibility. The server is now [new_vis ? "visible" : "invisible"]."
	if (new_vis && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a firewall is blocking incoming connections.")

	SSwebhooks.send(WEBHOOK_AHELP_SENT, list("name" = "Hub Visibility Toggled (Game ID: [game_id])", "body" = "[key_name(src)]" + long_message))

	log_and_message_admins(long_message)
	SSstatistics.add_field_details("admin_verb","THUB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggletraitorscaling()
	set category = "Server"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	if(toggle_config_value(/decl/config/toggle/traitor_scaling))
		log_admin("[key_name(usr)] toggled Traitor Scaling to on.")
		message_admins("[key_name_admin(usr)] toggled Traitor Scaling on.", 1)
	else
		log_admin("[key_name(usr)] toggled Traitor Scaling to off.")
		message_admins("[key_name_admin(usr)] toggled Traitor Scaling off.", 1)
	SSstatistics.add_field_details("admin_verb","TTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(GAME_STATE < RUNLEVEL_LOBBY)
		to_chat(usr, "<span class='bigdanger'>Unable to start the game as it is not yet set up.</span>")
		SSticker.start_ASAP = !SSticker.start_ASAP
		if(SSticker.start_ASAP)
			to_chat(usr, "<span class='bigwarning'>The game will begin as soon as possible.</span>")
		else
			to_chat(usr, "<span class='bigwarning'>The game will begin as normal.</span>")
		return 0
	if(SSticker.start_now())
		log_admin("[usr.key] has started the game.")
		message_admins(SPAN_BLUE("[usr.key] has started the game."))
		SSstatistics.add_field_details("admin_verb","SN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return 1
	else
		to_chat(usr, "<span class='bigwarning'>Error: Start Now: Game has already started.</span>")
		return 0

/datum/admins/proc/endnow()
	set category = "Server"
	set desc = "Ending game round"
	set name = "End Round"
	if(!usr.client.holder || !check_rights(R_ADMIN))
		return

	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(usr, "<span class='bigdanger'>The round has not started yet!</span>")
		return

	var/confirm = alert("End the game round?", "Game Ending", "Yes", "Cancel")
	if(confirm == "Yes")
		Master.SetRunLevel(RUNLEVEL_POSTGAME)
		SSticker.end_game_state = END_GAME_READY_TO_END
		INVOKE_ASYNC(SSticker, TYPE_PROC_REF(/datum/controller/subsystem/ticker, declare_completion))
		log_and_message_admins("initiated a game ending.")
		to_world("<span class='danger'>Game ending!</span> <span class='notice'>Initiated by [usr.key]!</span>")
		SSstatistics.add_field("admin_verb","ER") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"
	if (toggle_config_value(/decl/config/toggle/on/enter_allowed))
		to_world("<B>New players may now enter the game.</B>")
	else
		to_world("<B>New players may no longer enter the game.</B>")
	log_and_message_admins("toggled new player game entering.")
	world.update_status()
	SSstatistics.add_field_details("admin_verb","TE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"

	if (toggle_config_value(/decl/config/toggle/on/allow_ai))
		to_world("<B>The AI job is chooseable now.</B>")
	else
		to_world("<B>The AI job is no longer chooseable.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	SSstatistics.add_field_details("admin_verb","TAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	if (toggle_config_value(/decl/config/toggle/on/abandon_allowed))
		to_world("<B>You may now respawn.</B>")
		log_and_message_admins("toggled respawn to On.")
	else
		to_world("<B>You may no longer respawn :(</B>")
		log_and_message_admins("toggled respawn to Off.")
	world.update_status()
	SSstatistics.add_field_details("admin_verb","TR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_aliens()
	set category = "Server"
	set desc="Toggle alien mobs"
	set name="Toggle Aliens"
	if(!check_rights(R_ADMIN))
		return
	if(toggle_config_value(/decl/config/toggle/aliens_allowed))
		log_admin("[key_name(usr)] toggled Aliens to On.")
		message_admins("[key_name_admin(usr)] toggled Aliens on.", 1)
	else
		log_admin("[key_name(usr)] toggled Aliens to Off.")
		message_admins("[key_name_admin(usr)] toggled Aliens off.", 1)
	SSstatistics.add_field_details("admin_verb","TA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_SERVER))	return
	if (GAME_STATE > RUNLEVEL_LOBBY)
		SSticker.delay_end = !SSticker.delay_end
		log_and_message_admins("[SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		return //alert("Round end delayed", null, null, null, null, null)
	SSticker.round_progressing = !SSticker.round_progressing
	if (!SSticker.round_progressing)
		to_world("<b>The game start has been delayed.</b>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_world("<b>The game will start soon.</b>")
		log_admin("[key_name(usr)] removed the delay.")
	SSstatistics.add_field_details("admin_verb","DELAY") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adjump()
	set category = "Server"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	toggle_config_value(/decl/config/toggle/on/admin_jump)
	log_and_message_admins("toggled admin jumping to [get_config_value(/decl/config/toggle/on/admin_jump)].")
	SSstatistics.add_field_details("admin_verb","TJ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adspawn()
	set category = "Server"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	toggle_config_value(/decl/config/toggle/on/admin_spawning)
	log_and_message_admins("toggled admin item spawning to [get_config_value(/decl/config/toggle/on/admin_spawning)].")
	SSstatistics.add_field_details("admin_verb","TAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adrev()
	set category = "Server"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	toggle_config_value(/decl/config/toggle/on/admin_revive)
	log_and_message_admins("toggled reviving to [get_config_value(/decl/config/toggle/on/admin_revive)].")
	SSstatistics.add_field_details("admin_verb","TAR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if(!usr.client.holder)	return
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	to_world("<span class='danger'>Rebooting world!</span> <span class='notice'>Initiated by [usr.key]!</span>")
	log_admin("[key_name(usr)] initiated an immediate reboot.")

	SSstatistics.set_field_details("end_error","immediate admin reboot - by [usr.key]")
	SSstatistics.add_field_details("admin_verb","IR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	world.Reboot()

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(var/character) // returns 1 for special characters and 2 for heroes of gamemode
	if(!SSticker.mode)
		return 0
	var/datum/mind/mind
	if (ismob(character))
		var/mob/character_mob = character
		mind = character_mob.mind
	else if(istype(character, /datum/mind))
		mind = character

	if(mind)
		if(SSticker.mode.antag_templates && SSticker.mode.antag_templates.len)
			for(var/decl/special_role/antag in SSticker.mode.antag_templates)
				if(antag.is_antagonist(mind))
					return 2
		if(mind.assigned_special_role)
			return 1

	if(isrobot(character))
		var/mob/living/silicon/robot/robot = character
		if(robot.emagged)
			return 1

	return 0

/datum/admins/proc/mass_debug_closet_icons()

	set name = "Mass Debug Closet Icons"
	set desc = "Spawn every possible custom closet. Do not do this on live."
	set category = "Debug"

	if(!check_rights(R_SPAWN))
		return

	if((input(usr, "Are you sure you want to spawn all these closets?", "So Many Closets") as null|anything in list("No", "Yes")) == "Yes")
		log_admin("[key_name(usr)] mass-spawned closets (icon debug), if this is a live server you should yell at them.")
		var/x = 0
		var/y = 0
		for(var/check_appearance in decls_repository.get_decl_paths_of_type(/decl/closet_appearance))
			x++
			if(x > 10)
				x = 0
				y++
			var/turf/T = locate(usr.x+x, usr.y+y, usr.z)
			if(T)
				new /obj/structure/closet/debug(T, check_appearance)

/datum/admins/proc/check_unconverted_single_icon_items()
	set category = "Debug"
	set desc = "Count items missing single icon definition."
	set name = "Check Single Mob Icons"
	if(!check_rights(R_DEBUG))
		return
	var/types_missing_icons
	for(var/checktype in typesof(/obj/item))
		var/obj/item/I = checktype
		var/check_icon = initial(I.icon)
		if(!check_state_in_icon(ICON_STATE_INV, check_icon) && !check_state_in_icon(ICON_STATE_WORLD, check_icon))
			LAZYADD(types_missing_icons, checktype)
	if(alert("[LAZYLEN(types_missing_icons)] item\s are missing world or inventory states. Do you wish to see the full list?", "Check missing icons", "Yes", "No") == "Yes")
		for(var/checktype in types_missing_icons)
			to_chat(usr, checktype)

/datum/admins/proc/spawn_fruit(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn the product of a seed."
	set name = "Spawn Fruit"
	if(!check_rights(R_SPAWN) || !seedtype || !SSplants.seeds[seedtype])
		return
	var/datum/seed/S = SSplants.seeds[seedtype]
	if(S?.harvest(usr, 0, FALSE, 1))
		log_admin("[key_name(usr)] spawned [seedtype] fruit at ([usr.x],[usr.y],[usr.z])")
	else
		to_chat(usr, SPAN_WARNING("Failed to harvest [seedtype]."))

/datum/admins/proc/spawn_custom_item()
	set category = "Debug"
	set desc = "Spawn a custom item."
	set name = "Spawn Custom Item"

	if(!check_rights(R_SPAWN))	return

	var/owner = input("Select a ckey.", "Spawn Custom Item") as null|anything in SScustomitems.custom_items_by_ckey
	if(!owner|| !SScustomitems.custom_items_by_ckey[owner])
		return

	var/list/possible_items = list()
	for(var/datum/custom_item/item in SScustomitems.custom_items_by_ckey[owner])
		possible_items[item.item_name] = item
	var/item_to_spawn = input("Select an item to spawn.", "Spawn Custom Item") as null|anything in possible_items
	if(item_to_spawn && possible_items[item_to_spawn])
		var/datum/custom_item/item_datum = possible_items[item_to_spawn]
		item_datum.spawn_item(get_turf(usr))

/datum/admins/proc/check_custom_items()

	set category = "Debug"
	set desc = "Check the custom item list."
	set name = "Check Custom Items"

	if(!check_rights(R_SPAWN))	return

	if(!SScustomitems.custom_items_by_ckey)
		to_chat(usr, "Custom item list is null.")
		return

	if(!SScustomitems.custom_items_by_ckey.len)
		to_chat(usr, "Custom item list not populated.")
		return

	for(var/assoc_key in SScustomitems.custom_items_by_ckey)
		to_chat(usr, "[assoc_key] has:")
		var/list/current_items = SScustomitems.custom_items_by_ckey[assoc_key]
		for(var/datum/custom_item/item in current_items)
			to_chat(usr, "- name: [item.item_name] state: [item.item_state] icon: [item.item_icon] path: [item.item_path] desc: [item.item_desc]")

/datum/admins/proc/spawn_plant(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn a spreading plant effect."
	set name = "Spawn Plant"

	if(!check_rights(R_SPAWN))	return

	if(!seedtype || !SSplants.seeds[seedtype])
		return
	new /obj/effect/vine(get_turf(usr), SSplants.seeds[seedtype])
	log_admin("[key_name(usr)] spawned [seedtype] vines at ([usr.x],[usr.y],[usr.z])")

/datum/admins/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))
		return

	object = lowertext(trim(object))
	if(!object)
		return

	var/list/matches = new()
	for(var/path in subtypesof(/atom))
		var/atom/path_cast = path
		if(TYPE_IS_SPAWNABLE(path_cast) && findtext(lowertext("[path]"), object))
			// We need to keep the type as a string because for some ungodly reason input() compares
			// initial invisibility value to mob see_invisible.
			matches += "[path]"

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input(usr, "Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	chosen = text2path(chosen) // See comment above.
	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	SSstatistics.add_field_details("admin_verb","SA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/show_special_roles(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Special Roles"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.edit_memory()
	SSstatistics.add_field_details("admin_verb","STP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/show_game_mode()
	set category = "Admin"
	set desc = "Show the current round configuration."
	set name = "Show Game Mode"

	if(!SSticker.mode)
		alert("Not before roundstart!", "Alert")
		return

	var/out = "<font size=3><b>Current mode: [SSticker.mode.name] (<a href='byond://?src=\ref[SSticker.mode];debug_antag=self'>[SSticker.mode.uid]</a>)</b></font><br/>"
	out += "<hr>"

	if(SSticker.mode.ert_disabled)
		out += "<b>Emergency Response Teams:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=ert'>disabled</a>"
	else
		out += "<b>Emergency Response Teams:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=ert'>enabled</a>"
	out += "<br/>"

	if(SSticker.mode.deny_respawn)
		out += "<b>Respawning:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=respawn'>disallowed</a>"
	else
		out += "<b>Respawning:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=respawn'>allowed</a>"
	out += "<br/>"

	out += "<b>Shuttle delay multiplier:</b> <a href='byond://?src=\ref[SSticker.mode];set=shuttle_delay'>[SSticker.mode.shuttle_delay]</a><br/>"

	if(SSticker.mode.auto_recall_shuttle)
		out += "<b>Shuttle auto-recall:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=shuttle_recall'>enabled</a>"
	else
		out += "<b>Shuttle auto-recall:</b> <a href='byond://?src=\ref[SSticker.mode];toggle=shuttle_recall'>disabled</a>"
	out += "<br/><br/>"

	if(SSticker.mode.event_delay_mod_moderate)
		out += "<b>Moderate event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_moderate'>[SSticker.mode.event_delay_mod_moderate]</a><br/>"
	else
		out += "<b>Moderate event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_moderate'>unset</a><br/>"

	if(SSticker.mode.event_delay_mod_major)
		out += "<b>Major event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_severe'>[SSticker.mode.event_delay_mod_major]</a><br/>"
	else
		out += "<b>Major event time modifier:</b> <a href='byond://?src=\ref[SSticker.mode];set=event_modifier_severe'>unset</a><br/>"

	out += "<hr>"

	if(length(SSticker.mode.associated_antags))
		out += "<b>Core antag templates:</b></br>"
		for(var/antag_type in SSticker.mode.associated_antags)
			var/decl/special_role/antag = GET_DECL(antag_type)
			if(antag)
				out += "<a href='byond://?src=\ref[SSticker.mode];debug_antag=\ref[antag]'>[antag.name]</a>.</br>"

	if(SSticker.mode.round_autoantag)
		out += "<b>Autotraitor <a href='byond://?src=\ref[SSticker.mode];toggle=autotraitor'>enabled</a></b>."
		if(SSticker.mode.antag_scaling_coeff > 0)
			out += " (scaling with <a href='byond://?src=\ref[SSticker.mode];set=antag_scaling'>[SSticker.mode.antag_scaling_coeff]</a>)"
		else
			out += " (not currently scaling, <a href='byond://?src=\ref[SSticker.mode];set=antag_scaling'>set a coefficient</a>)"
		out += "<br/>"
	else
		out += "<b>Autotraitor <a href='byond://?src=\ref[SSticker.mode];toggle=autotraitor'>disabled</a></b>.<br/>"

	out += "<b>All antag ids:</b>"
	if(SSticker.mode.antag_templates && SSticker.mode.antag_templates.len)
		for(var/decl/special_role/antag in SSticker.mode.antag_templates)
			antag.update_current_antag_max(SSticker.mode)
			out += " <a href='byond://?src=\ref[SSticker.mode];debug_antag=\ref[antag]'>[antag.name]</a>"
			out += " ([antag.get_antag_count()]/[antag.cur_max]) "
			out += " <a href='byond://?src=\ref[SSticker.mode];remove_antag_type=\ref[antag]'>\[-\]</a><br/>"
	else
		out += " None."
	out += " <a href='byond://?src=\ref[SSticker.mode];add_antag_type=1'>\[+\]</a><br/>"

	show_browser(usr, out, "window=edit_mode[src]")
	SSstatistics.add_field_details("admin_verb","SGM")


/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmets."
	if (toggle_config_value(/decl/config/toggle/on/welder_vision))
		to_world("<B>Reduced welder vision has been enabled!</B>")
	else
		to_world("<B>Reduced welder vision has been disabled!</B>")
	log_and_message_admins("toggled welder vision.")
	SSstatistics.add_field_details("admin_verb","TTWH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	if (toggle_config_value(/decl/config/toggle/guests_allowed))
		to_world("<B>Guests may now enter the game.</B>")
		log_admin("[key_name(usr)] toggled guests game entering allowed.")
		log_and_message_admins("toggled guests game entering allowed.")
	else
		to_world("<B>Guests may no longer enter the game.</B>")
		log_admin("[key_name(usr)] toggled guests game entering disallowed.")
		log_and_message_admins("toggled guests game entering disallowed.")
	SSstatistics.add_field_details("admin_verb","TGU") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in SSmobs.mob_list)
		ai_number++
		if(isAI(S))
			to_chat(usr, "<b>AI [key_name(S, usr)]'s laws:</b>")
		else if(isrobot(S))
			var/mob/living/silicon/robot/robot = S
			to_chat(usr, "<b>CYBORG [key_name(S, usr)] [robot.connected_ai?"(Slaved to: [robot.connected_ai])":"(Independant)"]: laws:</b>")
		else if (ispAI(S))
			to_chat(usr, "<b>pAI [key_name(S, usr)]'s laws:</b>")
		else
			to_chat(usr, "<b>SOMETHING SILICON [key_name(S, usr)]'s laws:</b>")

		if (S.laws == null)
			to_chat(usr, "[key_name(S, usr)]'s laws are null?? Contact a coder.")
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		to_chat(usr, "<b>No AIs located</b>")//Just so you know the thing is actually working and not just ignoring you.

/datum/admins/proc/show_skills(mob/M)
	set category = "Admin"
	set name = "Skill Panel"

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(!M)
		M = input("Select mob.", "Select mob.") as null|anything in global.player_list
	if(!istype(M))
		return
	var/datum/nano_module/skill_ui/NM = /datum/nano_module/skill_ui
	if(is_admin(usr))
		NM = /datum/nano_module/skill_ui/admin //They get the fancy version that lets you change skills and debug stuff.
	NM = new NM(usr, override = M.skillset)
	NM.ui_interact(usr)

/proc/get_options_bar(whom, detail = 2, name = 0, link = 1, highlight_special = 1, var/datum/ticket/ticket = null)
	if(!whom)
		return "<b>(*null*)</b>"
	var/mob/M
	var/client/C
	if(istype(whom, /client))
		C = whom
		M = C.mob
	else if(ismob(whom))
		M = whom
		C = M.client
	else
		return "<b>(*not a mob*)</b>"
	switch(detail)
		if(0)
			return "<b>[key_name(C, link, name, highlight_special, ticket)]</b>"

		if(1)	//Private Messages
			return "<b>[key_name(C, link, name, highlight_special, ticket)](<A HREF='byond://?_src_=holder;adminmoreinfo=\ref[M]'>?</A>)</b>"

		if(2)	//Admins
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special, ticket)](<A HREF='byond://?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='byond://?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='byond://?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='byond://?_src_=holder;narrateto=[ref_mob]'>DN</A>) ([admin_jump_link(M)]) (<A HREF='byond://?_src_=holder;show_round_status=1'>RS</A>)</b>"

		if(3)	//Devs
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special, ticket)](<A HREF='byond://?_src_=vars;Vars=[ref_mob]'>VV</A>)([admin_jump_link(M)])</b>"

/proc/ishost(var/client/C)
	return check_rights(R_HOST, 0, C)

//Prevents SDQL2 commands from changing admin permissions
/datum/admins/SDQL_update(var/const/var_name, var/new_value)
	return 0

//
//
//ALL DONE
//*********************************************************************************************************
//

//Returns 1 to let the dragdrop code know we are trapping this event
//Returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(var/mob/observer/ghost/frommob, var/mob/living/tomob)
	if(!istype(frommob))
		return //Extra sanity check to make sure only observers are shoved into things

	//Same as assume-direct-control perm requirements.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_ADMIN|R_DEBUG,0))
		return 0
	if (!frommob.ckey)
		return 0
	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"
	var/ask = alert(question, "Place ghost in control of mob?", "Yes", "No")
	if (ask != "Yes")
		return 1
	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return 1
	if(tomob.client) //No need to ghostize if there is no client
		tomob.ghostize()
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] has put [frommob.ckey] in control of [tomob.name].</span>")
	log_admin("[key_name(usr)] stuffed [frommob.ckey] into [tomob.name].")
	SSstatistics.add_field_details("admin_verb","CGD")
	tomob.ckey = frommob.ckey
	tomob.teleop = null // no longer (a)ghosting
	qdel(frommob)
	return 1

/datum/admins/proc/force_antag_latespawn()
	set category = "Admin"
	set name = "Force Template Spawn"
	set desc = "Force an antagonist template to spawn."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(usr, "Mode has not started.")
		return

	var/list/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
	var/antag_type = input("Choose a template.","Force Latespawn") as null|anything in all_antag_types
	if(!antag_type)
		to_chat(usr, "Aborting.")
		return

	var/decl/special_role/antag = all_antag_types[antag_type]
	message_admins("[key_name(usr)] attempting to force latespawn of [antag.name].")
	antag.attempt_auto_spawn()

/datum/admins/proc/force_mode_latespawn()
	set category = "Admin"
	set name = "Force Mode Spawn"
	set desc = "Force autotraitor to proc."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins) || !check_rights(R_ADMIN))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(usr, "Mode has not started.")
		return

	log_and_message_admins("attempting to force mode autospawn.")
	SSticker.mode.process_autoantag()

/datum/admins/proc/paralyze_mob(mob/living/M as mob in global.player_list)
	set category = "Admin"
	set name = "Toggle Paralyze"
	set desc = "Toggles paralyze state, which stuns, blinds and mutes the victim."

	if(!isliving(M))
		to_chat(usr, SPAN_WARNING("This verb can only be used on /mob/living targets."))
		return

	if(check_rights(R_INVESTIGATE))
		if(!M.admin_paralyzed)
			M.visible_message(
				SPAN_OCCULT("OOC: \The [M] has been paralyzed by a staff member. Please hold all interactions with them until staff have finished with them."),
				SPAN_OCCULT("OOC: You have been paralyzed by a staff member. Please refer to your currently open admin help ticket or, if you don't have one, admin help for assistance.")
			)
			M.set_status_condition(STAT_PARA, 8000)
			M.admin_paralyzed = TRUE
		else
			M.set_status_condition(STAT_PARA, 0)
			M.admin_paralyzed = FALSE
			M.visible_message(SPAN_OCCULT("OOC: \The [M] has been released from paralysis by staff. You may resume interactions with them."))
			to_chat(M, SPAN_OCCULT("OOC: You have been released from paralysis by staff and can return to your game."))
		log_and_message_admins("has [HAS_STATUS(M, STAT_PARA) ? "paralyzed" : "unparalyzed"] [key_name(M)].")


/datum/admins/var/obj/item/paper/admin/faxreply // var to hold fax replies in

/proc/cmp_network_device_tag_asc(atom/a, atom/b)
	var/datum/extension/network_device/NA = get_extension(a, /datum/extension/network_device)
	var/datum/extension/network_device/NB = get_extension(b, /datum/extension/network_device)
	return sorttext(NB? "[NB.network_id].[NB.network_tag]" : "", NA? "[NA.network_id].[NA.network_tag]" : "")

/datum/admins/proc/show_fax_picker(var/list/possible_targets, var/mob/user)
	var/html = "<h2>Pick a target fax machine:</h2>"
	possible_targets = sortTim(possible_targets, /proc/cmp_network_device_tag_asc, FALSE)
	for(var/obj/machinery/faxmachine/F in possible_targets)
		var/datum/extension/network_device/N = get_extension(F, /datum/extension/network_device)
		var/datum/computer_network/CN = N?.get_network()
		if(!N || !CN)
			continue
		var/area/A = get_area(F)
		html += "<li><a href='byond://?src=\ref[src];asf_pick_fax=1;destination=\ref[F]'>[CN.network_id].[N.network_tag] [A? "([A])" : ""]</a></li>"
	html = "<ul>[html]</ul>"
	html = "<html><header/><body>[html]</body></html>"
	show_browser(user, html, "size=512x800;window=faxpicker;title=")

/datum/admins/proc/sendFax()
	set waitfor = FALSE //This takes a while to process
	set category = "Special Verbs"
	set name = "Send Fax"
	set desc = "Create and send a fax to the specified fax machine."

	var/mob/user = usr
	if (!istype(src, /datum/admins))
		src = user.client.holder
	if(!istype(src, /datum/admins) || !check_rights(R_ADMIN | R_MOD, "Error: you must have admin/moderator rights to send a fax!", user?.client))
		return

	var/list/possible_targets
	for(var/_key in SSnetworking.networks)
		var/datum/computer_network/N = SSnetworking.networks[_key]
		if(!N)
			continue
		var/list/found = N.get_devices_by_type(/obj/machinery/faxmachine) //This thing returns empty lists! It's ruude.
		if(length(found))
			LAZYADD(possible_targets, found)

	if(length(possible_targets))
		show_fax_picker(possible_targets, user) //Topic will handle the rest!
	else
		to_chat(user, SPAN_WARNING("There aren't any fax machines connected to a network in the world!"))

/datum/admins/proc/faxCallback(var/obj/item/paper/admin/P, var/obj/machinery/faxmachine/destination)
	var/customname = input(src.owner, "Pick a title for the report", "Title")
	P.SetName("[P.origin] - [customname]")
	P.desc = "This is a paper titled '" + P.name + "'."

	if(P.sender || alert("Would you like the fax stamped?",, "Yes", "No") == "Yes")
		P.apply_custom_stamp('icons/obj/items/stamps/stamp_boss.dmi', "by the [P.origin] Quantum Relay")

	if(P.sender || alert("Would you like the fax signed?",, "Yes", "No") == "Yes")
		var/sig = input(src.owner, "Enter the name you wish to sign the paper with.", "Signature") as text|null
		if(length(sig))
			P.set_signature(sig)

	var/decl/public_access/public_method/recv = GET_DECL(/decl/public_access/public_method/fax_receive_document)
	if(recv.perform(destination, P, P.origin))
		var/datum/extension/network_device/N  = get_extension(destination, /datum/extension/network_device)
		to_chat(src.owner, SPAN_NOTICE("Message reply to transmitted successfully."))
		message_staff_fax(P, destination, src.owner, N?.network_id, N?.network_tag)
	else
		to_chat(src.owner, SPAN_WARNING("Message reply failed."))

	LAZYADD(global.adminfaxes, P)
	faxreply = null

/datum/admins/proc/addserverwhitelist(ckey as text)
	set category = "Admin"
	set name = "Add Ckey To Server Whitelist"
	set desc = "Permanently adds the specified ckey to the server whitelist."

	ckey = ckey(ckey)

	if(!ckey)
		to_chat(usr, SPAN_WARNING("Please specify a ckey to insert."))
	else if(check_server_whitelist(ckey)) // This will also preload the server whitelist.
		to_chat(usr, SPAN_WARNING("That ckey is already server whitelisted."))
	else
		global.server_whitelist |= ckey
		save_server_whitelist()
		log_and_message_admins("has added [ckey] to the server whitelist.", usr)

/datum/admins/proc/removeserverwhitelist(ckey as text)
	set category = "Admin"
	set name = "Remove Ckey From Server Whitelist"
	set desc = "Permanently removes the specified ckey from the server whitelist."

	ckey = ckey(ckey)
	if(!ckey)
		to_chat(usr, SPAN_WARNING("Please specify a ckey to remove."))
	else if(!check_server_whitelist(ckey)) // This will also preload the server whitelist.
		to_chat(usr, SPAN_WARNING("That ckey is not server whitelisted."))
	else
		global.server_whitelist -= ckey
		save_server_whitelist()
		log_and_message_admins("has removed [ckey] from the server whitelist.", usr)
