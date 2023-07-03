
//No point increase over time
/datum/controller/subsystem/supply/Initialize()
	. = ..()
	points = 0
	points_per_process = 0