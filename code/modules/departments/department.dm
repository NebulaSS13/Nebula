/proc/cmp_departments_dsc(var/decl/department/a, var/decl/department/b)
	. = b.display_priority - a.display_priority

var/list/departments_by_reference
/proc/get_department_by_reference(var/dept_ref)
	if(!global.departments_by_reference)
		global.departments_by_reference = list()
		var/list/all_departments = decls_repository.get_decls_of_subtype(/decl/department)
		for(var/dtype in all_departments)
			var/decl/department/dept = all_departments[dtype]
			if(dept.reference)
				global.departments_by_reference[dept.reference] = dept
		global.departments_by_reference = sortTim(global.departments_by_reference, /proc/cmp_departments_dsc, TRUE)
	. = global.departments_by_reference[dept_ref]

/decl/department
	var/title = "Undefined"         // Player facing. Can be changed freely without breaking code or updating refrences in jobs.
	var/reference = "undefined"     // Code facing. Jobs reference their department by this.
	var/announce_channel = "Common" // The Channel for spawn annoncement. Leave as common if unsure. The channel will be selected based of the first deparment listed in a jobs .department_refs
	var/list/goals = list() 
	var/min_goals = 1
	var/max_goals = 2
	var/colour = "#808080"
	var/request_console_flags = 0   // use RC_ASSIST etc here to control department console behavior
	var/display_priority = 0

/decl/department/Initialize()
	. = ..()
	if(!reference || LAZYLEN(goals) <= 0)
		return
	var/list/possible_goals = goals.Copy()
	goals.Cut()
	var/goals_to_pick = min(LAZYLEN(possible_goals), rand(min_goals, max_goals))
	while(goals_to_pick && LAZYLEN(possible_goals))
		var/goal = pick_n_take(possible_goals)
		var/datum/goal/deptgoal = new goal(src)
		if(deptgoal.is_valid())
			LAZYADD(goals, deptgoal)
			goals_to_pick--
		else
			qdel(deptgoal)
	if (request_console_flags & RC_ASSIST)
		req_console_assistance |= reference
	if (request_console_flags & RC_SUPPLY)
		req_console_supplies |= reference
	if (request_console_flags & RC_INFO)
		req_console_information |= reference

/decl/department/proc/summarize_goals(var/show_success = FALSE)
	. = list()
	for(var/i = 1 to LAZYLEN(goals))
		var/datum/goal/goal = goals[i]
		. += "[i]. [goal.summarize(show_success, position = i)]"

/decl/department/proc/update_progress(var/goal_type, var/progress)
	var/datum/goal/goal = locate(goal_type) in goals
	if(goal)
		goal.update_progress(progress)