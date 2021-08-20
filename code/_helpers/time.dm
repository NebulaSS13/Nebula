/proc/minutes_to_readable(minutes)
	if (!isnum(minutes))
		minutes = text2num(minutes)

	if (minutes < 0)
		PRINT_STACK_TRACE("Negative minutes value supplied to minutes_to_readable().")
		return "INFINITE"
	else if (isnull(minutes))
		PRINT_STACK_TRACE("Null minutes value supplied to minutes_to_readable().")
		return "BAD INPUT"
	
	var/hours = 0
	var/days = 0
	var/weeks = 0
	var/months = 0
	var/years = 0

	if (minutes >= 518400)
		years = round(minutes / 518400)
		minutes = minutes - (years * 518400)
	if (minutes >= 43200)
		months = round(minutes / 43200)
		minutes = minutes - (months * 43200)
	if (minutes >= 10080)
		weeks = round(minutes / 10080)
		minutes = minutes - (weeks * 10080)
	if (minutes >= 1440)
		days = round(minutes / 1440)
		minutes = minutes - (days * 1440)
	if (minutes >= 60)
		hours = round(minutes / 60)
		minutes = minutes - (hours * 60)

	var/result = list()
	if (years)
		result += "[years] year\s"
	if (months)
		result += "[months] month\s"
	if (weeks)
		result += "[weeks] week\s"
	if (days)
		result += "[days] day\s"
	if (hours)
		result += "[hours] hour\s"
	if (minutes)
		result += "[minutes] minute\s"

	return jointext(result, ", ")

/proc/get_game_time()
	var/static/time_offset = 0
	var/static/last_time = 0
	var/static/last_usage = 0

	var/wtime = world.time
	var/wusage = world.tick_usage * 0.01

	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1

	last_time = wtime
	last_usage = wusage

	return wtime + (time_offset + wusage) * world.tick_lag

var/global/roundstart_hour
var/global/station_date = ""
var/global/next_station_date_change = 1 DAY

/proc/stationtime2text()
	return time2text(station_time_in_ticks, "hh:mm")

/proc/stationdate2text()
	var/update_time = FALSE
	if(station_time_in_ticks > next_station_date_change)
		next_station_date_change += 1 DAY
		update_time = TRUE
	if(!station_date || update_time)
		var/extra_days = round(station_time_in_ticks / (1 DAY)) DAYS
		var/timeofday = world.timeofday + extra_days
		station_date = num2text(global.using_map.game_year) + "-" + time2text(timeofday, "MM-DD")
	return station_date

/proc/time_stamp()
	return time2text(station_time_in_ticks, "hh:mm:ss")

/* Returns 1 if it is the selected month and day */
/proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

var/global/next_duration_update = 0
var/global/last_round_duration = 0
var/global/round_start_time = 0

/hook/roundstart/proc/start_timer()
	round_start_time = world.time
	return 1

/proc/roundduration2text()
	if(!round_start_time)
		return "00:00"
	if(last_round_duration && world.time < next_duration_update)
		return last_round_duration

	var/mills = round_duration_in_ticks // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	mins = mins < 10 ? add_zero(mins, 1) : mins
	hours = hours < 10 ? add_zero(hours, 1) : hours

	last_round_duration = "[hours]:[mins]"
	next_duration_update = world.time + 1 MINUTES
	return last_round_duration

/hook/startup/proc/set_roundstart_hour()
	roundstart_hour = rand(0, 23)
	return TRUE

var/global/midnight_rollovers = 0
var/global/rollovercheck_last_timeofday = 0
/proc/update_midnight_rollover()
	if (world.timeofday < global.rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		global.midnight_rollovers += 1
	global.rollovercheck_last_timeofday = world.timeofday
	return global.midnight_rollovers

//Increases delay as the server gets more overloaded,
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
#define DELTA_CALC max(((max(world.tick_usage, world.cpu) / 100) * max(Master.sleep_delta-1,1)), 1)

/proc/stoplag(initial_delay)
	// If we're initializing, our tick limit might be over 100 (testing config), but stoplag() penalizes procs that go over.
	// 	Unfortunately, this penalty slows down init a *lot*. So, we disable it during boot and lobby, when relatively few things should be calling this.
	if (!Master || Master.current_runlevel < 3)
		sleep(world.tick_lag)
		return 1

	if (!initial_delay)
		initial_delay = world.tick_lag

	. = 0
	var/i = DS2TICKS(initial_delay)
	do
		. += NONUNIT_CEILING(i*DELTA_CALC, 1)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (world.tick_usage > min(TICK_LIMIT_TO_RUN, Master.current_ticklimit))

#undef DELTA_CALC

/proc/current_month_and_day()
	var/time_string = time2text(world.realtime, "MM-DD")
	var/time_list = splittext(time_string, "-")
	return list(text2num(time_list[1]), text2num(time_list[2]))
