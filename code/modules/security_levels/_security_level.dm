/decl/security_level
	var/icon = 'icons/misc/security_state.dmi'
	var/name

	// These values are primarily for station alarms and status displays, and which light colors and overlays to use
	var/light_range
	var/light_power
	var/light_color_alarm
	var/light_color_class
	var/light_color_status_display

	var/up_description
	var/down_description

	var/datum/alarm_appearance/alarm_appearance

	abstract_type = /decl/security_level

/decl/security_level/Initialize()
	. = ..()
	if(ispath(alarm_appearance, /datum/alarm_appearance))
		alarm_appearance = new alarm_appearance

/decl/security_level/validate()
	. = ..()
	var/initial_appearance = initial(alarm_appearance)
	if(!initial_appearance)
		. += "alarm_appearance was not set"
	else if(!ispath(initial_appearance))
		. += "alarm_appearance was not set to a /datum/alarm_appearance subpath"
	else if(!istype(alarm_appearance, /datum/alarm_appearance))
		. += "alarm_appearance creation failed (check runtimes?)"

// Called when we're switching from a lower security level to this one.
/decl/security_level/proc/switching_up_to()
	return

// Called when we're switching from a higher security level to this one.
/decl/security_level/proc/switching_down_to()
	return

// Called when we're switching from this security level to a higher one.
/decl/security_level/proc/switching_up_from()
	return

// Called when we're switching from this security level to a lower one.
/decl/security_level/proc/switching_down_from()
	return