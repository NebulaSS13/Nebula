/datum/job/standard/captain/ministation
	supervisors = "your profit margin, your conscience, and the watchful eye of the Tradehouse Rep"
	outfit_type = /decl/outfit/job/ministation/captain
	hud_icon = 'maps/ministation/hud.dmi'
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_ADEPT,
		SKILL_SCIENCE  = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT   = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX
	)
	skill_points = 40

/datum/job/standard/captain/ministation/equip_job(var/mob/living/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	. = ..()
	if(H)
		H.verbs |= /mob/proc/freetradeunion_rename_company

/mob/proc/freetradeunion_rename_company()
	set name = "Defect from Tradehouse"
	set category = "Captain's Powers"
	var/company = sanitize(input(src, "What should your enterprise be called?", "Company name", global.using_map.company_name), MAX_NAME_LEN)
	if(!company)
		return
	var/company_s = sanitize(input(src, "What's the short name for it?", "Company name", global.using_map.company_short), MAX_NAME_LEN)
	if(company != global.using_map.company_name)
		if (company)
			global.using_map.company_name = company
		if(company_s)
			global.using_map.company_short = company_s
		command_announcement.Announce("Congratulations to all members of [capitalize(global.using_map.company_name)] on the new name. Their rebranding has changed the [global.using_map.company_short] market value by [0.01*rand(-10,10)]%.", "Trade Union Name Change")
	verbs -= /mob/proc/freetradeunion_rename_company

/datum/job/standard/hop/ministation
	title = "Lieutenant"
	outfit_type = /decl/outfit/job/ministation/hop
	hud_icon = 'maps/ministation/hud.dmi'
	hud_icon_state = "hudlieutenant"
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_EXPERT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_LITERACY = SKILL_MAX,
		SKILL_PILOT =   SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX
	)
	skill_points = 40
