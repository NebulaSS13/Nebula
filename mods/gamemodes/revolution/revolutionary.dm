/decl/special_role/revolutionary
	name = "Head Revolutionary"
	name_plural = "Revolutionaries"
	antag_indicator = "hud_rev_head"
	welcome_text = "Down with the capitalists! Down with the Bourgeoise!"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	antaghud_indicator = "hudrevolutionary"
	skill_setter = /datum/antag_skill_setter/station
	blocked_job_event_categories = list(ASSIGNMENT_ROBOT, ASSIGNMENT_COMPUTER)

	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 2
	initial_spawn_target = 4

	//Inround revs.
	faction_name = "Revolutionary"
	faction_descriptor = "Revolution"
	faction_verb = /mob/living/proc/convert_to_rev
	faction_welcome = "Help the cause overturn the ruling class. Do not harm your fellow freedom fighters."
	faction_indicator = "hud_rev"
	faction_invisible = 1
	faction = "revolutionary"

	blacklisted_jobs = list(/datum/job/submap)
	var/command_department_id

/decl/special_role/revolutionary/Initialize()
	if(!command_department_id)
		command_department_id = global.using_map.default_department_type
	. = ..()

/decl/special_role/revolutionary/create_global_objectives()
	if(!..())
		return
	global_objectives = list()
	for(var/mob/living/human/player in SSmobs.mob_list)
		if(!player.mind || player.stat == DEAD || !(player.mind.assigned_role in SSjobs.titles_by_department(command_department_id)))
			continue
		var/datum/objective/rev/rev_obj = new
		rev_obj.target = player.mind
		rev_obj.explanation_text = "Assassinate, capture or convert [player.real_name], the [player.mind.assigned_role]."
		global_objectives += rev_obj

/decl/special_role/revolutionary/equip_role(var/mob/living/human/player)
	. = ..()
	if(.)
		spawn_uplink(player)

/decl/special_role/revolutionary/proc/spawn_uplink(var/mob/living/human/revolutionary_mob)
	setup_uplink_source(revolutionary_mob, DEFAULT_TELECRYSTAL_AMOUNT)

/mob/living/proc/convert_to_rev(mob/M in able_mobs_in_oview(src))
	set name = "Recruit to Faction"
	set category = "Abilities"

	if(!M.mind || !M.client)
		return

	convert_to_faction(M.mind, GET_DECL(/decl/special_role/revolutionary))