/decl/department/command
	goals = list(/datum/goal/department/paperwork/exodus)

var/global/list/exodus_paperwork_spawn_turfs = list()
var/global/list/exodus_paperwork_end_areas = list()

/obj/abstract/landmark/paperwork_spawn_exodus
	name = "Exodus Paperwork Goal Spawn Point"

/obj/abstract/landmark/paperwork_spawn_exodus/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		global.exodus_paperwork_spawn_turfs |= T
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/paperwork_finish_exodus
	name = "Exodus Paperwork Goal Finish Point"

/obj/abstract/landmark/paperwork_finish_exodus/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		var/area/A = get_area(T)
		if(istype(A))
			global.exodus_paperwork_end_areas |= A
	return INITIALIZE_HINT_QDEL

/datum/goal/department/paperwork/exodus
	paperwork_types = list(/obj/item/paperwork/exodus)
	signatory_job_list = list(
		/datum/job/standard/captain,
		/datum/job/standard/hop,
		/datum/job/standard/cmo,
		/datum/job/standard/chief_engineer,
		/datum/job/standard/rd,
		/datum/job/standard/hos
	)

/datum/goal/department/paperwork/exodus/get_paper_spawn_turfs()
	return global.exodus_paperwork_spawn_turfs

/datum/goal/department/paperwork/exodus/get_paper_end_areas()
	return global.exodus_paperwork_end_areas

/obj/item/paperwork/exodus
	name = "\improper Exodus payroll paperwork"
	desc = "A complex list of salaries, hours and tax withheld for Exodus workers this month."
