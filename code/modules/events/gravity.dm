/datum/event/gravity
	announceWhen = 5

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system reinitializes.", "[location_name()] Gravity Subsystem", zlevels = affecting_z)

/datum/event/gravity/start()
	for(var/area/A in global.areas)
		if(A.z in affecting_z)
			A.gravitychange(FALSE)

/datum/event/gravity/end()
	for(var/area/A in global.areas)
		if((A.z in affecting_z) && initial(A.has_gravity))
			A.gravitychange(TRUE)

	command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "[location_name()] Gravity Subsystem", zlevels = affecting_z)
