/datum/alarm_appearance
	var/display_icon //The icon_state for the displays. Normally only one is used, unless uses_twotone_displays is TRUE.
	var/display_icon_color //The color for the display icon.

	var/display_icon_twotone //Used for two-tone displays.
	var/display_icon_twotone_color //The color for the display icon.

	var/display_emblem //The icon_state for the emblem, i.e for delta, a radstorm, alerts.
	var/display_emblem_color //The color for the emblem.

	var/alarm_icon //The icon_state for the alarms
	var/alarm_icon_color //the color for the icon_state

	var/alarm_icon_twotone //Used for two-tone alarms (i.e delta).
	var/alarm_icon_twotone_color //The color for the secondary tone icon.

/datum/alarm_appearance/green
	display_icon = "status_display_lines"
	display_icon_color = PIPE_COLOR_GREEN

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = PIPE_COLOR_GREEN

/datum/alarm_appearance/blue
	display_icon = "status_display_lines"
	display_icon_color = COLOR_BLUE

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_BLUE

/datum/alarm_appearance/red
	display_icon = "status_display_lines"
	display_icon_color = COLOR_RED

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_blinking"
	alarm_icon_color = COLOR_RED

/datum/alarm_appearance/delta
	display_icon = "status_display_twotone1"
	display_icon_color = COLOR_RED

	display_icon_twotone = "status_display_twotone2"
	display_icon_twotone_color = COLOR_YELLOW

	display_emblem = "delta"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_blinking_twotone1"
	alarm_icon_color = COLOR_RED

	alarm_icon_twotone = "alarm_blinking_twotone2"
	alarm_icon_twotone_color = PIPE_COLOR_YELLOW