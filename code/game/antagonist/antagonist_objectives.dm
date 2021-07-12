/decl/special_role/proc/create_global_objectives(var/override=0)
	if(config.objectives_disabled != CONFIG_OBJECTIVE_ALL && !override)
		return 0
	if(global_objectives && global_objectives.len)
		return 0
	return 1

/decl/special_role/proc/create_objectives(var/datum/mind/player, var/override=0)
	if(config.objectives_disabled != CONFIG_OBJECTIVE_ALL && !override)
		return 0
	if(create_global_objectives(override) || global_objectives.len)
		player.objectives |= global_objectives
	return 1

/decl/special_role/proc/get_special_objective_text()
	return ""

/mob/proc/add_objectives()
	set name = "Get Objectives"
	set desc = "Recieve optional objectives."
	set category = "OOC"

	src.verbs -= /mob/proc/add_objectives

	if(!src.mind)
		return

	var/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
	for(var/tag in all_antag_types) //we do all of them in case an admin adds an antagonist via the PP. Those do not show up in gamemode.
		var/decl/special_role/antagonist = all_antag_types[tag]
		if(antagonist && antagonist.is_antagonist(src.mind))
			antagonist.create_objectives(src.mind,1)

	to_chat(src, "<b><font size=3>These objectives are completely voluntary. You are not required to complete them.</font></b>")
	show_objectives(src.mind)

/mob/living/proc/set_ambition()
	set name = "Set Ambition"
	set category = "IC"
	set src = usr

	if(!mind)
		return

	if(!is_special_character(mind))
		to_chat(src, SPAN_WARNING("While you may perhaps have goals, this verb's meant to only be visible \
		to antagonists. Please make a bug report!"))
		return

	var/datum/goal/ambition/goals = SSgoals.ambitions[mind]
	var/new_goal = sanitize(input(src, "Write down what you want to achieve in this round as an antagonist \
	- your goals. They will be visible to all players after the end of the round. \
	remember you cannot rewrite them - only add new lines.", "Antagonist Goal") as null|message)
	if(!isnull(new_goal))
		if(!goals)
			goals = new /datum/goal/ambition(mind)
		goals.description += "<br>[roundduration2text()]: [new_goal]"
		to_chat(src, SPAN_NOTICE("Your ambitions now look like this: <b>[goals.description]</b>."))
		to_chat(src, SPAN_NOTICE("You can view your ambitions in the <b>Notes</b> panel, or with the <b>Show Goals</b> verb. If you wish to change your ambition, \
		please contact to Administator."))
		log_and_message_admins("has updated their ambitions. New one: [new_goal]")

//some antagonist datums are not actually antagonists, so we might want to avoid
//sending them the antagonist meet'n'greet messages.
//E.G. ERT
/decl/special_role/proc/show_objectives_at_creation(var/datum/mind/player)
	if(src.show_objectives_on_creation)
		show_objectives(player)