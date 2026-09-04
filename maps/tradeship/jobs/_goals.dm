var/global/list/tradeship_paperwork_spawn_turfs = list()
var/global/list/tradeship_paperwork_end_areas = list()

/obj/abstract/landmark/paperwork_spawn_tradeship
	name = "Tradeship Paperwork Goal Spawn Point"

/obj/abstract/landmark/paperwork_spawn_tradeship/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		global.tradeship_paperwork_spawn_turfs |= T
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/paperwork_finish_tradeship
	name = "Tradeship Paperwork Goal Finish Point"

/obj/abstract/landmark/paperwork_finish_tradeship/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		var/area/A = get_area(T)
		if(istype(A))
			global.tradeship_paperwork_end_areas |= A
	return INITIALIZE_HINT_QDEL

/datum/goal/department/paperwork/tradeship
	paperwork_types =    list(/obj/item/paperwork/tradeship)
	signatory_job_list = list(
		/datum/job/standard/captain/tradeship,
		/datum/job/tradeship_first_mate
	)

/datum/goal/department/paperwork/tradeship/get_paper_spawn_turfs()
	return global.tradeship_paperwork_spawn_turfs

/datum/goal/department/paperwork/tradeship/get_paper_end_areas()
	return global.tradeship_paperwork_end_areas

/obj/item/paperwork/tradeship
	name = "\improper Tradehouse payroll paperwork"
	desc = "A complex list of salaries, hours and tax withheld for Tradehouse workers this month."
