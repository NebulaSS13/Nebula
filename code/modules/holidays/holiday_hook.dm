//Uncommenting ALLOW_HOLIDAYS in config.txt will enable this hook.
/hook/startup/proc/updateHoliday()
	if(config?.allow_holidays && fexists("config/holidays.json"))
		var/list/holidays = cached_json_decode(file2text("config/holidays.json"))
		if(length(holidays))

			var/c_year =    text2num(time2text(world.timeofday, "YY"))
			var/c_month =   text2num(time2text(world.timeofday, "MM"))
			var/c_day =     text2num(time2text(world.timeofday, "DD"))
			var/c_weekday = lowertext(time2text(world.timeofday, "DDD"))

			for(var/list/holiday_data in holidays)

				var/h_year =    holiday_data["year"]
				var/h_month =   holiday_data["month"]
				var/h_day =     holiday_data["day"]
				var/h_weekday = holiday_data["weekday"] 

				if((isnull(h_year)    || h_year  == c_year)  && \
				   (isnull(h_month)   || h_month == c_month) && \
				   (isnull(h_day)     || h_day   == c_day)   && \
				   (isnull(h_weekday) || h_weekday == c_weekday))
					var/holiday_path = text2path(holiday_data["path"]) || /datum/holiday
					set_holiday_data(new holiday_path(holiday_data))
					break

	return 1