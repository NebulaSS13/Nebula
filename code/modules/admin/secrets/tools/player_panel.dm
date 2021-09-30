/datum/admin_secret_item/admin_tools/player_panel
	name = "Player Panel"

/datum/admin_secret_item/admin_tools/player_panel/execute(var/mob/user, var/mob) //need to override to supply second arg.
	if(!can_execute(user))
		return FALSE

	if(log)
		log_and_message_admins("used secret '[name]'", user)
	if(feedback)
		SSstatistics.add_field("admin_secrets_used",1)
		SSstatistics.add_field_details("admin_secrets_used","[name]")
	. = TRUE
	do_execute(user, mob)

/datum/admin_secret_item/admin_tools/player_panel/do_execute(var/user, var/mob/M)

	if(!M)
		M = input(usr, "Select A Mob", "Player Panel Selection") as anything in SSmobs.mob_list

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
		body += "\[<A href='?src=\ref[src];editrights=show'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]"
	else if(last_ckey)
		body += " (last occupied by ckey <b>[last_ckey]</b>)"

	if(istype(M, /mob/new_player))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='?src=\ref[src];revive=\ref[M]'>Heal</A>\] "

	var/mob/living/exosuit/E = M
	if(istype(E) && E.pilots)
		body += "<br><b>Exosuit pilots:</b><br>"
		for(var/mob/living/pilot in E.pilots)
			body += "[pilot] "
			body += " \[<A href='?src=\ref[src];pilot=\ref[pilot]'>link</a>\]<br>"

	body += {"
		<br><br>\[
		<a href='?_src_=vars;Vars=\ref[M]'>View Vars</a> -
		<a href='?src=\ref[src];show_special_roles=\ref[M]'>Roles</a> -
		<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a> -
		<a href='?src=\ref[src];narrateto=\ref[M]'>Narrate</a> -
		[admin_jump_link(M, src)]\] <br>
		<b>Mob type:</b> [M.type]<br>
		<b>Inactivity time:</b> [M.client ? "[M.client.inactivity/600] minutes" : "Logged out"]<br/><br/>
		<A href='?src=\ref[src];boot2=\ref[M]'>Kick</A> |
		<A href='?_src_=holder;warn=[last_ckey]'>Warn</A> |
		<A href='?src=\ref[src];newban=\ref[M];last_key=[last_ckey]'>Ban</A> |
		<A href='?src=\ref[src];jobban_panel_target=\ref[M]'>Jobban</A> |
		<A href='?src=\ref[src];notes=show;mob=\ref[M]'>Notes</A>
	"}

	if(M.client)
		body += "| <A HREF='?src=\ref[src];sendtoprison=\ref[M]'>Prison</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\[<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_AOOC]'><font color='[(muted & MUTE_AOOC)?"red":"blue"]'>AOOC</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> |
			<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]
			(<A href='?src=\ref[src];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)
		"}
		body += "<br><br><b>Staff Warning:</b> [M.client.staffwarn ? M.client.staffwarn : "No"]<br>"
		if (!M.client.staffwarn)
			body += "<A href='?src=\ref[src];setstaffwarn=\ref[M]'>Set StaffWarn</A>"
		else
			body += "<A href='?src=\ref[src];removestaffwarn=\ref[M]'>Remove StaffWarn</A>"

	body += {"<br><br>
		<A href='?src=\ref[src];jumpto=\ref[M]'><b>Jump to</b></A> |
		<A href='?src=\ref[src];getmob=\ref[M]'>Get</A> |
		<A href='?src=\ref[src];sendmob=\ref[M]'>Send To</A>
		<br><br>
		[check_rights(R_INVESTIGATE,0) ? "<A href='?src=\ref[src];skillpanel=\ref[M]'>Skill panel</A>" : "" ]
	"}

	if(M.mind)
		body += "<br><br>"
		body += "<b>Goals:</b>"
		body += "<br>"
		body += "[jointext(M.mind.summarize_goals(FALSE, TRUE, src), "<br>")]"
		body += "<br>"
		body += "<a href='?src=\ref[M.mind];add_goal=1'>Add Random Goal</a>"

	var/list/all_modpacks = decls_repository.get_decls_of_subtype(/decl/modpack)
	for(var/package in all_modpacks)
		var/decl/modpack/manifest = all_modpacks[package]
		var/extra_body = manifest.get_player_panel_options(M)
		if(extra_body)
			body += "<br><br>"
			body += extra_body

	if (M.client)
		if(!istype(M, /mob/new_player))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Monkey
			if(issmall(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='?src=\ref[src];monkeyone=\ref[M]'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='?src=\ref[src];corgione=\ref[M]'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='?src=\ref[src];makeai=\ref[M]'>Make AI</A> |
					<A href='?src=\ref[src];makerobot=\ref[M]'>Make Robot</A> |
					<A href='?src=\ref[src];makealien=\ref[M]'>Make Alien</A>
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='?src=\ref[src];makeanimal=\ref[M]'>Re-Animalize</A> | "
			else
				body += "<A href='?src=\ref[src];makeanimal=\ref[M]'>Animalize</A> | "

			// DNA2 - Admin Hax
			if(M.dna && iscarbon(M))
				body += "<br><br>"
				body += "<b>DNA Blocks:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block=1;block<=DNA_SE_LENGTH;block++)
					if(((block-1)%5)==0)
						body += "</tr><tr><th>[block-1]</th>"
					bname = assigned_blocks[block]
					body += "<td>"
					if(bname)
						var/bstate=M.dna.GetSEState(block)
						var/bcolor="[(bstate)?"#006600":"#ff0000"]"
						body += "<A href='?src=\ref[src];togmutate=\ref[M];block=[block]' style='color:[bcolor];'>[bname]</A><sub>[block]</sub>"
					else
						body += "[block]"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>
				<A href='?src=\ref[src];simplemake=observer;mob=\ref[M]'>Observer</A> |
				\[ Xenos: <A href='?src=\ref[src];simplemake=larva;mob=\ref[M]'>Larva</A>
				\[ Crew: <A href='?src=\ref[src];simplemake=human;mob=\ref[M]'>Human</A>
				\[ slime: <A href='?src=\ref[src];simplemake=slime;mob=\ref[M]'>Baby</A>,
				<A href='?src=\ref[src];simplemake=adultslime;mob=\ref[M]'>Adult</A> \]
				<A href='?src=\ref[src];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='?src=\ref[src];simplemake=robot;mob=\ref[M]'>Cyborg</A> |
				<A href='?src=\ref[src];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='?src=\ref[src];simplemake=runtime;mob=\ref[M]'>Runtime</A> |
				<A href='?src=\ref[src];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='?src=\ref[src];simplemake=ian;mob=\ref[M]'>Ian</A> |
				<A href='?src=\ref[src];simplemake=crab;mob=\ref[M]'>Crab</A> |
				<A href='?src=\ref[src];simplemake=coffee;mob=\ref[M]'>Coffee</A> |
				\[ Construct: <A href='?src=\ref[src];simplemake=constructarmoured;mob=\ref[M]'>Armoured</A> ,
				<A href='?src=\ref[src];simplemake=constructbuilder;mob=\ref[M]'>Builder</A> ,
				<A href='?src=\ref[src];simplemake=constructwraith;mob=\ref[M]'>Wraith</A> \]
				<A href='?src=\ref[src];simplemake=shade;mob=\ref[M]'>Shade</A>
				<br>
			"}
	body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='?src=\ref[src];forcespeech=\ref[M]'>Forcesay</A>
			"}
	// language toggles
	body += "<br><br><b>Languages:</b><br>"
	var/f = 1
	var/list/language_types = decls_repository.get_decls_of_subtype(/decl/language)
	for(var/k in language_types)
		var/decl/language/L = language_types[k]
		if(!(L.flags & INNATE))
			if(!f)
				body += " | "
			else
				f = 0
			if(L in M.languages)
				body += "<a href='?src=\ref[src];toglang=\ref[M];lang=[L.name]' style='color:#006600'>[L.name]</a>"
			else
				body += "<a href='?src=\ref[src];toglang=\ref[M];lang=[L.name]' style='color:#ff0000'>[L.name]</a>"

	body += {"<br>
		</body></html>
	"}

	var/datum/browser/popup = new(usr, "playerpanel", "Player Panel", 550, 515)
	popup.set_content(body)
	popup.update(TRUE, TRUE)
	SSstatistics.add_field_details("admin_verb","SPP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admin_secret_item/admin_tools/admin_pms/Topic(href, href_list)
	. = ..()

	var/datum/admins/AD = usr.client.holder
	
	if(href_list["editrights"])
		if(!check_rights(R_PERMISSIONS))
			message_admins("[key_name_admin(usr)] attempted to edit the admin permissions without sufficient rights.")
			log_admin("[key_name(usr)] attempted to edit the admin permissions without sufficient rights.")
			return

		var/adm_ckey

		var/task = href_list["editrights"]
		if(task == "add")
			var/new_ckey = ckey(input(usr,"New admin's ckey","Admin ckey", null) as text|null)
			if(!new_ckey)	return
			if(new_ckey in admin_datums)
				to_chat(usr, "<font color='red'>Error: Topic 'editrights': [new_ckey] is already an admin</font>")
				return
			adm_ckey = new_ckey
			task = "rank"
		else if(task != "show")
			adm_ckey = ckey(href_list["ckey"])
			if(!adm_ckey)
				to_chat(usr, "<font color='red'>Error: Topic 'editrights': No valid ckey</font>")
				return

		var/datum/admins/D = admin_datums[adm_ckey]

		if(task == "remove")
			if(alert("Are you sure you want to remove [adm_ckey]?","Message","Yes","Cancel") == "Yes")
				if(!D)	return
				admin_datums -= adm_ckey
				D.disassociate()

				message_admins("[key_name_admin(usr)] removed [adm_ckey] from the admins list")
				log_admin("[key_name(usr)] removed [adm_ckey] from the admins list")
				AD.log_admin_rank_modification(adm_ckey, "Removed")

		else if(task == "rank")
			var/new_rank
			if(admin_ranks.len)
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in (admin_ranks|"*New Rank*")
			else
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in list("Game Master","Game Admin", "Trial Admin", "Admin Observer","*New Rank*")

			var/rights = 0
			if(D)
				rights = D.rights
			switch(new_rank)
				if(null,"") return
				if("*New Rank*")
					new_rank = input("Please input a new rank", "New custom rank", null, null) as null|text
					if(config.admin_legacy_system)
						new_rank = ckeyEx(new_rank)
					if(!new_rank)
						to_chat(usr, "<font color='red'>Error: Topic 'editrights': Invalid rank</font>")
						return
					if(config.admin_legacy_system)
						if(admin_ranks.len)
							if(new_rank in admin_ranks)
								rights = admin_ranks[new_rank]		//we typed a rank which already exists, use its rights
							else
								admin_ranks[new_rank] = 0			//add the new rank to admin_ranks
				else
					if(config.admin_legacy_system)
						new_rank = ckeyEx(new_rank)
						rights = admin_ranks[new_rank]				//we input an existing rank, use its rights

			if(D)
				D.disassociate()								//remove adminverbs and unlink from client
				D.rank = new_rank								//update the rank
				D.rights = rights								//update the rights based on admin_ranks (default: 0)
			else
				D = new /datum/admins(new_rank, rights, adm_ckey)

			var/client/C = global.ckey_directory[adm_ckey]					//find the client with the specified ckey (if they are logged in)
			D.associate(C)											//link up with the client and add verbs

			to_chat(C, "[key_name_admin(usr)] has set your admin rank to: [new_rank].")
			message_admins("[key_name_admin(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			log_admin("[key_name(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			AD.log_admin_rank_modification(adm_ckey, new_rank)

		else if(task == "permissions")
			if(!D)	return
			var/list/permissionlist = list()
			for(var/i=1, i<=R_MAXPERMISSION, i<<=1)		//that <<= is shorthand for i = i << 1. Which is a left bitshift
				permissionlist[rights2text(i)] = i
			var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist
			if(!new_permission)	return
			D.rights ^= permissionlist[new_permission]

			var/client/C = global.ckey_directory[adm_ckey]
			to_chat(C, "[key_name_admin(usr)] has toggled your permission: [new_permission].")
			message_admins("[key_name_admin(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin("[key_name(usr)] toggled the [new_permission] permission of [adm_ckey]")
			AD.log_admin_permission_modification(adm_ckey, permissionlist[new_permission])

		AD.edit_admin_permissions()
	else if(href_list["revive"])
		if(!check_rights(R_REJUVENATE))	return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			to_chat(usr, "This can only be used on instances of type /mob/living")
			return

		if(config.allow_admin_rev)
			L.revive()
			log_and_message_admins("healed/revived [key_name(L)]")
		else
			to_chat(usr, "Admin rejuvenates have been disabled")
	if(href_list["pilot"])
		var/mob/M = locate(href_list["pilot"])
		if(!ismob(M)) return

		AD.show_player_panel(M)
	else if(href_list["jumpto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")	return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_INVESTIGATE))	return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["show_special_roles"])
		if(!check_rights(R_ADMIN|R_MOD))	return

		if(GAME_STATE < RUNLEVEL_GAME)
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["show_special_roles"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.")
			return
		AD.show_special_roles(M)

	else if(href_list["skillpanel"])
		if(!check_rights(R_INVESTIGATE))
			return

		if(GAME_STATE < RUNLEVEL_GAME)
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["skillpanel"])
		AD.show_skills(M)
	else if(href_list["unbanf"])
		if(!check_rights(R_BAN))	return

		var/banfolder = href_list["unbanf"]
		Banlist.cd = "/base/[banfolder]"
		var/key = Banlist["key"]
		if(alert(usr, "Are you sure you want to unban [key]?", "Confirmation", "Yes", "No") == "Yes")
			if(RemoveBan(banfolder))
				AD.unbanpanel()
			else
				alert(usr, "This ban has already been lifted / does not exist.", "Error", "Ok")
				AD.unbanpanel()

	else if(href_list["warn"])
		usr.client.warn(href_list["warn"])

	else if(href_list["unbane"])
		if(!check_rights(R_BAN))	return

		UpdateTime()
		var/reason

		var/banfolder = href_list["unbane"]
		Banlist.cd = "/base/[banfolder]"
		var/reason2 = Banlist["reason"]
		var/temp = Banlist["temp"]

		var/minutes = Banlist["minutes"]

		var/banned_key = Banlist["key"]
		Banlist.cd = "/base"

		var/duration

		switch(alert("Temporary Ban?",,"Yes","No"))
			if("Yes")
				temp = 1
				var/mins = 0
				if(minutes > CMinutes)
					mins = minutes - CMinutes
				mins = input(usr,"How long (in minutes)? (Default: 1440)","Ban time",mins ? mins : 1440) as num|null
				if(!mins)	return
				mins = min(525599,mins)
				minutes = CMinutes + mins
				duration = GetExp(minutes)
				reason = sanitize(input(usr,"Reason?","reason",reason2) as text|null)
				if(!reason)	return
			if("No")
				temp = 0
				duration = "Perma"
				reason = sanitize(input(usr,"Reason?","reason",reason2) as text|null)
				if(!reason)	return

		ban_unban_log_save("[key_name(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [duration]")
		log_and_message_admins("edited [banned_key]'s ban. Reason: [reason] Duration: [duration]")
		Banlist.cd = "/base/[banfolder]"
		Banlist["reason"] << reason
		Banlist["temp"] << temp
		Banlist["minutes"] << minutes
		Banlist["bannedby"] << usr.ckey
		Banlist.cd = "/base"
		SSstatistics.add_field("ban_edit",1)
		AD.unbanpanel()

	/////////////////////////////////////new ban stuff

	else if(href_list["jobban_panel_target"])
//		if(!check_rights(R_BAN))	return

		var/mob/M = locate(href_list["jobban_panel_target"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(!(LAST_CKEY(M)))	//sanity
			to_chat(usr, "This mob has no ckey")
			return

		var/dat = ""
		var/header = "<head><title>Job-Ban Panel: [M.name]</title></head>"
		var/body
		var/jobs = ""

	/***********************************WARNING!************************************
					  The jobban stuff looks mangled and disgusting
							  But it looks beautiful in-game
										-Nodrak
	************************************WARNING!***********************************/
		var/counter = 0
		var/list/all_departments = decls_repository.get_decls_of_subtype(/decl/department)
		for(var/dtype in all_departments)
			var/decl/department/dept = all_departments[dtype]
			var/list/print_jobs = SSjobs.titles_by_department(dtype)
			jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
			jobs += "<tr align='center' bgcolor='[dept.display_color]'><th colspan='[length(print_jobs)]'><a href='?src=\ref[src];jobban_category=[dept.name];jobban_mob_target=\ref[M]'>[capitalize(dept.name)] Positions</a></th></tr><tr align='center'>"
			for(var/jobPos in print_jobs)
				var/datum/job/job = SSjobs.get_by_title(jobPos)
				if(!job) 
					continue
				if(jobban_isbanned(M, job.title))
					jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=[job.title];jobban_mob_target=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
					counter++
				else
					jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=[job.title];jobban_mob_target=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
					counter++
				if(counter >= MAX_JOBBAN_CELLS)
					jobs += "</tr><tr>"
					counter = 0
			jobs += "</tr></table>"

	// Other non-human bans.
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ccffcc'><th colspan='2><a href='?src=\ref[src];jobban_category=miscnonhumanroles;jobban_mob_target=\ref[M]'>Other Positions</a></th></tr><tr align='center'>"
		if(jobban_isbanned(M, "pAI"))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=pAI;jobban_mob_target=\ref[M]'><font color=red>pAI</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=pAI;jobban_mob_target=\ref[M]'>pAI</a></td>"
		if(jobban_isbanned(M, "AntagHUD"))
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=AntagHUD;jobban_mob_target=\ref[M]'><font color=red>AntagHUD</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=AntagHUD;jobban_mob_target=\ref[M]'>AntagHUD</a></td>"
		jobs += "</tr></table>"

	//Antagonist (Orange)
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ffeeaa'><th colspan='10'><a href='?src=\ref[src];jobban_category=Syndicate;jobban_mob_target=\ref[M]'>Antagonist Positions</a></th></tr><tr align='center'>"

		// Antagonists.
		#define ANTAG_COLUMNS 5
		var/list/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
		var/i = 1
		for(var/antag_type in all_antag_types)
			var/decl/special_role/antag = all_antag_types[antag_type]
			if(!antag)
				continue
			if(jobban_isbanned(M, antag.type))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=\ref[antag];jobban_mob_target=\ref[M]'><font color=red>[replacetext("[antag.name]", " ", "&nbsp")]</font></a></td>"
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=\ref[antag];jobban_mob_target=\ref[M]'>[replacetext("[antag.name]", " ", "&nbsp")]</a></td>"
			if(i % ANTAG_COLUMNS == 0 && i < length(all_antag_types))
				jobs += "</tr><tr align='center'>"
			i++
		jobs += "</tr></table>"
		#undef ANTAG_COLUMNS

		var/list/misc_roles = list("Botany Roles", "Graffiti")
		//Other roles  (BLUE, because I have no idea what other color to make this)
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ccccff'><th colspan='[LAZYLEN(misc_roles)]'>Other Roles</th></tr><tr align='center'>"
		for(var/entry in misc_roles)
			if(jobban_isbanned(M, entry))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=[entry];jobban_mob_target=\ref[M]'><font color=red>[entry]</font></a></td>"
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=[entry];jobban_mob_target=\ref[M]'>[entry]</a></td>"
		jobs += "</tr></table>"

	// Channels
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		var/list/channels = decls_repository.get_decls_of_subtype(/decl/communication_channel)
		jobs += "<tr bgcolor='ccccff'><th colspan='[LAZYLEN(channels)]'>Channel Bans</th></tr><tr align='center'>"
		for(var/channel_type in channels)
			var/decl/communication_channel/channel = channels[channel_type]
			if(jobban_isbanned(M, channel.name))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=[channel.name];jobban_mob_target=\ref[M]'><font color=red>[channel.name]</font></a></td>"
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban_category=[channel.name];jobban_mob_target=\ref[M]'>[channel.name]</a></td>"
		jobs += "</tr></table>"

	// Finalize and display.
		body = "<body>[jobs]</body>"
		dat = "<tt>[header][body]</tt>"
		show_browser(usr, dat, "window=jobban_panel_target;size=800x490")
		return

	//JOBBAN'S INNARDS
	else if(href_list["jobban_category"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN,0))
			to_chat(usr, "<span class='warning'>You do not have the appropriate permissions to add job bans!</span>")
			return

		if(check_rights(R_MOD,0) && !check_rights(R_ADMIN,0) && !config.mods_can_job_tempban) // If mod and tempban disabled
			to_chat(usr, "<span class='warning'>Mod jobbanning is disabled!</span>")
			return

		var/mob/M = locate(href_list["jobban_mob_target"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(M != usr)																//we can jobban ourselves
			if(M.client && M.client.holder && (M.client.holder.rights & R_BAN))		//they can ban too. So we can't ban them
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return

		//get jobs for department if specified, otherwise just returnt he one job in a list.
		var/list/job_list = list()
		var/decl/department/ban_dept = SSjobs.get_department_by_name(href_list["jobban_category"])
		if(ban_dept)
			for(var/jobPos in SSjobs.titles_by_department(ban_dept.type))
				var/datum/job/temp = SSjobs.get_by_title(jobPos)
				if(temp)
					job_list |= temp.title
		switch(href_list["jobban_category"])
			if("miscnonhumanroles")
				job_list |= "pAI"
			if("Syndicate")
				var/list/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
				for(var/antagPos in all_antag_types)
					var/decl/special_role/temp = all_antag_types[antagPos]
					job_list |= temp.name
		if(!length(job_list))
			job_list += href_list["jobban_category"]

		//Create a list of unbanned jobs within job_list
		var/list/notbannedlist = list()
		for(var/job in job_list)
			if(!jobban_isbanned(M, job))
				notbannedlist += job

		//Banning comes first
		if(notbannedlist.len) //at least 1 unbanned job exists in job_list so we have stuff to ban.
			switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
				if("Yes")
					if(!check_rights(R_MOD,0) && !check_rights(R_BAN, 0))
						to_chat(usr, "<span class='warning'> You cannot issue temporary job-bans!</span>")
						return
					if(config.ban_legacy_system)
						to_chat(usr, "<span class='warning'>Your server is using the legacy banning system, which does not support temporary job bans. Consider upgrading. Aborting ban.</span>")
						return
					var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
					if(!mins)
						return
					if(check_rights(R_MOD, 0) && !check_rights(R_BAN, 0) && mins > config.mod_job_tempban_max)
						to_chat(usr, "<span class='warning'> Moderators can only job tempban up to [config.mod_job_tempban_max] minutes!</span>")
						return
					var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
					if(!reason)
						return

					var/msg
					var/mins_readable = minutes_to_readable(mins)
					for(var/job in notbannedlist)
						ban_unban_log_save("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins_readable]. reason: [reason]")
						log_admin("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins_readable]")
						SSstatistics.add_field("ban_job_tmp",1)
						AD.DB_ban_record(BANTYPE_JOB_TEMP, M, mins, reason, job)
						SSstatistics.add_field_details("ban_job_tmp","- [job]")
						jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]") //Legacy banning does not support temporary jobbans.
						if(!msg)
							msg = job
						else
							msg += ", [job]"
					notes_add(LAST_CKEY(M), "Banned  from [msg] - [reason]", usr)
					message_admins("[key_name_admin(usr)] banned [key_name_admin(M)] from [msg] for [mins_readable]", 1)
					to_chat(M, "<span class='danger'>You have been jobbanned by [usr.client.ckey] from: [msg].</span>")
					to_chat(M, "<span class='warning'>The reason is: [reason]</span>")
					to_chat(M, "<span class='warning'>This jobban will be lifted in [mins_readable].</span>")
					href_list["jobban_panel_target"] = 1 // lets it fall through and refresh
					return 1
				if("No")
					if(!check_rights(R_BAN))  return
					var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
					if(reason)
						var/msg
						for(var/job in notbannedlist)
							ban_unban_log_save("[key_name(usr)] perma-jobbanned [key_name(M)] from [job]. reason: [reason]")
							log_admin("[key_name(usr)] perma-banned [key_name(M)] from [job]")
							SSstatistics.add_field("ban_job",1)
							AD.DB_ban_record(BANTYPE_JOB_PERMA, M, -1, reason, job)
							SSstatistics.add_field_details("ban_job","- [job]")
							jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]")
							if(!msg)	msg = job
							else		msg += ", [job]"
						notes_add(LAST_CKEY(M), "Banned  from [msg] - [reason]", usr)
						message_admins("[key_name_admin(usr)] banned [key_name_admin(M)] from [msg]", 1)
						to_chat(M, "<span class='danger'>You have been jobbanned by [usr.client.ckey] from: [msg].</span>")
						to_chat(M, "<span class='warning'>The reason is: [reason]</span>")
						to_chat(M, "<span class='warning'>Jobban can be lifted only upon request.</span>")
						href_list["jobban_panel_target"] = 1 // lets it fall through and refresh
						return 1
				if("Cancel")
					return

		//Unbanning job list
		//all jobs in job list are banned already OR we didn't give a reason (implying they shouldn't be banned)
		if(LAZYLEN(SSjobs.titles_to_datums)) //at least 1 banned job exists in job list so we have stuff to unban.
			if(!config.ban_legacy_system)
				to_chat(usr, "Unfortunately, database based unbanning cannot be done through this panel")
				AD.DB_ban_panel(M.ckey)
				return
			var/msg
			for(var/job in SSjobs.titles_to_datums)
				var/reason = jobban_isbanned(M, job)
				if(!reason) continue //skip if it isn't jobbanned anyway
				switch(alert("Job: '[job]' Reason: '[reason]' Un-jobban?","Please Confirm","Yes","No"))
					if("Yes")
						ban_unban_log_save("[key_name(usr)] unjobbanned [key_name(M)] from [job]")
						log_admin("[key_name(usr)] unbanned [key_name(M)] from [job]")
						AD.DB_ban_unban(M.ckey, BANTYPE_JOB_PERMA, job)
						SSstatistics.add_field("ban_job_unban",1)
						SSstatistics.add_field_details("ban_job_unban","- [job]")
						jobban_unban(M, job)
						if(!msg)	msg = job
						else		msg += ", [job]"
					else
						continue
			if(msg)
				message_admins("[key_name_admin(usr)] unbanned [key_name_admin(M)] from [msg]", 1)
				to_chat(M, "<span class='danger'>You have been un-jobbanned by [usr.client.ckey] from [msg].</span>")
				href_list["jobban_panel_target"] = 1 // lets it fall through and refresh
			return 1
		return 0 //we didn't do anything!

	else if(href_list["boot2"])
		var/mob/M = locate(href_list["boot2"])
		if (ismob(M))
			if(!check_if_greater_rights_than(M.client))
				return
			var/reason = sanitize(input("Please enter reason"))
			if(!reason)
				to_chat(M, "<span class='warning'>You have been kicked from the server</span>")
			else
				to_chat(M, "<span class='warning'>You have been kicked from the server: [reason]</span>")
			log_and_message_admins("booted [key_name_admin(M)].")
			//M.client = null
			qdel(M.client)

	else if(href_list["removejobban"])
		if(!check_rights(R_BAN))	return

		var/t = href_list["removejobban"]
		if(t)
			if((alert("Do you want to unjobban [t]?","Unjobban confirmation", "Yes", "No") == "Yes") && t) //No more misclicks! Unless you do it twice.
				log_and_message_admins("[key_name_admin(usr)] removed [t]")
				jobban_remove(t)
				href_list["ban"] = 1 // lets it fall through and refresh
				var/t_split = splittext(t, " - ")
				var/key = t_split[1]
				var/job = t_split[2]
				AD.DB_ban_unban(ckey(key), BANTYPE_JOB_PERMA, job)

	else if(href_list["newban"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN, 0))
			to_chat(usr, "<span class='warning'>You do not have the appropriate permissions to add bans!</span>")
			return

		if(check_rights(R_MOD,0) && !check_rights(R_ADMIN, 0) && !config.mods_can_job_tempban) // If mod and tempban disabled
			to_chat(usr, "<span class='warning'>Mod jobbanning is disabled!</span>")
			return

		var/mob/M = locate(href_list["newban"])
		if(!ismob(M)) return

		if(M.client && M.client.holder)	return	//admins cannot be banned. Even if they could, the ban doesn't affect them anyway

		var/given_key = href_list["last_key"]
		if(!given_key)
			to_chat(usr, SPAN_DANGER("This mob has no known last occupant and cannot be banned."))
			return

		switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
			if("Yes")
				var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
				if(!mins)
					return
				if(check_rights(R_MOD, 0) && !check_rights(R_BAN, 0) && mins > config.mod_tempban_max)
					to_chat(usr, "<span class='warning'>Moderators can only job tempban up to [config.mod_tempban_max] minutes!</span>")
					return
				if(mins >= 525600) mins = 525599
				var/reason = sanitize(input(usr,"Reason?","reason","Griefer") as text|null)
				if(!reason)
					return
				var/mob_key = LAST_CKEY(M)
				if(mob_key != given_key)
					to_chat(usr, SPAN_DANGER("This mob's occupant has changed from [given_key] to [mob_key]. Please try again."))
					AD.show_player_panel(M)
					return
				AddBan(mob_key, M.computer_id, reason, usr.ckey, 1, mins)
				var/mins_readable = minutes_to_readable(mins)
				ban_unban_log_save("[usr.client.ckey] has banned [mob_key]. - Reason: [reason] - This will be removed in [mins_readable].")
				notes_add(mob_key,"[usr.client.ckey] has banned [mob_key]. - Reason: [reason] - This will be removed in [mins_readable].",usr)
				to_chat(M, "<span class='danger'>You have been banned by [usr.client.ckey].\nReason: [reason].</span>")
				to_chat(M, "<span class='warning'>This is a temporary ban, it will be removed in [mins_readable].</span>")
				SSstatistics.add_field("ban_tmp",1)
				AD.DB_ban_record(BANTYPE_TEMP, M, mins, reason)
				SSstatistics.add_field("ban_tmp_mins",mins)
				if(config.banappeals)
					to_chat(M, "<span class='warning'>To try to resolve this matter head to [config.banappeals]</span>")
				else
					to_chat(M, "<span class='warning'>No ban appeals URL has been set.</span>")
				log_and_message_admins("has banned [mob_key].\nReason: [reason]\nThis will be removed in [mins_readable].")

				qdel(M.client)
				//qdel(M)	// See no reason why to delete mob. Important stuff can be lost. And ban can be lifted before round ends.
			if("No")
				if(!check_rights(R_BAN))   return
				var/reason = sanitize(input(usr,"Reason?","reason","Griefer") as text|null)
				if(!reason)
					return
				var/mob_key = LAST_CKEY(M)
				if(mob_key != given_key)
					to_chat(usr, SPAN_DANGER("This mob's occupant has changed from [given_key] to [mob_key]. Please try again."))
					AD.show_player_panel(M)
					return
				switch(alert(usr,"IP ban?",,"Yes","No","Cancel"))
					if("Cancel")	return
					if("Yes")
						AddBan(mob_key, M.computer_id, reason, usr.ckey, 0, 0, M.lastKnownIP)
					if("No")
						AddBan(mob_key, M.computer_id, reason, usr.ckey, 0, 0)
				to_chat(M, "<span class='danger'>You have been banned by [usr.client.ckey].\nReason: [reason].</span>")
				to_chat(M, "<span class='warning'>This is a ban until appeal.</span>")
				if(config.banappeals)
					to_chat(M, "<span class='warning'>To try to resolve this matter head to [config.banappeals]</span>")
				else
					to_chat(M, "<span class='warning'>No ban appeals URL has been set.</span>")
				ban_unban_log_save("[usr.client.ckey] has permabanned [mob_key]. - Reason: [reason] - This is a ban until appeal.")
				notes_add(mob_key,"[usr.client.ckey] has permabanned [mob_key]. - Reason: [reason] - This is a ban until appeal.",usr)
				log_and_message_admins("has banned [mob_key].\nReason: [reason]\nThis is a ban until appeal.")
				SSstatistics.add_field("ban_perma",1)
				AD.DB_ban_record(BANTYPE_PERMA, M, -1, reason)

				qdel(M.client)
				//qdel(M)
			if("Cancel")
				return

	else if(href_list["mute"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["mute"])
		if(!ismob(M))	return
		if(!M.client)	return

		var/mute_type = href_list["mute_type"]
		if(istext(mute_type))	mute_type = text2num(mute_type)
		if(!isnum(mute_type))	return

		cmd_admin_mute(M, mute_type)
	if(href_list["notes"])
		if(href_list["notes"] == "set_filter")
			var/choice = input(usr,"Please specify a text filter to use or cancel to clear.","Player Notes",null) as text|null
			AD.PlayerNotesPage(choice)
		else
			var/ckey = href_list["ckey"]
			if(!ckey)
				var/mob/M = locate(href_list["mob"])
				if(ismob(M))
					ckey = LAST_CKEY(M)
			AD.show_player_info(ckey)
		return
	if(href_list["setstaffwarn"])
		var/mob/M = locate(href_list["setstaffwarn"])
		if(!ismob(M)) return

		if(M.client && M.client.holder) return // admins don't get staffnotify'd about

		switch(alert("Really set staff warn?",,"Yes","No"))
			if("Yes")
				var/last_ckey = LAST_CKEY(M)
				var/reason = sanitize(input(usr,"Staff warn message","Staff Warn","Problem Player") as text|null)
				if (!reason || reason == "")
					return
				notes_add(last_ckey,"\[AUTO\] Staff warn enabled: [reason]",usr)
				reason += "\n-- Set by [usr.client.ckey]([usr.client.holder.rank])"
				AD.DB_staffwarn_record(last_ckey, reason)
				if(M.client)
					M.client.staffwarn = reason
				SSstatistics.add_field("staff_warn",1)
				log_and_message_admins("has enabled staffwarn on [last_ckey].\nMessage: [reason]\n")
				AD.show_player_panel(M)
			if("No")
				return
	if(href_list["removestaffwarn"])
		var/mob/M = locate(href_list["removestaffwarn"])
		if(!ismob(M)) return

		switch(alert("Really remove staff warn?",,"Yes","No"))
			if("Yes")
				var/last_ckey = LAST_CKEY(M)
				if(!AD.DB_staffwarn_remove(last_ckey))
					return
				notes_add(last_ckey,"\[AUTO\] Staff warn disabled",usr)
				if(M.client)
					M.client.staffwarn = null
				log_and_message_admins("has removed the staffwarn on [last_ckey].\n")
				AD.show_player_panel(M)
			if("No")
				return
	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeai"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		log_and_message_admins("AIized [key_name_admin(H)]!")
		H.AIize()

	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makerobot"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		usr.client.cmd_admin_robotize(H)

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["makeanimal"])
		if(istype(M, /mob/new_player))
			to_chat(usr, "This cannot be used on instances of type /mob/new_player")
			return

		usr.client.cmd_admin_animalize(M)
	else if(href_list["togmutate"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["togmutate"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return
		var/block=text2num(href_list["block"])
		usr.client.cmd_admin_toggle_block(H,block)
		AD.show_player_panel(H)
	else if(href_list["simplemake"])

		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/delmob = 0
		switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
			if("Cancel")	return
			if("Yes")		delmob = 1

		log_and_message_admins("has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]")

		switch(href_list["simplemake"])
			if("observer")			M.change_mob_type( /mob/observer/ghost , null, null, delmob )
			if("human")				M.change_mob_type( /mob/living/carbon/human , null, null, delmob, href_list["species"])
			if("monkey")			M.change_mob_type( /mob/living/carbon/human/monkey , null, null, delmob )
			if("robot")				M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat")				M.change_mob_type( /mob/living/simple_animal/cat , null, null, delmob )
			if("runtime")			M.change_mob_type( /mob/living/simple_animal/cat/fluff/runtime , null, null, delmob )
			if("corgi")				M.change_mob_type( /mob/living/simple_animal/corgi , null, null, delmob )
			if("ian")				M.change_mob_type( /mob/living/simple_animal/corgi/Ian , null, null, delmob )
			if("crab")				M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
			if("coffee")			M.change_mob_type( /mob/living/simple_animal/crab/Coffee , null, null, delmob )
			if("parrot")			M.change_mob_type( /mob/living/simple_animal/hostile/retaliate/parrot , null, null, delmob )
			if("polyparrot")		M.change_mob_type( /mob/living/simple_animal/hostile/retaliate/parrot/Poly , null, null, delmob )
			if("constructarmoured")	M.change_mob_type( /mob/living/simple_animal/construct/armoured , null, null, delmob )
			if("constructbuilder")	M.change_mob_type( /mob/living/simple_animal/construct/builder , null, null, delmob )
			if("constructwraith")	M.change_mob_type( /mob/living/simple_animal/construct/wraith , null, null, delmob )
			if("shade")				M.change_mob_type( /mob/living/simple_animal/shade , null, null, delmob )
