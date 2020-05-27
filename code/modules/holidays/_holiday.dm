var/datum/holiday/current_holiday

/datum/holiday
	var/name
	var/announcement
	var/list/station_suffixes
	var/list/station_prefixes

/datum/holiday/New(var/list/holiday_data)
	..()
	name = holiday_data["name"] || "Null Day"
	station_suffixes = holiday_data["suffixes"]
	station_prefixes = holiday_data["prefixes"]
	if(!announcement)
		announcement = "Happy [name], everyone!"
	if(!length(station_prefixes))
		LAZYINITLIST(station_prefixes)
		var/add_prefix = sanitize(copytext(name, 1, findtext(name," ",1,0)), MAX_NAME_LEN)
		if(add_prefix)
			station_prefixes += add_prefix

/datum/holiday/proc/set_up_holiday()
	return

/proc/set_holiday_data(var/datum/holiday/holiday_data, var/refresh_station_name = FALSE)
	if(istext(holiday_data))
		holiday_data = new(list("name" = holiday_data))
	if(!holiday_data || !istype(holiday_data))
		return
	global.current_holiday = holiday_data
	if(refresh_station_name)
		GLOB.using_map.station_name = null
		station_name()
		world.update_status()
