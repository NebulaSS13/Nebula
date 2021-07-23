var/global/list/localhost_addresses = list(
	"127.0.0.1" = TRUE,
	"::1" = TRUE
)

	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?

//#define TOPIC_DEBUGGING 1

	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return
	if(!user_acted(src))
		return

	#if defined(TOPIC_DEBUGGING)
	log_debug("[src]'s Topic: [href] destined for [hsrc].")

	if(href_list["nano_err"]) //nano throwing errors
		log_debug("## NanoUI, Subject [src]: " + html_decode(href_list["nano_err"]))//NANO DEBUG HOOK


	#endif

	// asset_cache
	if(href_list["asset_cache_confirm_arrival"])
//		to_chat(src, "ASSET JOB [href_list["asset_cache_confirm_arrival"]] ARRIVED.")
		var/job = text2num(href_list["asset_cache_confirm_arrival"])
		completed_asset_jobs += job
		return

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		to_world_log("Attempted use of scripts within a topic call, by [src]")
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//qdel(usr)
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		var/datum/ticket/ticket = locate(href_list["ticket"])

		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C, null, ticket)
		return

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(usr, "<span class='warning'>You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you</span>")
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>")
			return
		cmd_admin_irc_pm(href_list["irc_msg"])
		return

	if(href_list["close_ticket"])
		var/datum/ticket/ticket = locate(href_list["close_ticket"])

		if(isnull(ticket))
			return

		ticket.close(client_repository.get_lite_client(usr.client))

	//Logs all hrefs
	if(config && config.log_hrefs && global.world_href_log)
		WRITE_FILE(global.world_href_log, "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>")

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)

	if(codex_topic(href, href_list))
		return

	if(href_list["SDQL_select"])
		debug_variables(locate(href_list["SDQL_select"]))
		return

	..()	//redirect to hsrc.Topic()

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(!user_acted(src))
		return 0
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	TopicData = null							//Prevent calls to client.Topic from connect

	switch (connection)
		if ("seeker", "web") // check for invalid connection type. do nothing if valid
		else return null
	#if DM_VERSION >= 512
	var/bad_version = config.minimum_byond_version && byond_version < config.minimum_byond_version
	var/bad_build = config.minimum_byond_build && byond_build < config.minimum_byond_build
	if (bad_build || bad_version)
		to_chat(src, "You are attempting to connect with a out of date version of BYOND. Please update to the latest version at http://www.byond.com/ before trying again.")
		qdel(src)
		return

	if("[byond_version].[byond_build]" in config.forbidden_versions)
		_DB_staffwarn_record(ckey, "Tried to connect with broken and possibly exploitable BYOND build.")
		to_chat(src, "You are attempting to connect with a broken and possibly exploitable BYOND build. Please update to the latest version at http://www.byond.com/ before trying again.")
		qdel(src)
		return

	#endif

	var/local_connection = (config.auto_local_admin && (isnull(address) || global.localhost_addresses[address]))
	if(!local_connection)
		if(!config.guests_allowed && IsGuestKey(key))
			alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
			qdel(src)
			return
		if(config.player_limit != 0)
			if((global.clients.len >= config.player_limit) && !(ckey in admin_datums))
				alert(src,"This server is currently full and not accepting new connections.","Server Full","OK")
				log_admin("[ckey] tried to join and was turned away due to the server being full (player_limit=[config.player_limit])")
				qdel(src)
				return

	// Change the way they should download resources.
	if(config.resource_urls && config.resource_urls.len)
		src.preload_rsc = pick(config.resource_urls)
	else src.preload_rsc = 1 // If config.resource_urls is not set, preload like normal.

	if(byond_version < DM_VERSION)
		to_chat(src, "<span class='warning'>You are running an older version of BYOND than the server and may experience issues.</span>")
		to_chat(src, "<span class='warning'>It is recommended that you update to at least [DM_VERSION] at http://www.byond.com/download/.</span>")
	to_chat(src, "<span class='warning'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</span>")
	global.clients += src
	global.ckey_directory[ckey] = src

	// Automatic admin rights for people connecting locally.
	// Concept stolen from /tg/ with deepest gratitude.
	if(local_connection && !admin_datums[ckey])
		new /datum/admins("Local Host", R_EVERYTHING, ckey)

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		global.admins += src
		holder.owner = src
		handle_staff_login()

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = SScharacter_setup.preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)

	// these are gonna be used for banning
	prefs.last_ip = address
	prefs.last_id = computer_id

	if(!isnull(config.lock_client_view_x) && !isnull(config.lock_client_view_y))
		view = "[config.lock_client_view_x]x[config.lock_client_view_y]"

	. = ..()	//calls mob.Login()

	global.using_map.map_info(src)

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>[custom_event_msg]</span>")
		to_chat(src, "<br>")

	if(holder)
		add_admin_verbs()
		admin_memo_show()

	// Forcibly enable hardware-accelerated graphics, as we need them for the lighting overlays.
	// (but turn them off first, since sometimes BYOND doesn't turn them on properly otherwise)
	spawn(5) // And wait a half-second, since it sounds like you can do this too fast.
		if(src)
			winset(src, null, "command=\".configure graphics-hwmode off\"")
			sleep(2) // wait a bit more, possibly fixes hardware mode not re-activating right
			winset(src, null, "command=\".configure graphics-hwmode on\"")

	log_client_to_db()

	send_resources()

	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>")

	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	if(holder)
		src.control_freak = 0 //Devs need 0 for profiler access

	if(prefs && !istype(mob, world.mob))
		prefs.apply_post_login_preferences()
	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	ticket_panels -= src
	if(src && watched_variables_window)
		STOP_PROCESSING(SSprocessing, watched_variables_window)
	if(holder)
		handle_staff_logout()
		holder.owner = null
		global.admins -= src
	global.ckey_directory -= ckey
	global.clients -= src
	return ..()

/client/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

// here because it's similar to below

// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database

/proc/get_player_age(key)
	establish_db_connection()
	if(!dbcon.IsConnected())
		return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/DBQuery/query = dbcon.NewQuery("SELECT DATEDIFF(NOW(), `firstseen`) AS `age` FROM `erro_player` WHERE `ckey` = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		return text2num(query.item[1])
	else
		return -1


/client/proc/log_client_to_db()

	if ( IsGuestKey(src.key) )
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/DBQuery/query = dbcon.NewQuery("SELECT `id`, DATEDIFF(NOW(), `firstseen`) AS `age` FROM `erro_player` WHERE `ckey` = '[sql_ckey]'")
	query.Execute()
	var/sql_id = 0
	player_age = 0	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.
	while(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
		break

	var/DBQuery/query_ip = dbcon.NewQuery("SELECT `ckey` FROM `erro_player` WHERE `ip` = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	while(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
		break

	var/DBQuery/query_cid = dbcon.NewQuery("SELECT `ckey` FROM `erro_player` WHERE `computerid` = '[computer_id]'")
	query_cid.Execute()
	related_accounts_cid = ""
	while(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
		break

	var/DBQuery/query_staffwarn = dbcon.NewQuery("SELECT `staffwarn` FROM `erro_player` WHERE `ckey` = '[sql_ckey]' AND !ISNULL(`staffwarn`)")
	query_staffwarn.Execute()
	if(query_staffwarn.NextRow())
		src.staffwarn = query_staffwarn.item[1]

	//Just the standard check to see if it's actually a number
	if(sql_id)
		if(istext(sql_id))
			sql_id = text2num(sql_id)
		if(!isnum(sql_id))
			return

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank
		for(var/client/C in global.clients)
			if(C.staffwarn)
				C.mob.send_staffwarn(src, "is connected", 0)

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)

	if ((player_age <= 0) && !(ckey in global.panic_bunker_bypass)) //first connection
		if (config.panic_bunker && !holder && !deadmin_holder)
			log_adminwarn("Failed Login: [key] - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: [key] - New account attempting to connect during panic bunker</span>")
			to_chat(src, config.panic_bunker_message)
			qdel(src)
			return 0

	if(sql_id)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/DBQuery/query_update = dbcon.NewQuery("UPDATE `erro_player` SET `lastseen` = NOW(), `ip` = '[sql_ip]', `computerid` = '[sql_computerid]', `lastadminrank` = '[sql_admin_rank]' WHERE `id` = [sql_id]")
		query_update.Execute()
	else
		//New player!! Need to insert all the stuff
		var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO `erro_player` (`id`, `ckey`, `firstseen`, `lastseen`, `ip`, `computerid`, `lastadminrank`) VALUES (NULL, '[sql_ckey]', NOW(), NOW(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute()

	//Logging player access
	var/serverip = "[world.internet_address]:[world.port]"
	var/DBQuery/query_accesslog = dbcon.NewQuery("INSERT INTO `erro_connection_log` (`id`, `datetime`, `serverip`, `ckey`, `ip`, `computerid`) VALUES (NULL, NOW(), '[serverip]', '[sql_ckey]', '[sql_ip]', '[sql_computerid]');")
	query_accesslog.Execute()


#undef UPLOAD_LIMIT

/client/proc/handle_staff_login()
	if(admin_datums[ckey] && SSticker)
		message_staff("\[[holder.rank]\] [key_name(src)] logged in.")

/client/proc/handle_staff_logout()
	if(admin_datums[ckey] && GAME_STATE == RUNLEVEL_GAME) //Only report this stuff if we are currently playing.
		message_staff("\[[holder.rank]\] [key_name(src)] logged out.")
		if(!global.admins.len) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
			send2adminirc("[key_name(src)] logged out - no more staff online.")
			if(config.delist_when_no_admins && global.visibility_pref)
				world.update_hub_visibility()
				send2adminirc("Toggled hub visibility. The server is now invisible ([global.visibility_pref]).")

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "[round(seconds / 60)] minute\s, [seconds % 60] second\s"

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	if(!usr)
		return
	// Add always-visible stat panel calls here, to define a consistent display order.
	statpanel("Status")

	. = ..()

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/spacemag.css',
		'html/images/loading.gif',
		'html/images/talisman.png'
		)

	var/decl/asset_cache/asset_cache = GET_DECL(/decl/asset_cache)
	spawn (10) //removing this spawn causes all clients to not get verbs.
		//Precache the client with all other assets slowly, so as to not block other browse() calls
		getFilesSlow(src, asset_cache.cache, register_asset = FALSE)

/mob/proc/MayRespawn()
	return 0

/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0

/client/verb/character_setup()
	set name = "Character Setup"
	set category = "OOC"
	if(prefs)
		prefs.open_setup_window(usr)

/client/proc/apply_fps(var/client_fps)
	if(world.byond_version >= 511 && byond_version >= 511 && client_fps >= CLIENT_MIN_FPS && client_fps <= CLIENT_MAX_FPS)
		vars["fps"] = prefs.clientfps

/client/MouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	var/mob/living/M = mob
	if(istype(M))
		M.OnMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params)

/client/MouseUp(object, location, control, params)
	. = ..()
	var/mob/living/M = mob
	if(istype(M))
		M.OnMouseUp(object, location, control, params)

/client/MouseDown(object, location, control, params)
	. = ..()
	var/mob/living/M = mob
	if(istype(M) && !M.in_throw_mode)
		M.OnMouseDown(object, location, control, params)

/client/verb/SetWindowIconSize(var/val as num|text)
	set hidden = 1
	winset(src, "mapwindow.map", "icon-size=[val]")
	if(prefs && val != prefs.icon_size)
		prefs.icon_size = val
		SScharacter_setup.queue_preferences_save(prefs)
	OnResize()

/client
	var/last_view_x_dim = 7
	var/last_view_y_dim = 7

/client/verb/force_onresize_view_update()
	set name = "Force Client View Update"
	set src = usr
	set category = "Debug"
	OnResize()

/client/verb/show_winset_debug_values()
	set name = "Show Client View Debug Values"
	set src = usr
	set category = "Debug"

	var/divisor = text2num(winget(src, "mapwindow.map", "icon-size")) || world.icon_size
	var/winsize_string = winget(src, "mapwindow.map", "size")

	to_chat(usr, "Current client view: [view]")
	to_chat(usr, "Icon size: [divisor]")
	to_chat(usr, "xDim: [round(text2num(winsize_string) / divisor)]")
	to_chat(usr, "yDim: [round(text2num(copytext(winsize_string,findtext(winsize_string,"x")+1,0)) / divisor)]")

/client/verb/OnResize()
	set hidden = 1

	var/divisor = text2num(winget(src, "mapwindow.map", "icon-size")) || world.icon_size
	if(!isnull(config.lock_client_view_x) && !isnull(config.lock_client_view_y))
		last_view_x_dim = config.lock_client_view_x
		last_view_y_dim = config.lock_client_view_y
	else
		var/winsize_string = winget(src, "mapwindow.map", "size")
		last_view_x_dim = config.lock_client_view_x || Clamp(CEILING(text2num(winsize_string) / divisor), 15, config.max_client_view_x || 41)
		last_view_y_dim = config.lock_client_view_y || Clamp(CEILING(text2num(copytext(winsize_string,findtext(winsize_string,"x")+1,0)) / divisor), 15, config.max_client_view_y || 41)
		if(last_view_x_dim % 2 == 0) last_view_x_dim++
		if(last_view_y_dim % 2 == 0) last_view_y_dim++
	for(var/check_icon_size in global.valid_icon_sizes)
		winset(src, "menu.icon[check_icon_size]", "is-checked=false")
	winset(src, "menu.icon[divisor]", "is-checked=true")

	view = "[last_view_x_dim]x[last_view_y_dim]"

	// Reset eye/perspective
	var/last_perspective = perspective
	perspective = MOB_PERSPECTIVE
	if(perspective != last_perspective)
		perspective = last_perspective
	var/last_eye = eye
	eye = mob
	if(eye != last_eye)
		eye = last_eye

	// Recenter skybox and lighting.
	set_skybox_offsets(last_view_x_dim, last_view_y_dim)
	if(mob)
		mob.reload_fullscreen()

/client/proc/toggle_fullscreen(new_value)
	if((new_value == PREF_BASIC) || (new_value == PREF_FULL))
		winset(src, "mainwindow", "is-maximized=false;can-resize=false;titlebar=false")
		if(new_value == PREF_FULL)
			winset(src, "mainwindow", "menu=null;statusbar=false")
		winset(src, "mainwindow.split", "pos=0x0")
	else
		winset(src, "mainwindow", "is-maximized=false;can-resize=true;titlebar=true")
		winset(src, "mainwindow", "menu=menu;statusbar=true")
		winset(src, "mainwindow.split", "pos=3x0")
	winset(src, "mainwindow", "is-maximized=true")

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"
	set waitfor = FALSE

	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/list/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))

	// Client closed the window? Some other error? This is unexpected behaviour, let's
	// CRASH with some info.
	if(!sizes["mapwindow.size"])
		CRASH("sizes does not contain mapwindow.size key. This means a winget failed to return what we wanted. --- sizes var: [sizes] --- sizes length: [length(sizes)]")

	var/list/map_size = splittext(sizes["mapwindow.size"], "x")

	// Looks like we expect mapwindow.size to be "ixj" where i and j are numbers.
	// If we don't get our expected 2 outputs, let's give some useful error info.
	if(length(map_size) != 2)
		CRASH("map_size of incorrect length --- map_size var: [map_size] --- map_size length: [length(map_size)]")

	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Avoid auto-resizing the statpanel and chat into nothing.
	desired_width = min(desired_width, split_width - 300)

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.split", "splitter=[pct]")
