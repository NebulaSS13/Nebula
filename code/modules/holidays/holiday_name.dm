//Allows GA and GM to set the Holiday variable
/client/proc/set_holiday(T as text|null)

	set name = "Set Holiday"
	set category = "Fun"
	set desc = "Override the default holiday."

	if(!check_rights(R_SERVER))
		return

	T = sanitize(T, MAX_NAME_LEN)
	if(T)
		if(get_config_value(/decl/config/toggle/allow_holidays))
			set_config_value(/decl/config/toggle/allow_holidays, TRUE)
		set_holiday_data(T, refresh_station_name = TRUE)
		to_world("<h4>[global.current_holiday.announcement]</h4>")
		message_admins(SPAN_NOTICE("ADMIN: Event: [key_name(src)] force-set the holiday to \"[global.current_holiday.name]\""))
		log_admin("[key_name(src)] force-set the holiday to \"[global.current_holiday.name]\"")
