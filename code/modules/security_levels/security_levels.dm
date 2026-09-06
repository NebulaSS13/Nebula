/// The default security state used on most space maps.
/decl/security_state/default
	all_security_levels = list(
		/decl/security_level/default/code_green,
		/decl/security_level/default/code_blue,
		/decl/security_level/default/code_red,
		/decl/security_level/default/code_delta
	)

/// An abstract security level type that supports announcements on level change.
/decl/security_level/default
	abstract_type = /decl/security_level/default

	var/static/datum/announcement/priority/security/security_announcement_up = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice1.ogg'))
	var/static/datum/announcement/priority/security/security_announcement_down = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice1.ogg'))

/decl/security_level/default/switching_up_to()
	if(up_description)
		security_announcement_up.Announce(up_description, "Attention! Alert level elevated to [name]!")
	notify_station()

/decl/security_level/default/switching_down_to()
	if(down_description)
		security_announcement_down.Announce(down_description, "Attention! Alert level changed to [name]!")
	notify_station()

/decl/security_level/default/proc/notify_station()
	for(var/obj/machinery/firealarm/FA in SSmachines.machinery)
		if(isContactLevel(FA.z))
			FA.update_icon()
	post_status("alert")

/decl/security_level/default/code_green
	name = "code green"

	light_range = 2
	light_power = 1

	light_color_alarm = COLOR_GREEN
	light_color_class = "font_green"
	light_color_status_display = COLOR_GREEN


	alarm_appearance = /datum/alarm_appearance/green

	down_description = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/decl/security_level/default/code_blue
	name = "code blue"

	light_range = 2
	light_power = 1
	light_color_alarm = COLOR_BLUE
	light_color_class = "font_blue"
	light_color_status_display = COLOR_BLUE

	alarm_appearance = /datum/alarm_appearance/blue

	up_description = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	down_description = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."

/decl/security_level/default/code_red
	name = "code red"

	light_range = 4
	light_power = 2
	light_color_alarm = COLOR_RED
	light_color_class = "font_red"
	light_color_status_display = COLOR_RED

	alarm_appearance = /datum/alarm_appearance/red

	up_description = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	down_description = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."

/decl/security_level/default/code_delta
	name = "code delta"

	light_range = 4
	light_power = 2
	light_color_alarm = COLOR_RED
	light_color_class = "font_red"
	light_color_status_display = COLOR_RED

	alarm_appearance = /datum/alarm_appearance/delta


	var/static/datum/announcement/priority/security/security_announcement_delta = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/effects/siren.ogg'))

/decl/security_level/default/code_delta/switching_up_to()
	security_announcement_delta.Announce("The self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.", "Attention! Delta security level reached!")
	notify_station()

// The following are dummy states and levels to soft-disable security levels on some maps.
/// A security state used for maps that don't have security levels exposed to players.
/decl/security_state/none
	all_security_levels = list(
		/decl/security_level/none
	)

/// A dummy security level with no effects.
/decl/security_level/none
	name = "none"
	// Since currently we're required to have an alarm_appearance, we just use a blank one.
	alarm_appearance = /datum/alarm_appearance