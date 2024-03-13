/area/example
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/example/first
	name = "\improper Testing Site First Floor"
	icon_state = "fsmaint"

/area/example/second
	name = "\improper Testing Site Second Floor"
	icon_state = "surgery"

/area/example/third
	name = "\improper Testing Site Third Floor"
	icon_state = "storage"

/area/turbolift/example
	name = "\improper Testing Site Elevator"
	icon_state = "shuttle"
	requires_power = FALSE
	dynamic_lighting = TRUE
	sound_env = STANDARD_STATION
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	ambience = list(
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/ambigen5.ogg',
		'sound/ambience/ambigen6.ogg',
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg'
	)
	arrival_sound = null
	lift_announce_str = null

	base_turf = /turf/open

/area/turbolift/example/first
	name = "Testing Site First Floor Lift"
	base_turf = /turf/floor

/area/turbolift/example/second
	name = "Testing Site Second Floor Lift"

/area/turbolift/example/third
	name = "Testing Site Third Floor Lift"

/area/shuttle/ferry
	name = "\improper Testing Site Ferry"
	icon_state = "shuttle"
