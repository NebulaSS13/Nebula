/proc/cmp_departments_dsc(var/decl/department/a, var/decl/department/b)
	. = b.display_priority - a.display_priority

/decl/department
	var/name
	var/noun = "department"
	var/noun_adj = "departmental"
	var/announce_channel = "Common" // The Channel for spawn annoncement. Leave as common if unsure. The channel will be selected based of the first deparment listed in a jobs .department_types
	var/list/goals = list() 
	var/min_goals = 1
	var/max_goals = 2
	var/colour = "#808080"
	var/request_console_flags = 0   // use RC_ASSIST etc here to control department console behavior
	var/display_priority = 0
	var/display_color = "#ffffff"

/decl/department/Initialize()
	. = ..()
	if(LAZYLEN(goals) <= 0)
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
		req_console_assistance |= name
	if (request_console_flags & RC_SUPPLY)
		req_console_supplies |= name
	if (request_console_flags & RC_INFO)
		req_console_information |= name

/decl/department/proc/summarize_goals(var/show_success = FALSE)
	. = list()
	for(var/i = 1 to LAZYLEN(goals))
		var/datum/goal/goal = goals[i]
		. += "[i]. [goal.summarize(show_success, position = i)]"

/decl/department/proc/update_progress(var/goal_type, var/progress)
	var/datum/goal/goal = locate(goal_type) in goals
	if(goal)
		goal.update_progress(progress)