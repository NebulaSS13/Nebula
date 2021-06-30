#define PROFILER_FILENAME "profiler.json"
#ifdef SENDMAPS_PROFILE
#define SENDMAPS_FILENAME "sendmaps.json"
var/global/world_init_maptick_profiler = world.Profile(PROFILE_RESTART, type = "sendmaps")
#endif

SUBSYSTEM_DEF(profiler)
	name = "Profiler"
	init_order = SS_INIT_PROFILER
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	wait = 5 MINUTES
	/// Time it took to fetch profile data (ms)
	var/fetch_cost = 0
	/// Time it took to write the file (ms)
	var/write_cost = 0

/datum/controller/subsystem/profiler/stat_entry(msg)
	msg += "F:[round(fetch_cost,1)]ms"
	msg += "|W:[round(write_cost,1)]ms"
	return msg

/datum/controller/subsystem/profiler/Initialize()
	if(config.enable_automatic_profiler)
		StartProfiling()
	else
		StopProfiling() //Stop the early start profiler

#ifdef SENDMAPS_PROFILE
	global.admin_verbs_debug |= /client/proc/display_sendmaps
#endif

	return ..()

/datum/controller/subsystem/profiler/fire()
	if(config.enable_automatic_profiler)
		DumpFile()

/datum/controller/subsystem/profiler/Shutdown()
	if(config.enable_automatic_profiler)
		DumpFile()
		world.Profile(PROFILE_CLEAR, type = "sendmaps")
	return ..()

// These procs may seem useless, but they exist like this so we can proc call them on and off
// You cant proc-call onto /world
/datum/controller/subsystem/profiler/proc/StartProfiling()
	world.Profile(PROFILE_START)
#ifdef SENDMAPS_PROFILE
	world.Profile(PROFILE_START, type = "sendmaps")
#endif

/datum/controller/subsystem/profiler/proc/StopProfiling()
	world.Profile(PROFILE_STOP)
#ifdef SENDMAPS_PROFILE
	world.Profile(PROFILE_STOP, type = "sendmaps")
#endif

// Write the file while also cost tracking
/datum/controller/subsystem/profiler/proc/DumpFile()
	var/timer = TICK_USAGE_REAL
	var/current_profile_data = world.Profile(PROFILE_REFRESH, format = "json")
#ifdef SENDMAPS_PROFILE
	var/current_sendmaps_data = world.Profile(PROFILE_REFRESH, type = "sendmaps", format = "json")
#endif
	fetch_cost = MC_AVERAGE(fetch_cost, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
	CHECK_TICK

	if(!length(current_profile_data)) //Would be nice to have explicit proc to check this
		PRINT_STACK_TRACE("Warning, profiling stopped manually before dump.")
	var/profiler_file = file("[global.log_directory]/[PROFILER_FILENAME]")
	if(fexists(profiler_file))
		fdel(profiler_file)

#ifdef SENDMAPS_PROFILE	
	if(!length(current_sendmaps_data)) //Would be nice to have explicit proc to check this
		PRINT_STACK_TRACE("Warning, sendmaps profiling stopped manually before dump.")
	var/sendmaps_file = file("[global.log_directory]/[SENDMAPS_FILENAME]")
	if(fexists(sendmaps_file))
		fdel(sendmaps_file)
#endif

	timer = TICK_USAGE_REAL
	WRITE_FILE(profiler_file, current_profile_data)
#ifdef SENDMAPS_PROFILE
	WRITE_FILE(sendmaps_file, current_sendmaps_data)
#endif
	write_cost = MC_AVERAGE(write_cost, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))

#undef PROFILER_FILENAME
#ifdef SENDMAPS_PROFILE
#undef SENDMAPS_FILENAME
#endif

#ifdef SENDMAPS_PROFILE
/client/proc/display_sendmaps()
	set name = "Send Maps Profile"
	set category = "Debug"

	open_link(src, "?debug=profile&type=sendmaps&window=test")
#endif
