/datum/daycycle_period
	abstract_type = /datum/daycycle_period
	/// In-character descriptor (ie. 'sunrise')
	var/name
	/// Message shown to outdoors players when the daycycle moves to this period.
	var/announcement
	/// 0-1 value to indicate where in the total day/night progression this falls.
	var/period
	/// Ambient light colour during this time of day.
	var/color
	/// Ambient light power during this time of day.
	var/power
	/// Ambient temperature modifier during this time of day.
	var/temperature

/datum/daycycle_period/sunrise
	name = "sunrise"
	announcement = "The sun peeks over the horizon, bathing the world in rosy light."
	period = 0.1
	color = COLOR_RED_LIGHT
	power = 0.5

/datum/daycycle_period/daytime
	name = "daytime"
	announcement = "The sun rises over the horizon, beginning another day."
	period = 0.4
	power = 0.8
	color = COLOR_DAYLIGHT

/datum/daycycle_period/sunset
	name = "sunset"
	announcement = "The sun begins to dip below the horizon, and the daylight fades."
	period = 0.6
	color = COLOR_ORANGE
	power = 0.5

/datum/daycycle_period/night
	name = "night"
	announcement = "Night falls, blanketing the world in darkness."
	period = 1
	color = COLOR_CYAN_BLUE
	power = 0.3

// Dummy period used by solars.
/datum/daycycle_period/permanent_daytime
	name = null
	announcement = null
	color = null
	power = null
	period = 1
