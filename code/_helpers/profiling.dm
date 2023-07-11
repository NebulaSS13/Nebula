#define STAT_ENTRY_TIME 1
#define STAT_ENTRY_COUNT 2
#define STAT_ENTRY_LENGTH 2


#define STAT_START_STOPWATCH var/STAT_STOP_WATCH = TICK_USAGE
#define STAT_STOP_STOPWATCH var/STAT_TIME = TICK_USAGE_TO_MS(STAT_STOP_WATCH)
#define STAT_LOG_ENTRY(entrylist, entryname) \
	var/list/STAT_ENTRY = entrylist[entryname] || (entrylist[entryname] = new /list(STAT_ENTRY_LENGTH));\
	STAT_ENTRY[STAT_ENTRY_TIME] += STAT_TIME;\
	STAT_ENTRY[STAT_ENTRY_COUNT] += 1;

// Cost tracking macros, to be used in one proc. If you're using this raw you'll want to use global lists
// If you don't you'll need another way of reading it
#define INIT_COST(costs, counting) \
	var/list/_costs = costs; \
	var/list/_counting = counting; \
	var/_usage = TICK_USAGE;

// STATIC cost tracking macro. Uses static lists instead of the normal global ones
// Good for debug stuff, and for running before globals init
#define INIT_COST_STATIC(...) \
	var/static/list/hidden_static_list_for_fun1 = list(); \
	var/static/list/hidden_static_list_for_fun2 = list(); \
	INIT_COST(hidden_static_list_for_fun1, hidden_static_list_for_fun2)

#define SET_COST(category) \
	do { \
		var/_cost = TICK_USAGE; \
		_costs[category] += TICK_DELTA_TO_MS(_cost - _usage);\
		_counting[category] += 1; \
	} while(FALSE); \
	_usage = TICK_USAGE;

#define SET_COST_LINE(...) SET_COST("[__LINE__]")

/// A quick helper for running the code as a statement and profiling its cost.
/// For example, `SET_COST_STMT(var/x = do_work())`
#define SET_COST_STMT(code...) ##code; SET_COST("[__LINE__] - [#code]")

#define EXPORT_STATS_TO_JSON_LATER(filename, costs, counts) EXPORT_STATS_TO_FILE_LATER(filename, costs, counts, stat_tracking_export_to_json_later)
#define EXPORT_STATS_TO_CSV_LATER(filename, costs, counts) EXPORT_STATS_TO_FILE_LATER(filename, costs, counts, stat_tracking_export_to_csv_later)

#define EXPORT_STATS_TO_FILE_LATER(filename, costs, counts, proc) \
	do { \
		var/static/last_export = 0; \
		if (world.time - last_export > 1.1 SECONDS) { \
			last_export = world.time; \
			/* spawn() is used here because this is often used to track init times, where timers act oddly. */ \
			/* I was making timers and even after init times were complete, the timers didn't run :shrug: */ \
			spawn (1 SECONDS) { \
				##proc(filename, costs, counts); \
			} \
		} \
	} while (FALSE); \
	_usage = TICK_USAGE;

/proc/cmp_generic_stat_item_time(list/A, list/B)
	. = B[STAT_ENTRY_TIME] - A[STAT_ENTRY_TIME]
	if (!.)
		. = B[STAT_ENTRY_COUNT] - A[STAT_ENTRY_COUNT]

// For use with the stopwatch defines
/proc/render_stats(list/stats, user, sort = /proc/cmp_generic_stat_item_time)
	sortTim(stats, sort, TRUE)

	var/list/lines = list()

	for (var/entry in stats)
		var/list/data = stats[entry]
		lines += "[entry] => [num2text(data[STAT_ENTRY_TIME], 10)]ms ([data[STAT_ENTRY_COUNT]]) (avg:[num2text(data[STAT_ENTRY_TIME]/(data[STAT_ENTRY_COUNT] || 1), 99)])"

	if (user)
		direct_output(user, browse("<ol><li>[lines.Join("</li><li>")]</li></ol>", "window=[url_encode("stats:[ref(stats)]")]"))

	. = lines.Join("\n")

// For use with the set_cost defines
/proc/stat_tracking_export_to_json_later(filename, costs, counts)
	var/list/output = list()

	for (var/key in costs)
		output[key] = list(
			"cost" = costs[key],
			"count" = counts[key],
		)

	to_file(file("[global.log_directory]/[filename]"), json_encode(output))

/proc/stat_tracking_export_to_csv_later(filename, costs, counts)
	var/list/output = list()

	output += "key, cost, count"
	for (var/key in costs)
		output += "[replacetext(key, ",", "")], [costs[key]], [counts[key]]"

	to_file(file("[global.log_directory]/[filename]"), output.Join("\n"))

// Only enable this if you have a local copy of the byond-tracy DLL.
// DO NOT commit the DLL to the repo.
#ifdef TRACY_PROFILE
/proc/prof_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS) lib = "prof.dll"
		if(UNIX) lib = "libprof.so"
		else CRASH("unsupported platform")

	var/init = call(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")

/world/New()
	prof_init()
	. = ..()
#endif
