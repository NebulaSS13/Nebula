/decl/special_role/loyalist
	name = "Head Loyalist"
	name_plural = "Loyalists"
	feedback_tag = "loyalist_objective"
	antag_indicator = "hud_loyal_head"
	victory_text = "The heads of staff remained at their posts! The loyalists win!"
	loss_text = "The heads of staff did not stop the revolution!"
	victory_feedback_tag = "win - rev heads killed"
	loss_feedback_tag = "loss - heads killed"
	antaghud_indicator = "hudloyalist"
	flags = 0
	blocked_job_event_categories = list(ASSIGNMENT_ROBOT, ASSIGNMENT_COMPUTER)

	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 2
	initial_spawn_target = 4

	// Inround loyalists.
	faction_name = "Loyalist"
	faction_descriptor = "COMPANY"
	faction_verb = /mob/living/proc/convert_to_loyalist
	faction_indicator = "hud_loyal"
	faction_invisible = 1
	blacklisted_jobs = list(/datum/job/submap)
	skill_setter = /datum/antag_skill_setter/station
	faction = "loyalist"
	var/command_department_id

/decl/special_role/loyalist/Initialize()
	if(!command_department_id)
		command_department_id = global.using_map.default_department_type
	. = ..()
	welcome_text = "You belong to the [global.using_map.company_name], body and soul. Preserve its interests against the conspirators amongst the crew."
	faction_welcome = "Preserve [global.using_map.company_short]'s interests against the traitorous recidivists amongst the crew. Protect the heads of staff with your life."
	faction_descriptor = "[global.using_map.company_name]"

/decl/special_role/loyalist/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	for(var/mob/living/carbon/human/player in SSmobs.mob_list)
		if(!player.mind || player.stat==2 || !(player.mind.assigned_role in SSjobs.titles_by_department(command_department_id)))
			continue
		var/datum/objective/protect/loyal_obj = new
		loyal_obj.target = player.mind
		loyal_obj.explanation_text = "Protect [player.real_name], the [player.mind.assigned_role]."
		global_objectives += loyal_obj
