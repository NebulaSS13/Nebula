GLOBAL_PROTECTED_UNTYPED(game_id, null)

/hook/global_init/proc/generate_game_id()
	if(!isnull(global.game_id))
		return

	global.game_id = ""

	var/list/characters = global.alphabet + global.alphabet_capital + global.numbers
	var/server_time = world.timeofday

	for(var/a = 1 to 4)
		global.game_id = "[characters[(server_time % characters.len) + 1]][global.game_id]"
		server_time = round(server_time / characters.len)

	global.game_id = "-[global.game_id]"
	server_time = round(world.realtime / (10 * 60 * 60 * 24))

	for(var/a = 1 to 3)
		global.game_id = "[characters[(server_time % characters.len) + 1]][global.game_id]"
		server_time = round(server_time / characters.len)

	return TRUE

// Find mobs matching a given string
//
// search_string: the string to search for, in params format; for example, "some_key;mob_name"
// restrict_type: A mob type to restrict the search to, or null to not restrict
//
// Partial matches will be found, but exact matches will be preferred by the search
//
// Returns: A possibly-empty list of the strongest matches

/proc/text_find_mobs(search_string, restrict_type = null)
	var/list/search = params2list(search_string)
	var/list/ckeysearch = list()
	for(var/text in search)
		ckeysearch += ckey(text)

	var/list/match = list()

	for(var/mob/M in SSmobs.mob_list)
		if(restrict_type && !istype(M, restrict_type))
			continue
		var/strings = list(M.name, M.ckey)
		if(M.mind)
			if(M.mind.assigned_role)
				strings += M.mind.assigned_role
			var/special_role_name = M.mind.get_special_role_name()
			if(special_role_name)
				strings += special_role_name
		if(ishuman(M))
			var/mob/living/human/H = M
			if(H.species)
				strings += H.species.name
		for(var/text in strings)
			if(ckey(text) in ckeysearch)
				match[M] += 10 // an exact match is far better than a partial one
			else
				for(var/searchstr in search)
					if(findtext(text, searchstr))
						match[M] += 1

	var/maxstrength = 0
	for(var/mob/M in match)
		maxstrength = max(match[M], maxstrength)
	for(var/mob/M in match)
		if(match[M] < maxstrength)
			match -= M

	return match

/world/New()
	//set window title

	name = "[get_config_value(/decl/config/text/server_name) || "Nebula Station 13"] - [global.using_map.full_name]"

	//logs
	SetupLogs()

	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < REQUIRED_DM_VERSION)
		to_world_log("Your server's BYOND version does not meet the minimum DM version for this server. Please update BYOND.")

	callHook("startup")
	//Emergency Fix
	load_mods()
	//end-emergency fix

	. = ..()

#ifdef UNIT_TEST
	log_unit_test("Unit Tests Enabled. This will destroy the world when testing is complete.")
#endif
	Master.Initialize(10, FALSE)

var/global/list/world_topic_throttle = list()
var/global/world_topic_last = world.timeofday

/proc/set_throttle(var/addr, var/time, var/reason)
	var/list/throttle = global.world_topic_throttle[addr]
	if (!global.world_topic_throttle[addr])
		global.world_topic_throttle[addr] = throttle = list(0, null)
	else if ((!get_config_value(/decl/config/toggle/no_throttle_localhost) || !global.localhost_addresses[addr]) && throttle[1] && throttle[1] > world.timeofday + 15 SECONDS)
		return throttle[2] ? "Throttled ([throttle[2]])" : "Throttled"

	throttle[1] = max(throttle[1], world.timeofday) + time
	throttle[2] = reason

/world/Topic(T, addr, master, key)
	direct_output(diary, "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]")

	if (global.world_topic_last > world.timeofday)
		global.world_topic_throttle = list() //probably passed midnight
	global.world_topic_last = world.timeofday

	set_throttle(addr, 3 SECONDS, null)

	var/list/params = params2list(T)
	if(!length(params))
		return
	var/command_key = params[1]
	if(!command_key || !global.topic_commands[command_key])
		return "Unrecognised Command"

	var/decl/topic_command/TC = global.topic_commands[command_key]
	return TC.try_use(T, addr, master, key)

/world/Reboot(var/reason)

	if(get_config_value(/decl/config/toggle/wait_for_sigusr1_reboot) && reason != 3)
		text2file("foo", "reboot_called")
		to_world("<span class=danger>World reboot waiting for external scripts. Please be patient.</span>")
		global.Master.restart_timeout = 5 MINUTES
		return

	if(global.using_map.reboot_sound)
		sound_to(world, sound(pick(global.using_map.reboot_sound)))// random end sounds!! - LastyBatsy

	// Master.Shutdown() // In almost all normal cases, world/Reboot() calls world/Del() which calls Shutdown() on the master controller. Having it here means it runs multiple times.

	var/serverurl = get_config_value(/decl/config/text/server)
	if(serverurl)	//if you set a server location in configuration, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
		for(var/client/C in global.clients)
			to_chat(C, link("byond://[serverurl]"))

	game_log("World rebooted at [time_stamp()]")

	callHook("reboot")

	..(reason)

/world/Del()
	Master.Shutdown()
	callHook("shutdown")
	return ..()

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	if(!fexists("data/mode.txt"))
		return

	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			SSticker.master_mode = Lines[1]
			log_misc("Saved mode is '[SSticker.master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	direct_output(F, the_mode)

/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = safe_file2text("config/motd.txt", FALSE)

/hook/startup/proc/loadMods()
	world.load_mods()
	return 1

/world/proc/load_mods()
	if(get_config_value(/decl/config/toggle/on/admin_legacy_system))
		var/text = safe_file2text("config/moderators.txt", FALSE)
		if (!text)
			error("Failed to load config/mods.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(global.ckey_directory[ckey])

/world/proc/update_status()
	var/s = "<b>[station_name()]</b>"

	var/discordurl = get_config_value(/decl/config/text/discordurl)
	if(discordurl)
		s += " (<a href=\"[discordurl]\">Discord</a>)"

	var/config_server_name = get_config_value(/decl/config/text/server_name)
	if(config_server_name)
		s = "<b>[config_server_name]</b> &#8212; [s]"

	var/list/features = list()

	if(SSticker.master_mode)
		features += SSticker.master_mode
	else
		features += "<b>STARTING</b>"

	if (!get_config_value(/decl/config/toggle/on/enter_allowed))
		features += "closed"

	features += get_config_value(/decl/config/toggle/on/abandon_allowed) ? "respawn" : "no respawn"

	if (get_config_value(/decl/config/toggle/vote_mode))
		features += "vote"

	if (get_config_value(/decl/config/toggle/on/allow_ai))
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in global.player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"


	var/hosted_by = get_config_value(/decl/config/text/hosted_by)
	if (hosted_by)
		features += "hosted by <b>[hosted_by]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

/world/proc/SetupLogs()
	global.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM/DD")]/round-"
	if(game_id)
		global.log_directory += "[game_id]"
	else
		global.log_directory += "[replacetext(time_stamp(), ":", ".")]"

	global.world_qdel_log = file("[global.log_directory]/qdel.log")
	to_file(global.world_qdel_log, "\n\nStarting up round ID [game_id]. [time_stamp()]\n---------------------")

	global.world_href_log = file("[global.log_directory]/href.log") // Used for config-optional total href logging
	diary = file("[global.log_directory]/main.log") // This is the primary log, containing attack, admin, and game logs.
	to_file(diary, "[log_end]\n[log_end]\nStarting up. (ID: [game_id]) [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]")

	if(get_config_value(/decl/config/toggle/log_runtime))
		var/runtime_log = file("[global.log_directory]/runtime.log")
		to_file(runtime_log, "Game [game_id] starting up at [time2text(world.timeofday, "hh:mm.ss")]")
		log = runtime_log // runtimes and some other output is logged directly to world.log, which is redirected here.

#define FAILED_DB_CONNECTION_CUTOFF 5
var/global/failed_db_connections = 0
/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		to_world_log("Your server failed to establish a connection with the SQL database.")
	else
		to_world_log("SQL database connection established.")
	return 1

/proc/setup_database_connection()

	if(global.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return FALSE

	if(!dbcon)
		dbcon = new()

	var/user =    sqllogin
	var/pass =    sqlpass
	var/db =      sqldb
	var/address = sqladdress
	var/port =    sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if(.)
		// Setting encoding and comparison (4-byte UTF-8) for the DB server ~bear1ake
		var/DBQuery/unicode_query = dbcon.NewQuery("SET NAMES utf8mb4 COLLATE utf8mb4_general_ci")
		if(!unicode_query.Execute())
			global.failed_db_connections++
			to_world_log(unicode_query.ErrorMsg())
			return
		global.failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		global.failed_db_connections++		//If it failed, increase the failed connections counter.
		to_world_log(dbcon.ErrorMsg())

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(global.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1
