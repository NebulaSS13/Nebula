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
	var/active_goals_copied_yet = FALSE
	var/list/goals_to_process = list()
	var/goal_index = 1

/datum/controller/subsystem/goals/fire(resumed)
	if(!resumed)
		active_goals_copied_yet = FALSE
		goal_index = 1
	if(!active_goals_copied_yet)
		active_goals_copied_yet = TRUE
		goals_to_process = pending_goals.Copy()
	while(goal_index <= goals_to_process.len)
		var/datum/goal/goal = goals_to_process[goal_index++]
		if(goal.try_initialize())
			pending_goals -= goal
		if (MC_TICK_CHECK)
			return
	if(!length(pending_goals))
		disable()

/datum/controller/subsystem/goals/proc/update_department_goal(var/department_type, var/goal_type, var/progress)
	var/decl/department/dept = SSjobs.get_department_by_type(department_type)
	if(dept)
		dept.update_progress(goal_type, progress)

/datum/controller/subsystem/goals/proc/get_roundend_summary()

	. = list()
	var/list/all_departments = decls_repository.get_decls_of_subtype(/decl/department)
	for(var/dtype in all_departments)
		var/decl/department/dept = all_departments[dtype]
		if(LAZYLEN(dept.goals))
			. += "<b>[dept.name] had the following [dept.noun] goals:</b>"
			. += dept.summarize_goals(show_success = TRUE)

	if(LAZYLEN(.))
		. = "<br>[jointext(., "<br>")]"
	else
		. = "<br><b>There were no departmental goals this round.</b>"
