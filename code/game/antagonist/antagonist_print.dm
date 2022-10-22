/decl/special_role/proc/print_player_summary()

	if(!current_antagonists.len)
		return 0

	var/text = list()
	text += "<br><br><font size = 2><b>The [current_antagonists.len == 1 ? "[name] was" : "[name_plural] were"]:</b></font>"
	for(var/datum/mind/P in current_antagonists)
		text += print_player(P)
		text += get_special_objective_text(P)
		if(!global_objectives.len && P.objectives && P.objectives.len)
			var/num = 1
			for(var/datum/objective/O in P.objectives)
				text += print_objective(O, num)
				num++

		var/datum/goal/ambitions = SSgoals.ambitions[P]
		if(ambitions)
			text += "<br>Their goals for today were..."
			text += "<br><span class='notice'>[ambitions.summarize()]</span>"

	if(global_objectives && global_objectives.len)
		text += "<BR><FONT size = 2>Their objectives were:</FONT>"
		var/num = 1
		for(var/datum/objective/O in global_objectives)
			text += print_objective(O, num)
			num++

	// Display the results.
	text += "<br>"
	to_world(jointext(text,null))

/decl/special_role/proc/print_objective(var/datum/objective/O, var/num)
	return "<br><b>Objective [num]:</b> [O.explanation_text] "

/decl/special_role/proc/print_player(var/datum/mind/ply)

	var/role
	if(ply.assigned_role)
		role = ply.assigned_role
	else 
		role = ply.get_special_role_name("unknown role")
	role = "\improper [role]"

	var/text = "<br><b>[ply.name]</b> (<b>[ply.key]</b>) as \a <b>[role]</b> ("
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += "died"
		else if(isNotStationLevel(ply.current.z))
			text += "fled"
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += "body destroyed"
	text += ")"

	return text
