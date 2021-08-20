/datum/job/ministation/robot
	title = "Robot"
	event_categories = list(ASSIGNMENT_ROBOT)
	total_positions = 1
	spawn_positions = 1
	supervisors = "your laws, the Lieutenant, and the Captain"
	selection_color = "#254c25"
	minimal_player_age = 7
	account_allowed = 0
	economic_power = 0
	loadout_allowed = FALSE
	outfit_type = /decl/hierarchy/outfit/job/silicon/cyborg
	hud_icon = "hudblank"
	skill_points = 0
	no_skill_buffs = TRUE
	guestbanned = 1	
	not_random_selectable = 1
	skip_loadout_preview = TRUE
	department_types = list(/decl/department/miscellaneous)

/datum/job/ministation/robot/handle_variant_join(var/mob/living/carbon/human/H, var/alt_title)
	if(H)
		return H.Robotize(SSrobots.get_mob_type_by_title(alt_title || title))

/datum/job/ministation/robot/equip(var/mob/living/carbon/human/H)
	return !!H

/datum/job/ministation/robot/New()
	..()
	alt_titles = SSrobots.robot_alt_titles.Copy()
	alt_titles -= title
