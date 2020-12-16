SUBSYSTEM_DEF(goals)
	name = "Goals"
	init_order = SS_INIT_GOALS
	wait = 1 SECOND
	var/list/global_personal_goals = list(
		/datum/goal/achievement/specific_object/food,
		/datum/goal/achievement/specific_object/drink,
		/datum/goal/achievement/specific_object/pet,
		/datum/goal/achievement/fistfight,
		/datum/goal/achievement/graffiti,
		/datum/goal/achievement/newshound,
		/datum/goal/achievement/givehug,
		/datum/goal/achievement/gethug,
		/datum/goal/movement/walk,
		/datum/goal/movement/walk/eva,
		/datum/goal/clean,
		/datum/goal/money
	)
	var/list/ambitions = list()
	var/list/pending_goals = list()

/datum/controller/subsystem/goals/fire(resumed)
	for(var/datum/goal/goal in pending_goals)
		if(goal.try_initialize())
			pending_goals -= goal
	if(!length(pending_goals))
		flags |= SS_NO_FIRE

/datum/controller/subsystem/goals/proc/update_department_goal(var/department_ref, var/goal_type, var/progress)
	var/datum/department/dept = SSdepartments.departments[department_ref]
	if(dept)
		dept.update_progress(goal_type, progress)

/datum/controller/subsystem/goals/proc/get_roundend_summary()
	. = list()
	for(var/thing in SSdepartments.departments)
		var/datum/department/dept = SSdepartments.departments[thing]
		if (LAZYLEN(SSjobs.titles_by_department(dept)))
			. += "<b>[dept.title] had the following shift goals:</b>"
			. += dept.summarize_goals(show_success = TRUE)
	if(LAZYLEN(.))
		. = "<br>[jointext(., "<br>")]"
	else
		. = "<br><b>There were no departmental goals this round.</b>"
