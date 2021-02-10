/area/constructionsite
	name = "\improper Construction Site"
	icon_state = "storage"

/area/maintenance/fsmaint2
	name = "\improper Fore Starboard Maintenance - 2"
	icon_state = "fsmaint"

/area/medical/surgery
	name = "\improper Operating Theatre"
	icon_state = "surgery"


/area/turbolift
	name = "\improper Example Elevator"
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

/area/turbolift/alert_on_fall(var/mob/living/carbon/human/H)
	if(H.client && SSpersistence.elevator_fall_shifts > 0)
		SSwebhooks.send(WEBHOOK_ELEVATOR_FALL, list("text" = "We managed to make it [SSpersistence.elevator_fall_shifts] shift\s without someone falling down an elevator shaft."))
		SSpersistence.elevator_fall_shifts = -1

/area/turbolift/first
	name = "Lower Level"
	base_turf = /turf/simulated/floor

/area/turbolift/second
	name = "Surgery Level"
	base_turf = /turf/simulated/open

/area/turbolift/third
	name = "Upper Level"
	base_turf = /turf/simulated/open
