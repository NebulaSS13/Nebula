var/global/area/space_area

/area/space
	name = "\improper Space"
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = TRUE
	power_light = 0
	power_equip = 0
	power_environ = 0
	has_gravity = 0
	area_flags = AREA_FLAG_EXTERNAL | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_BACKGROUND | AREA_FLAG_HIDE_FROM_HOLOMAP
	ambience = list('sound/ambience/ambispace1.ogg','sound/ambience/ambispace2.ogg','sound/ambience/ambispace3.ogg','sound/ambience/ambispace4.ogg','sound/ambience/ambispace5.ogg')
	is_outside = OUTSIDE_YES

/area/space/Initialize()
	. = ..()
	if(global.space_area)
		PRINT_STACK_TRACE("Space area created twice!")
	global.space_area = src

/area/space/has_gravity()
	return 0

/area/space/atmosalert()
	return

/area/space/fire_alert()
	return

/area/space/fire_reset()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return
