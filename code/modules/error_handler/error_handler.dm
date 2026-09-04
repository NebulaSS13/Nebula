var/global/total_runtimes = 0
var/global/total_runtimes_skipped = 0
var/global/regex/actual_error_file_line

#ifdef DEBUG
/world/Error(exception/E)
	if(!istype(E)) //Something threw an unusual exception
		log_world("\[[time_stamp()]] Uncaught exception: [E]")
		return ..()

	//this is snowflake because of a byond bug (ID:2306577), do not attempt to call non-builtin procs in this block OR BEFORE IT
	if(copytext(E.name, 1, 32) == "Maximum recursion level reached")//32 == length() of that string + 1
		var/list/proc_path_to_count = list()
		var/crashed = FALSE
		try
			var/callee/stack_entry = caller
			while(!isnull(stack_entry))
				proc_path_to_count[stack_entry.proc] += 1
				stack_entry = stack_entry.caller
		catch
			//union job. avoids crashing the stack again
			//I just do not trust this construct to work reliably
			crashed = TRUE

		var/list/split = splittext(E.desc, "\n")
		for (var/i in 1 to split.len)
			if (split[i] != "" || copytext(split[1], 1, 2) != "  ")
				split[i] = "  [split[i]]"
		split += "--Stack Info [crashed ? "(Crashed, may be missing info)" : ""]:"
		for(var/path in proc_path_to_count)
			split += "  [path] = [proc_path_to_count[path]]"
		E.desc = jointext(split, "\n")
		// expanding the first line of log_world to avoid hitting the stack limit again
		to_file(world.log, "\[[time2text(station_time_in_ticks, "hh:mm:ss")]] Runtime Error: [E.name]\n[E.desc]")
		//log to world while intentionally triggering the byond bug. this does not DO anything, it just errors
		//(seemingly because log_info_line is deep enough to hit the raised limit 516.1667 introduced)
		log_world("runtime error: [E.name]\n[E.desc]\n[log_info_line(usr)]\n[log_info_line(src)]")
		//if we got to here without silently ending, the byond bug has been fixed.
		log_world("The \"bug\" with recursion runtimes has been fixed. Please remove the snowflake check from world/Error in [__FILE__]:[__LINE__]")
		return //this will never happen.

	if (!global.actual_error_file_line)
		global.actual_error_file_line = regex("^%% (.*?),(.*?) %% ")

	var/static/list/error_last_seen = list()
	var/static/list/error_cooldown = list() /* Error_cooldown items will either be positive(cooldown time) or negative(silenced error)
												If negative, starts at -1, and goes down by 1 each time that error gets skipped*/

	if(!error_last_seen) // A runtime is occurring too early in start-up initialization
		return ..()

	global.total_runtimes++

	var/efile = E.file
	var/eline = E.line

	var/regex/actual_error_file_line = global.actual_error_file_line
	if(actual_error_file_line.Find(E.name))
		efile = actual_error_file_line.group[1]
		eline = actual_error_file_line.group[2]
		E.name = actual_error_file_line.Replace(E.name, "")

	var/erroruid = "[efile],[eline]"
	var/last_seen = error_last_seen[erroruid]
	var/cooldown = error_cooldown[erroruid] || 0

	if(last_seen == null)
		error_last_seen[erroruid] = world.time
		last_seen = world.time

	if(cooldown < 0)
		error_cooldown[erroruid]-- //Used to keep track of skip count for this error
		global.total_runtimes_skipped++
		return //Error is currently silenced, skip handling it
	//Handle cooldowns and silencing spammy errors
	var/silencing = FALSE

	var/configured_error_cooldown     = get_config_value(/decl/config/num/debug_error_cooldown)
	var/configured_error_limit        = get_config_value(/decl/config/num/debug_error_limit)
	var/configured_error_silence_time = get_config_value(/decl/config/num/debug_error_silence_time)

	//Each occurence of an unique error adds to its cooldown time...
	cooldown = max(0, cooldown - (world.time - last_seen)) + configured_error_cooldown
	// ... which is used to silence an error if it occurs too often, too fast
	if(cooldown > configured_error_cooldown * configured_error_limit)
		cooldown = -1
		silencing = TRUE
		spawn(0)
			usr = null
			sleep(configured_error_silence_time)
			var/skipcount = abs(error_cooldown[erroruid]) - 1
			error_cooldown[erroruid] = 0
			if(skipcount > 0)
				to_world_log("\[[time_stamp()]] Skipped [skipcount] runtimes in [erroruid].")
				if(istype(global.error_cache))
					global.error_cache.log_error(E, skip_count = skipcount)

	error_last_seen[erroruid] = world.time
	error_cooldown[erroruid] = cooldown

	var/list/usrinfo = null
	var/locinfo
	if(istype(usr))
		usrinfo = list("  usr: [log_info_line(usr)]")
		locinfo = log_info_line(usr.loc)
		if(locinfo)
			usrinfo += "  usr.loc: [locinfo]"
	// The proceeding mess will almost definitely break if error messages are ever changed
	var/list/splitlines = splittext(E.desc, "\n")
	var/list/desclines = list()
	if(LAZYLEN(splitlines) > ERROR_USEFUL_LEN) // If there aren't at least three lines, there's no info
		for(var/line in splitlines)
			if(LAZYLEN(line) < 3 || findtext(line, "source file:") || findtext(line, "usr.loc:"))
				continue
			if(findtext(line, "usr:"))
				if(usrinfo)
					desclines.Add(usrinfo)
					usrinfo = null
				continue // Our usr info is better, replace it

			if(copytext(line, 1, 3) != "  ")
				desclines += ("  " + line) // Pad any unpadded lines, so they look pretty
			else
				desclines += line
	if(usrinfo) //If this info isn't null, it hasn't been added yet
		desclines.Add(usrinfo)
	if(silencing)
		desclines += "  (This error will now be silenced for [configured_error_silence_time / 600] minutes)"
	if(istype(global.error_cache)) // istype() rather than nullcheck to avoid new ordering weirdness
		global.error_cache.log_error(E, desclines)

	error_write_log("\[[time_stamp()]] Runtime in [erroruid]: [E]")
	for(var/line in desclines)
		error_write_log(line)

/proc/error_write_log(msg)
	to_world_log(msg)
#endif